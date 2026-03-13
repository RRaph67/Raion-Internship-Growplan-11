// File: lib/presentation/user_tanam/widget/todo_list_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_pallete.dart';
import 'package:flutter_application_1/data/models/todo_tanam_model.dart';
import 'package:flutter_application_1/presentation/user_tanam/widget/todo_item_detail.dart';

class TodoListWidget extends StatefulWidget {
  final List<TodoTanamModel> pendingTodos;
  final List<TodoTanamModel> completedTodos;
  final Function(TodoTanamModel todo) onToggleTodo;

  const TodoListWidget({
    super.key,
    required this.pendingTodos,
    required this.completedTodos,
    required this.onToggleTodo,
  });

  @override
  State<TodoListWidget> createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  bool _isSelesaiActive = false;

  @override
  Widget build(BuildContext context) {
    final filteredTodos = _isSelesaiActive
        ? widget.completedTodos
        : widget.pendingTodos;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "To Do List",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFilterButton("Tugas", !_isSelesaiActive),
              const SizedBox(width: 8),
              _buildFilterButton("Selesai", _isSelesaiActive),
            ],
          ),
          const SizedBox(height: 16),
          if (filteredTodos.isEmpty)
            Center(
              child: Text(
                "Lah kosong njiir",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredTodos.length,
              itemBuilder: (context, index) {
                final todo = filteredTodos[index];
                final isCompleted = todo.status.contains('completed');
                final opacity = _isSelesaiActive && isCompleted ? 0.5 : 1.0;

                return Opacity(
                  opacity: opacity,
                  child: TodoItemWidget(
                    todo: todo,
                    isCompleted: isCompleted,
                    onTap: () => widget.onToggleTodo(todo),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String label, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelesaiActive = label == "Selesai";
        });
      },
      child: Container(
        width: 155,
        height: 32,
        decoration: BoxDecoration(
          color: isActive
              ? AppPallete.primaryDark
              : const Color.fromARGB(255, 230, 253, 227),
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: isActive ? AppPallete.primaryDark : AppPallete.primaryDark,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : AppPallete.primaryDark,
            ),
          ),
        ),
      ),
    );
  }
}
