import 'package:flutter/material.dart';
import 'package:flutter_application_1/presentation/plant_info/widget/simple_appbar.dart';
import 'package:flutter_application_1/presentation/user_tanam/widget/plant_info_widget.dart';
import 'package:flutter_application_1/presentation/user_tanam/widget/todo_list_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../cubit/user_tanam_cubit.dart';
import '../cubit/user_tanam_state.dart';
import '../cubit/todo_tanam_cubit.dart';
import '../cubit/todo_tanam_state.dart';

class UserTanamDetailPage extends StatefulWidget {
  final int userTanamId;
  const UserTanamDetailPage({super.key, required this.userTanamId});

  @override
  State<UserTanamDetailPage> createState() => _UserTanamDetailPageState();
}

class _UserTanamDetailPageState extends State<UserTanamDetailPage> {
  @override
  void initState() {
    super.initState();
    final userId = Supabase.instance.client.auth.currentUser?.id ?? '';
    // ✅ Panggil load detail saat masuk
    context.read<UserTanamCubit>().loadPlantInfo(userId, widget.userTanamId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Detail Tanaman",
        // ✅ Gunakan onBackTap untuk restore state sebelum keluar
        onBackTap: () {
          context.read<UserTanamCubit>().restoreList();
          Navigator.pop(context);
        },
      ),
      // ✅ Handle hardware back button (Android)
      body: PopScope(
        canPop: false, // Kita handle manual
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          context.read<UserTanamCubit>().restoreList();
          Navigator.pop(context);
        },
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => TodoTanamCubit(Supabase.instance.client)
                ..ensureDailyTodos(widget.userTanamId)
                ..loadTodos(widget.userTanamId),
            ),
          ],
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: BlocBuilder<UserTanamCubit, UserTanamState>(
                  builder: (context, state) {
                    if (state is UserTanamLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is UserTanamLoaded) {
                      return PlantInfoWidget(
                        detail: state.userTanam,
                        daysSincePlanted: state.daysSincePlanted,
                      );
                    } else if (state is UserTanamError) {
                      return Center(child: Text("Error: ${state.message}"));
                    }
                    return const SizedBox();
                  },
                ),
              ),
              Expanded(
                flex: 3,
                child: BlocBuilder<TodoTanamCubit, TodoTanamState>(
                  builder: (context, todoState) {
                    if (todoState is TodoTanamLoaded) {
                      return TodoListWidget(
                        pendingTodos: todoState.pendingTodos,
                        completedTodos: todoState.completedTodos,
                        onToggleTodo: (todo) {
                          context.read<TodoTanamCubit>().toggleTodoStatus(
                            todo.id,
                            todo.userTanamId,
                          );
                        },
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
