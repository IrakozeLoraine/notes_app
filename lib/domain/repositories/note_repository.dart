import 'package:notes/domain/entities/note.dart';

abstract class NoteRepository {
  Future<List<Note>> getNotes();
  Future<void> addNote(String text);
  Future<void> updateNote(String id, String text);
  Future<void> deleteNote(String id);
}
