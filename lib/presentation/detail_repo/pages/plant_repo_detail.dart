// File: lib/presentation/detail_repo/pages/plant_repo_detail.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_pallete.dart';
import 'package:flutter_application_1/presentation/detail_repo/widgets/persiapan_widget.dart';
import 'package:flutter_application_1/presentation/detail_repo/widgets/perawatan_widget.dart';
import 'package:flutter_application_1/presentation/detail_repo/widgets/ringkasan_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlantRepoDetail extends StatefulWidget {
  final int repoTanamId;

  const PlantRepoDetail({super.key, required this.repoTanamId});

  @override
  State<PlantRepoDetail> createState() => _PlantRepoDetailState();
}

class _PlantRepoDetailState extends State<PlantRepoDetail> {
  final supabase = Supabase.instance.client;
  Map<String, dynamic>? _plantData;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchPlantData();
  }

  Future<void> _fetchPlantData() async {
    try {
      final response = await supabase
          .from('repo_tanaman')
          .select(
            'nama_statis, nama_ilmiah, jenis_tanaman, persiapan, perawatan, ringkasan, image_url',
          )
          .eq('id', widget.repoTanamId)
          .single();

      if (!mounted) return;

      // ✅ Debug: Cek semua field
      print("=== DATA DARI SUPABASE ===");
      print("ID: ${response['id']}");
      print("Nama: ${response['nama_statis']}");
      print("Persiapan: ${response['persiapan']}");
      print("Perawatan: ${response['perawatan']}");
      print("Perawatan Type: ${response['perawatan'].runtimeType}");
      print("Perawatan Is Null: ${response['perawatan'] == null}");
      print("Perawatan Is Empty: ${response['perawatan'] == []}");

      setState(() {
        _plantData = response;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

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
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 50, color: Colors.red),
              const SizedBox(height: 16),
              Text("Error: $_errorMessage"),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchPlantData,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_plantData == null) {
      return const Scaffold(body: Center(child: Text('Data tidak ditemukan')));
    }

    // ✅ Konversi data dari database ke List<String> dengan aman
    final List<String> persiapan =
        (_plantData!['persiapan'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .cast<String>()
            .toList() ??
        [];

    final List<String> perawatan =
        (_plantData!['perawatan'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .cast<String>()
            .toList() ??
        [];

    // ✅ Debug: Cek data yang akan ditampilkan
    print("=== DATA UNTUK WIDGET ===");
    print("Persiapan: $persiapan");
    print("Perawatan: $perawatan");
    print("Perawatan Length: ${perawatan.length}");

    final nama = _plantData!['nama_statis'] ?? 'Tanaman Tanpa Nama';
    final jenis = _plantData!['jenis_tanaman'] ?? [];
    final imageUrl = _plantData!['image_url'] ?? '';
    final namaIlmiah = _plantData!['nama_ilmiah'] ?? '';

    final displayImage = imageUrl.isNotEmpty
        ? imageUrl
        : 'https://images.unsplash.com/photo-1596541673894-24b591032323?q=80&w=2070&auto=format&fit=crop';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gambar
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              displayImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),

          // Tombol back
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF0F8E9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 18,
                        color:  Color(0xff305412),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Container putih rounded
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.70,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, -3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nama,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: AppPallete.primaryDarkActive,
                        ),
                      ),
                      Text(
                        namaIlmiah,
                        style: TextStyle(
                          color: AppPallete.primaryDark,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildLabel("Ringkasan"),
                          const SizedBox(width: 12),
                          _buildLabel("Persiapan"),
                          const SizedBox(width: 12),
                          _buildLabel("Perawatan"),
                        ],
                      ),
                      // Ringkasan
                      const SizedBox(height: 16),
                      RingkasanWidget(
                        ringkasan:
                            _plantData!['ringkasan'] ??
                            "Belum ada ringkasan untuk tanaman ini.",
                      ),

                      const SizedBox(height: 24),

                      // Persiapan
                      const SizedBox(height: 12),
                      PersiapanWidget(persiapan: persiapan),

                      const SizedBox(height: 24),

                      // Perawatan
                      const SizedBox(height: 12),
                      PerawatanWidget(perawatan: perawatan),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildLabel(String text, {TextStyle? style}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppPallete.primaryDark, width: 1),
      ),
      child: Text(
        text,
        style:
            style ??
            const TextStyle(color: AppPallete.primaryDark, fontSize: 12),
      ),
    );
  }
}
