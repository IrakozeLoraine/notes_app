import 'package:notes/domain/entities/note.dart';

class NoteModel extends Note {
  const NoteModel({
    required super.id,
    required super.text,
    required super.createdAt,
    required super.updatedAt,
  });

  factory NoteModel.fromFirestore(Map<String, dynamic> doc, String id) {
    return NoteModel(
      id: id,
      text: doc['text'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(doc['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(doc['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }
}
