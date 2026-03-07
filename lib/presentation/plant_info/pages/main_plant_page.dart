import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/plant_info/widget/plant_card.dart';
import 'package:flutter_application_1/presentation/plant_info/widget/side_long_card.dart';
import 'package:flutter_application_1/presentation/plant_info/widget/simple_appbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlantInfo extends StatefulWidget {
  const PlantInfo({super.key});

  @override
  State<PlantInfo> createState() => _PlantInfoState();
}

class _PlantInfoState extends State<PlantInfo> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _repoTanam = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _getRepoTanam();
  }

  Future<void> _getRepoTanam() async {
    try {
      final data = await supabase.from('repo_tanaman').select();

      print("Response: $data"); // debug print

      setState(() {
        _repoTanam = List<Map<String, dynamic>>.from(data);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  String _parseList(dynamic value) {
    if (value == null) return '';
    if (value is List) {
      return value.map((e) => e.toString()).join(', ');
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? Center(child: Text("Error: $_errorMessage"))
          : _repoTanam.isEmpty
          ? const Center(child: Text("Belum ada data"))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  "E-Course",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16),
                SideLongCard(
                  imageUrl:
                      'https://i.pinimg.com/736x/6c/cf/87/6ccf873cb76d7a5e6651271758e7ce81.jpg',
                  title: 'Plant Course',
                  subtitle: 'Lihat Sekarang',
                ),
                const SizedBox(height: 16),
                const Text(
                  "Repository",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true, // penting biar bisa di dalam ListView
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 168 / 202,
                  ),
                  itemCount: _repoTanam.length,
                  itemBuilder: (context, index) {
                    final tanaman = _repoTanam[index];
                    final nama =
                        tanaman['nama_statis']?.toString() ??
                        'Tanaman Tanpa Nama';
                    final jenis = _parseList(tanaman['jenis_tanaman']);
                    final imageUrl = tanaman['image_url']?.toString() ?? '';
                    final displayImage = imageUrl.isNotEmpty
                        ? imageUrl
                        : 'https://images.unsplash.com/photo-1596541673894-24b591032323?q=80&w=2070&auto=format&fit=crop';
                    final namaIlmiah =
                        tanaman['nama_ilmiah']?.toString() ?? jenis;

                    return PlantCard(
                      imageUrl: displayImage,
                      namaAsli: nama,
                      namaIlmiah: namaIlmiah,
                    );
                  },
                ),
              ],
            ),
    );
  }
}
