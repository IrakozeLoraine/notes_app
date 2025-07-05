import 'package:notes/data/datasources/firebase_datasource.dart';
import 'package:notes/domain/entities/note.dart';
import 'package:notes/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final FirebaseDataSource dataSource;

  NoteRepositoryImpl({required this.dataSource});

  @override
  Future<List<Note>> getNotes() async {
    return await dataSource.getNotes();
  }

  @override
  Future<void> addNote(String text) async {
    return await dataSource.addNote(text);
  }

  @override
  Future<void> updateNote(String id, String text) async {
    return await dataSource.updateNote(id, text);
  }

  @override
  Future<void> deleteNote(String id) async {
    return await dataSource.deleteNote(id);
  }
}
