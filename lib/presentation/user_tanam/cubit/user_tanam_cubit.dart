import 'package:flutter_application_1/presentation/user_tanam/cubit/user_tanam_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/data/models/user_tanam_model.dart';

class UserTanamCubit extends Cubit<UserTanamState> {
  final SupabaseClient _supabase;

  // Cache lokal untuk menyimpan daftar tanaman agar transisi UI lebih mulus
  List<UserTanamModel> _cachedList = [];

  UserTanamCubit(this._supabase) : super(UserTanamInitial());

  void resetState() {
    emit(UserTanamInitial());
  }

  /// Mengambil detail tanaman spesifik berdasarkan ID
  Future<void> loadPlantInfo(String userId, int userTanamId) async {
    emit(UserTanamLoading());

    try {
      final response = await _supabase
          .from('user_tanam')
          .select('*, repo_tanaman(*)')
          .eq('id', userTanamId)
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        emit(UserTanamError('Tanaman tidak ditemukan'));
        return;
      }

      final model = UserTanamModel.fromMap(response);
      final now = DateTime.now();
      final plantedDate = model.tanggalTanam;
      final days = now.difference(plantedDate).inDays;

      emit(UserTanamLoaded(model, days));
    } catch (e) {
      emit(UserTanamError(e.toString()));
    }
  }

  /// Mengambil semua daftar tanaman milik user yang sedang login
  Future<void> fetchUserTanamList() async {
    emit(UserTanamLoading());
    try {
      final currentUserId = _supabase.auth.currentUser?.id ?? '';

      final response = await _supabase
          .from('user_tanam')
          .select('*, repo_tanaman(*)')
          .eq('user_id', currentUserId)
          .order('created_at', ascending: false);

      _cachedList = response.map((e) => UserTanamModel.fromMap(e)).toList();
      emit(UserTanamListLoaded(_cachedList));
    } catch (e) {
      emit(UserTanamError(e.toString()));
    }
  }

  /// Mengembalikan state ke daftar tanpa fetch ulang ke database
  void restoreList() {
    if (_cachedList.isNotEmpty) {
      emit(UserTanamListLoaded(_cachedList));
    } else {
      fetchUserTanamList();
    }
  }

  /// Menambahkan tanaman baru ke koleksi user
  /// Menggunakan .limit(1) untuk menghindari error jika satu jenis memiliki banyak entri di repo
  Future<void> addUserTanamByJenis({
    required String namaTanam,
    required DateTime tanggalTanam,
    required String jenisTanaman,
    required String imageUrl,
  }) async {
    emit(UserTanamLoading());
    try {
      // MENGATASI ERROR 406: Mencari ID referensi dari repo_tanaman
      // Kita gunakan .limit(1) karena 'jenis_tanaman' (misal: 'Hias') bisa ditemukan di banyak baris
      final List<dynamic> repoResponse = await _supabase
          .from('repo_tanaman')
          .select('id')
          .eq('jenis_tanaman', jenisTanaman)
          .limit(1);

      if (repoResponse.isEmpty) {
        emit(
          UserTanamError(
            'Kategori "$jenisTanaman" tidak ditemukan di repositori tanaman.',
          ),
        );
        return;
      }

      // Ambil ID dari baris pertama yang ditemukan
      final repoTanamanId = repoResponse.first['id'] as int;

      final insertData = {
        'user_id': _supabase.auth.currentUser?.id ?? '',
        'repo_tanaman_id': repoTanamanId,
        'nama_tanam': namaTanam,
        'tanggal_tanam': tanggalTanam.toIso8601String().split(
          'T',
        )[0], // Simpan format YYYY-MM-DD
        'image_url': imageUrl,
      };

      // Insert data ke tabel user_tanam
      final insertResponse = await _supabase
          .from('user_tanam')
          .insert(insertData)
          .select()
          .single();

      final newId = insertResponse['id'] as int;
      emit(UserTanamSuccess(newId));

      // Refresh list agar HomePage terupdate otomatis
      fetchUserTanamList();
    } catch (e) {
      emit(UserTanamError("Gagal menambah tanaman: ${e.toString()}"));
    }
  }
}
