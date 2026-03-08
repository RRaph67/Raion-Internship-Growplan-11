import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_tanam_state.dart';

class UserTanamCubit extends Cubit<UserTanamState> {
  UserTanamCubit() : super(UserTanamInitial());

  final supabase = Supabase.instance.client;

Future<void> fetchJenisTanaman() async {
    emit(RepoTanamanLoading());
    try {
      final response = await supabase
          .from('repo_tanaman')
          .select('jenis_tanaman')
          .order('jenis_tanaman', ascending: true);

      // Karena jenis_tanaman adalah array, kita flatten lalu ambil unique
      final allJenis = <String>{};
      for (var row in response) {
        final List<dynamic>? jenisList = row['jenis_tanaman'];
        if (jenisList != null) {
          allJenis.addAll(jenisList.map((e) => e.toString()));
        }
      }

      emit(JenisTanamanLoaded(allJenis.toList()));
    } catch (e) {
      emit(UserTanamError(e.toString()));
    }
  }


  Future<void> fetchRepoTanaman() async {
    emit(RepoTanamanLoading());
    try {
      final response = await supabase
          .from('repo_tanaman')
          .select('id, nama_statis, jenis_tanaman');
      emit(RepoTanamanLoaded(response));
    } catch (e) {
      emit(UserTanamError(e.toString()));
    }
  }

  Future<void> fetchUserTanamDetail(int userTanamId) async {
    emit(UserTanamLoading());
    try {
      final response = await supabase
          .from('user_tanam')
          .select(
            'id, nama_tanam, tanggal_tanam, image_url, repo_tanaman(nama_statis, jenis_tanaman), todo_tanam(id, nama_todo, tanggal_todo, jam_todo, status, complete_at)',
          )
          .eq('id', userTanamId)
          .single();

      emit(UserTanamDetailLoaded(response));
    } catch (e) {
      emit(UserTanamError(e.toString()));
    }
  }

  Future<void> fetchUserTanamList() async {
    emit(UserTanamLoading());
    try {
      final userId = supabase.auth.currentUser!.id;

      final response = await supabase
          .from('user_tanam')
          .select(
            'id, nama_tanam, tanggal_tanam, repo_tanaman(nama_statis, jenis_tanaman)',
          )
          .eq('user_id', userId);

      emit(UserTanamListLoaded(response));
    } catch (e) {
      emit(UserTanamError(e.toString()));
    }
  }

Future<void> fetchUserTanamPreview() async {
    emit(UserTanamLoading());
    try {
      final userId = supabase.auth.currentUser!.id;
      final response = await supabase
          .from('user_tanam')
          .select(
            'id, nama_tanam, tanggal_tanam, image_url, repo_tanaman(nama_statis, jenis_tanaman)',
          )
          .eq('user_id', userId);

      emit(UserTanamListLoaded(response));
    } catch (e) {
      emit(UserTanamError(e.toString()));
    }
  }

Future<void> addUserTanamByJenis({
    required String namaTanam,
    required DateTime tanggalTanam,
    required String jenisTanaman,
    required String? imageUrl, // tambahkan ini
  }) async {
    emit(UserTanamLoading());
    try {
      final userId = supabase.auth.currentUser!.id;

      // Ambil satu repo_tanaman_id berdasarkan kategori
      final repo = await supabase
          .from('repo_tanaman')
          .select('id')
          .contains('jenis_tanaman', [jenisTanaman])
          .limit(1)
          .single();

      final repoId = repo['id'];

      // Insert ke user_tanam dengan image_url
      final inserted = await supabase
          .from('user_tanam')
          .insert({
            'user_id': userId,
            'repo_tanaman_id': repoId,
            'nama_tanam': namaTanam,
            'tanggal_tanam': tanggalTanam.toIso8601String(),
            'image_url': imageUrl, // simpan gambar yang dipilih
          })
          .select()
          .single();

      final userTanamId = inserted['id'];

      // Generate todo default
      final todos = [
        {
          'user_tanam_id': userTanamId,
          'nama_todo': 'Siram tanaman pagi',
          'tanggal_todo': tanggalTanam.toIso8601String(),
          'jam_todo': '07:00',
          'status': ['pending'],
        },
        {
          'user_tanam_id': userTanamId,
          'nama_todo': 'Siram tanaman sore',
          'tanggal_todo': tanggalTanam.toIso8601String(),
          'jam_todo': '16:00',
          'status': ['pending'],
        },
      ];

      await supabase.from('todo_tanam').insert(todos);

      emit(UserTanamSuccess(userTanamId));
    } catch (e) {
      emit(UserTanamError(e.toString()));
    }
  }
}
