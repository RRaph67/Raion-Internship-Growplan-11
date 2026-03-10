// cubit/user_tanam_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'user_tanam_state.dart';

class UserTanamCubit extends Cubit<UserTanamState> {
  UserTanamCubit() : super(UserTanamInitial());

  final supabase = Supabase.instance.client;

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

      // Debug print untuk verify data
      print("=== DATA USER TANAM DETAIL ===");
      print("Todo Tanam: ${response['todo_tanam']}");
      print("Image URL: ${response['image_url']}");
      print("Repo Tanaman: ${response['repo_tanaman']}");

      emit(UserTanamDetailLoaded(response));
    } catch (e) {
      print("Error fetch detail: $e");
      emit(UserTanamError(e.toString()));
    }
  }

  Future<void> toggleTodoStatus(int index) async {
    try {
      if (state is UserTanamDetailLoaded) {
        final currentState = state as UserTanamDetailLoaded;
        final detail = Map<String, dynamic>.from(currentState.detail);

        // Handle null todo_tanam
        final todosRaw = detail['todo_tanam'] as List<dynamic>? ?? [];
        final todos = List<Map<String, dynamic>>.from(todosRaw);

        if (index < 0 || index >= todos.length) {
          emit(UserTanamError("Index todo tidak valid"));
          return;
        }

        final todo = todos[index];
        final statusRaw = todo['status'] as List<dynamic>? ?? [];

        // Convert to String list
        final status = statusRaw.map((e) => e.toString()).toList();

        // Toggle status - lebih aman dengan clear dulu
        final isDone = status.contains('done');
        final newStatus = isDone ? ['pending'] : ['done'];

        todo['status'] = newStatus;
        todos[index] = todo;
        detail['todo_tanam'] = todos;

        // Update ke Supabase
        await supabase
            .from('todo_tanam')
            .update({'status': newStatus})
            .eq('id', todo['id']);

        // Emit state baru
        emit(UserTanamDetailLoaded(detail));
      }
    } catch (e) {
      print("Error toggle status: $e");
      emit(UserTanamError("Gagal update status: ${e.toString()}"));
    }
  }

  Future<void> fetchJenisTanaman() async {
    emit(RepoTanamanLoading());
    try {
      final response = await supabase
          .from('repo_tanaman')
          .select('jenis_tanaman')
          .order('jenis_tanaman', ascending: true);

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

  Future<void> fetchUserTanamList() async {
    emit(UserTanamLoading());
    try {
      final userId = supabase.auth.currentUser!.id;

      final response = await supabase
          .from('user_tanam')
          .select(
            'id, nama_tanam, tanggal_tanam, image_url, repo_tanaman(nama_statis, jenis_tanaman)',
          )
          .eq('user_id', userId);

      print("=== DATA USER TANAM LIST ===");
      print("Response: $response");

      emit(UserTanamListLoaded(response));
    } catch (e) {
      emit(UserTanamError(e.toString()));
    }
  }

  Future<void> addUserTanamByJenis({
    required String namaTanam,
    required DateTime tanggalTanam,
    required String jenisTanaman,
    required String? imageUrl,
  }) async {
    emit(UserTanamLoading());
    try {
      final userId = supabase.auth.currentUser!.id;

      final repo = await supabase
          .from('repo_tanaman')
          .select('id')
          .contains('jenis_tanaman', [jenisTanaman])
          .limit(1)
          .single();

      final repoId = repo['id'];

      final inserted = await supabase
          .from('user_tanam')
          .insert({
            'user_id': userId,
            'repo_tanaman_id': repoId,
            'nama_tanam': namaTanam,
            'tanggal_tanam': tanggalTanam.toIso8601String(),
            'image_url': imageUrl,
          })
          .select()
          .single();

      final userTanamId = inserted['id'];

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
