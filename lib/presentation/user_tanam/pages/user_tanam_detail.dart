// lib/presentation/user_tanam/pages/user_tanam_detail.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/plant_info/widget/simple_appbar.dart';
import 'package:flutter_application_1/presentation/user_tanam/widget/plant_info_widget.dart';
import 'package:flutter_application_1/presentation/user_tanam/widget/todo_list_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/user_tanam_cubit.dart';
import '../cubit/user_tanam_state.dart';

class UserTanamDetailPage extends StatelessWidget {
  final int userTanamId;

  const UserTanamDetailPage({super.key, required this.userTanamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: "Detail Tanaman"),
      body: BlocProvider(
        create: (_) => UserTanamCubit()..fetchUserTanamDetail(userTanamId),
        child: BlocBuilder<UserTanamCubit, UserTanamState>(
          builder: (context, state) {
            if (state is UserTanamLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserTanamDetailLoaded) {
              final detail = state.detail;

              // Mapping data todo yang lebih aman
              final todos = _mapTodos(detail['todo_tanam']);

              return ListView(
                padding: const EdgeInsets.only(top: 16),
                children: [
                  PlantInfoWidget(detail: detail),
                  const SizedBox(height: 24),
                  TodoListWidget(
                    todos: todos,
                    onToggleTodo: (index) {
                      context.read<UserTanamCubit>().toggleTodoStatus(index);
                    },
                  ),
                ],
              );
            } else if (state is UserTanamError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _mapTodos(dynamic todoData) {
    if (todoData == null) return [];

    if (todoData is List) {
      return todoData.map((todo) {
        return {
          'id': todo['id'] ?? 0,
          'nama_todo': todo['nama_todo'] ?? 'Tanpa Nama',
          'tanggal_todo': todo['tanggal_todo'] ?? '',
          'jam_todo': todo['jam_todo'] ?? '07:00',
          'status': todo['status'] ?? ['pending'],
          'complete_at': todo['complete_at'] ?? null,
        };
      }).toList();
    }

    return [];
  }
}
