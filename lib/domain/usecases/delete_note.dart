import 'package:notes/domain/repositories/note_repository.dart';

/// Use case for deleting a note.
class DeleteNote {
  final NoteRepository repository;

  DeleteNote(this.repository);

  Future<void> call(String id) async {
    return await repository.deleteNote(id);
  }
}
