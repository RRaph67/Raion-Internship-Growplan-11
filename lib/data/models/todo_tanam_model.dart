// File: lib/data/models/todo_tanam_model.dart
class TodoTanamModel {
  final int id;
  final int userTanamId;
  final String namaTodo;
  final DateTime tanggalTodo;
  final String jamTodo;
  final List<String> status; // Tipe data List<String>
  final DateTime? completeAt;

  TodoTanamModel({
    required this.id,
    required this.userTanamId,
    required this.namaTodo,
    required this.tanggalTodo,
    required this.jamTodo,
    required this.status,
    this.completeAt,
  });

  factory TodoTanamModel.fromMap(Map<String, dynamic> map) {
    // Logika parsing status agar aman (List atau String)
    dynamic statusData = map['status'];
    List<String> statusList = ['pending']; // Default sesuai DB

    if (statusData != null) {
      if (statusData is List) {
        // Jika API mengirim List langsung
        statusList = statusData.cast<String>();
      } else if (statusData is String) {
        // Jika API mengirim String (jarang, tapi perlu handle)
        // Contoh: "pending" -> ['pending']
        statusList = [statusData];
      }
    }

    return TodoTanamModel(
      id: map['id'] is int ? map['id'] : int.parse(map['id'].toString()),
      userTanamId: map['user_tanam_id'] is int
          ? map['user_tanam_id']
          : int.parse(map['user_tanam_id'].toString()),
      namaTodo: map['nama_todo']?.toString() ?? '',
      tanggalTodo: map['tanggal_todo'] != null
          ? DateTime.parse(map['tanggal_todo'])
          : DateTime.now(),
      jamTodo: map['jam_todo']?.toString() ?? '',
      status: statusList, // Masukkan List<String>
      completeAt:
          (map['complete_at'] != null &&
              map['complete_at'].toString().isNotEmpty)
          ? DateTime.tryParse(map['complete_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_tanam_id': userTanamId,
      'nama_todo': namaTodo,
      'tanggal_todo': tanggalTodo.toIso8601String(),
      'jam_todo': jamTodo,
      'status': status, // Kirim List<String>
      'complete_at': completeAt?.toIso8601String(),
    };
  }
}
