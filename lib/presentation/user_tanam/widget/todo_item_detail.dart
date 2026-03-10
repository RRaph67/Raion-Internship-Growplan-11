// widgets/todo_item_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/theme/app_pallete.dart';

class TodoItemWidget extends StatelessWidget {
  final Map<String, dynamic> todo;
  final bool isCompleted;
  final VoidCallback? onTap;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.isCompleted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 326,
      height: 66,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: 32,
              height: 32,
              child: Image.asset(
                'assets/icons/detail_plant/siram.png',
                width: double.infinity,
                fit: BoxFit.cover,
                height: 300,
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  todo['nama_todo'] ?? 'Siram',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  todo['jam_todo'] ?? '07.00',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: isCompleted ? AppPallete.primaryNormal : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isCompleted ? AppPallete.primaryNormal : Colors.grey,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
