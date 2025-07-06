import 'package:notes/domain/repositories/note_repository.dart';

/// Use case for updating a note.
class UpdateNote {
  final NoteRepository repository;

  UpdateNote(this.repository);

  Future<void> call(String id, String text) async {
    return await repository.updateNote(id, text);
  }
}
