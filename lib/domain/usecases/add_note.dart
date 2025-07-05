import 'package:notes/domain/repositories/note_repository.dart';

class AddNote {
  final NoteRepository repository;

  AddNote(this.repository);

  Future<void> call(String text) async {
    return await repository.addNote(text);
  }
}
