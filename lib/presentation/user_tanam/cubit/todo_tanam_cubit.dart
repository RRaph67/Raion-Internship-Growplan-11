import 'package:flutter_application_1/presentation/user_tanam/cubit/todo_tanam_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/data/models/todo_tanam_model.dart';

class TodoTanamCubit extends Cubit<TodoTanamState> {
  final SupabaseClient _supabase;

  TodoTanamCubit(this._supabase) : super(TodoTanamInitial());

  // 1. Load Todos untuk hari ini
  Future<void> loadTodos(int userTanamId) async {
    emit(TodoTanamLoading());
    try {
      final today = DateTime.now().toIso8601String().split(
        'T',
      )[0]; // Format YYYY-MM-DD

      final response = await _supabase
          .from('todo_tanam')
          .select('*')
          .eq('user_tanam_id', userTanamId)
          .eq('tanggal_todo', today)
          .order('jam_todo', ascending: true);

      final todos = response.map((e) => TodoTanamModel.fromMap(e)).toList();

      // Filter Pending vs Completed
      final pending = todos.where((t) => t.status.contains('pending')).toList();
      final completed = todos
          .where((t) => t.status.contains('completed'))
          .toList();

      emit(TodoTanamLoaded(todos, pending, completed));
    } catch (e) {
      emit(TodoTanamError(e.toString()));
    }
  }

  // 2. Buat Todo Harian Otomatis (Jika belum ada)
  Future<void> ensureDailyTodos(int userTanamId) async {
    try {
      final today = DateTime.now().toIso8601String().split('T')[0];

      final existing = await _supabase
          .from('todo_tanam')
          .select('id')
          .eq('user_tanam_id', userTanamId)
          .eq('tanggal_todo', today)
          .limit(1)
          .maybeSingle(); 

      if (existing == null) {
        final newTodos = [
          {
            'user_tanam_id': userTanamId,
            'tanggal_todo': today,
            'jam_todo': '07:00',
            'nama_todo': 'Siram Pagi',
            'status': ['pending'],
          },
          {
            'user_tanam_id': userTanamId,
            'tanggal_todo': today,
            'jam_todo': '16:00',
            'nama_todo': 'Siram Sore',
            'status': ['pending'],
          },
        ];

        await _supabase.from('todo_tanam').insert(newTodos);

        // Reload data setelah insert
        await loadTodos(userTanamId);
      }
    } catch (e) {
      print('Error creating daily todos: $e');
    }
  }

  // 3. Toggle Status (Checkbox)
  Future<void> toggleTodoStatus(int todoId, int userTanamId) async {
    try {
      // Ambil data lama dulu untuk melihat status saat ini
      final current = await _supabase
          .from('todo_tanam')
          .select('status')
          .eq('id', todoId)
          .maybeSingle(); 

      if (current == null) {
        emit(TodoTanamError('Todo not found'));
        return;
      }

      final currentStatus = current['status'] as List<dynamic>;
      final newStatus = currentStatus.contains('completed')
          ? ['pending']
          : ['completed'];

      await _supabase
          .from('todo_tanam')
          .update({'status': newStatus})
          .eq('id', todoId);

      // Reload list
      await loadTodos(userTanamId);
    } catch (e) {
      emit(TodoTanamError(e.toString()));
    }
  }
}
