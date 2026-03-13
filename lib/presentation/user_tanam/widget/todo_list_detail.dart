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
    // Mengambil data berdasarkan filter yang aktif
    final filteredTodos = _isSelesaiActive
        ? widget.completedTodos
        : widget.pendingTodos;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "To Do List",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildFilterButton("Tugas", !_isSelesaiActive),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterButton("Selesai", _isSelesaiActive),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          if (filteredTodos.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  _isSelesaiActive ? "Belum ada tugas selesai" : "Semua tugas beres!",
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredTodos.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final todo = filteredTodos[index];

                final isCompleted = todo.status.contains('completed');
                
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: (_isSelesaiActive && isCompleted) ? 0.7 : 1.0,
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
        if ((label == "Selesai" && !_isSelesaiActive) || 
            (label == "Tugas" && _isSelesaiActive)) {
          setState(() {
            _isSelesaiActive = label == "Selesai";
          });
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 36, // Sedikit lebih tinggi untuk touch target yang lebih baik
        decoration: BoxDecoration(
          color: isActive
              ? AppPallete.primaryDark
              : const Color(0xFFE6FDE3),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: AppPallete.primaryDark,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : AppPallete.primaryDark,
            ),
          ),
        ),
      ),
    );
  }
}