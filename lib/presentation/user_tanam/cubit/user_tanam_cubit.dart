import 'package:flutter_application_1/presentation/user_tanam/cubit/user_tanam_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/data/models/user_tanam_model.dart';

class UserTanamCubit extends Cubit<UserTanamState> {
  final SupabaseClient _supabase;

  // Simpan list secara lokal agar tidak hilang saat pindah state ke detail
  List<UserTanamModel> _cachedList = [];

  UserTanamCubit(this._supabase) : super(UserTanamInitial());

  void resetState() {
    emit(UserTanamInitial());
  }

  // Method Load Detail Tanaman (untuk Detail Page)
  Future<void> loadPlantInfo(String userId, int userTanamId) async {
    // Jangan emit loading global jika kita ingin mempertahankan list di background,
    // tapi karena Detail Page butuh feedback, kita tetap emit.
    // Solusinya adalah UI Home harus memanggil fetch lagi jika state bukan ListLoaded.
    emit(UserTanamLoading());

    try {
      final response = await _supabase
          .from('user_tanam')
          .select('*, repo_tanaman(*)')
          .eq('id', userTanamId)
          .eq('user_id', userId)
          .maybeSingle();

      if (response == null) {
        emit(UserTanamError('Plant not found'));
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

  // Method Load List Tanaman (untuk HomePage)
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

  // Tambahkan method ini untuk mengembalikan state ke list tanpa fetch ulang jika sudah ada cache
  void restoreList() {
    if (_cachedList.isNotEmpty) {
      emit(UserTanamListLoaded(_cachedList));
    } else {
      fetchUserTanamList();
    }
  }

  Future<void> addUserTanamByJenis({
    required String namaTanam,
    required DateTime tanggalTanam,
    required String jenisTanaman,
    required String imageUrl,
  }) async {
    emit(UserTanamLoading());
    try {
      final repoResponse = await _supabase
          .from('repo_tanaman')
          .select('id')
          .eq('jenis_tanaman', jenisTanaman)
          .maybeSingle();

      if (repoResponse == null) {
        emit(UserTanamError('Jenis tanaman tidak ditemukan di database'));
        return;
      }

      final repoTanamanId = repoResponse['id'] as int;

      final insertData = {
        'user_id': _supabase.auth.currentUser?.id ?? '',
        'repo_tanaman_id': repoTanamanId,
        'nama_tanam': namaTanam,
        'tanggal_tanam': tanggalTanam.toIso8601String().split('T')[0],
        'image_url': imageUrl,
      };

      final insertResponse = await _supabase
          .from('user_tanam')
          .insert(insertData)
          .select()
          .single();

      final newId = insertResponse['id'] as int;
      emit(UserTanamSuccess(newId));
      // Refresh list setelah tambah
      fetchUserTanamList();
    } catch (e) {
      emit(UserTanamError(e.toString()));
    }
  }
}
