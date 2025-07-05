import 'package:notes/domain/entities/note.dart';
import 'package:notes/domain/repositories/note_repository.dart';

class GetNotes {
  final NoteRepository repository;

  GetNotes(this.repository);

  Future<List<Note>> call() async {
    return await repository.getNotes();
  }
}
