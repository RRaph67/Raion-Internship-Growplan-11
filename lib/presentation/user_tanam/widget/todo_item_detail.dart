import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/models/todo_tanam_model.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoTanamModel todo;
  final bool isCompleted;
  final VoidCallback onTap;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 326,
        height: 66,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          // Menggunakan warna background D1EABC
          color: const Color(0xFFD1EABC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Gambar siram.png di paling kiri
            Image.asset(
              'assets/icons/detail_plant/siram.png',
              width: 32,
              height: 32,
              // Fallback jika file tidak ditemukan saat pengembangan
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.water_drop,
                size: 32,
                color: Color(0xFF508C1D),
              ),
            ),
            const SizedBox(width: 12),

            // Judul dan Subjudul
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.namaTodo, // Contoh: "Siram"
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.grey[700] : Colors.black,
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  Text(
                    "${todo.jamTodo} - ${_formatDate(todo.tanggalTodo)}",
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // Custom Checkbox di paling kanan
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF508C1D)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF508C1D), width: 2),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
