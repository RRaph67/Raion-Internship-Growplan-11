import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/detail_repo/pages/plant_repo_detail.dart';
import 'package:flutter_application_1/presentation/plant_info/widget/plant_card.dart';
import 'package:flutter_application_1/presentation/plant_info/widget/side_long_card.dart';
import 'package:flutter_application_1/core/theme/app_pallete.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlantInfo extends StatefulWidget {
  const PlantInfo({super.key});

  @override
  State<PlantInfo> createState() => _PlantInfoState();
}

class _PlantInfoState extends State<PlantInfo> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _repoTanam = [];
  List<Map<String, dynamic>> _filteredRepoTanam = [];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isDisposed = false;

  final List<String> _categories = ['Semua', 'Hias', 'Herbal', 'Sayur'];
  String _selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    _getRepoTanam();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _getRepoTanam() async {
    try {
      final data = await supabase.from('repo_tanaman').select();

      if (!mounted || _isDisposed) return;

      setState(() {
        _repoTanam = List<Map<String, dynamic>>.from(data);
        _filteredRepoTanam = _repoTanam;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted || _isDisposed) return;

      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilter(String category) {
    setState(() {
      _selectedCategory = category;

      if (category == 'Semua') {
        _filteredRepoTanam = _repoTanam;
      } else {
        _filteredRepoTanam = _repoTanam.where((item) {
          final jenisTanaman = item['jenis_tanaman'] as String?;

          if (jenisTanaman == null || jenisTanaman.trim().isEmpty) return false;

          return jenisTanaman.trim().toLowerCase() == category.toLowerCase();
        }).toList();
      }
    });
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
                const SizedBox(height: 24),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            _applyFilter(category);
                          },
                          child: Container(
                            height: 32,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppPallete.primaryDark
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: isSelected
                                    ? AppPallete.primaryDark
                                    : AppPallete.primaryDark,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 16,
                                color: isSelected
                                    ? Colors.white
                                    : AppPallete.primaryDark,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),
                const Text(
                  "Repository",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 16),

                if (_filteredRepoTanam.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Tidak ada tanaman ditemukan",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 168 / 202,
                        ),
                    itemCount: _filteredRepoTanam.length,
                    itemBuilder: (context, index) {
                      final tanaman = _filteredRepoTanam[index];
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

                      return GestureDetector(
                        onTap: () {
                          final repoTanamId = tanaman['id'] as int;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PlantRepoDetail(repoTanamId: repoTanamId),
                            ),
                          );
                        },
                        child: PlantCard(
                          imageUrl: displayImage,
                          namaAsli: nama,
                          namaIlmiah: namaIlmiah,
                        ),
                      );
                    },
                  ),
              ],
            ),
    );
  }
}
