import 'package:notes/domain/entities/note.dart';

/// Represents a Note model that extends the Note entity.
class NoteModel extends Note {
  const NoteModel({
    required super.id,
    required super.text,
    required super.createdAt,
    required super.updatedAt,
  });

  factory NoteModel.fromFirestore(Map<String, dynamic> doc, String id) {
    // Convert the Firestore document to a NoteModel instance
    return NoteModel(
      id: id,
      text: doc['text'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(doc['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(doc['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    // Convert the NoteModel instance to a Firestore document
    return {
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }
}
