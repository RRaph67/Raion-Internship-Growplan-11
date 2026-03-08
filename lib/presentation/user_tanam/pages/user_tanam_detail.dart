import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/user_tanam_cubit.dart';
import '../cubit/user_tanam_state.dart';

class UserTanamDetailPage extends StatelessWidget {
  final int userTanamId;

  const UserTanamDetailPage({super.key, required this.userTanamId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Tanaman")),
      body: BlocProvider(
        create: (_) => UserTanamCubit()..fetchUserTanamDetail(userTanamId),
        child: BlocBuilder<UserTanamCubit, UserTanamState>(
          builder: (context, state) {
            if (state is UserTanamLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserTanamDetailLoaded) {
              final detail = state.detail;
              final todos = detail['todo_tanam'] as List<dynamic>;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Informasi tanaman
                  Text(
                    "Nama Tanaman: ${detail['nama_tanam']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("Kategori: ${detail['repo_tanaman']['jenis_tanaman']}"),
                  Text("Tanggal Tanam: ${detail['tanggal_tanam']}"),
                  if (detail['image_url'] != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Image.network(detail['image_url']),
                    ),
                  const SizedBox(height: 20),

                  // Todo list
                  const Text(
                    "Todo List:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  ...todos.map(
                    (todo) => Card(
                      child: ListTile(
                        title: Text(todo['nama_todo']),
                        subtitle: Text(
                          "${todo['tanggal_todo']} - ${todo['jam_todo']}",
                        ),
                        trailing: Text(
                          (todo['status'] as List).isNotEmpty
                              ? (todo['status'] as List).last
                              : "pending",
                          style: TextStyle(
                            color: (todo['status'] as List).last == "done"
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    ),
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
}
