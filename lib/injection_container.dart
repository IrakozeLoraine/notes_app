import 'package:get_it/get_it.dart';
import 'package:notes/data/repositories/note_repository_impl.dart';
import 'package:notes/domain/repositories/note_repository.dart';
import 'package:notes/domain/usecases/add_note.dart';
import 'package:notes/domain/usecases/delete_note.dart';
import 'package:notes/domain/usecases/get_note.dart';
import 'package:notes/domain/usecases/update_note.dart';
import 'package:notes/presentation/bloc/notes/notes_bloc.dart';
import 'data/datasources/firebase_datasource.dart';
import 'presentation/bloc/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoCs
  sl.registerFactory(
    () => AuthBloc(dataSource: sl()),
  );
  sl.registerFactory(
    () => NotesBloc(
      getNotes: sl(),
      addNote: sl(),
      updateNote: sl(),
      deleteNote: sl(),
    ),
  );
  
  // Use cases
  sl.registerLazySingleton(() => GetNotes(sl()));
  sl.registerLazySingleton(() => AddNote(sl()));
  sl.registerLazySingleton(() => UpdateNote(sl()));
  sl.registerLazySingleton(() => DeleteNote(sl()));

  // Repository
  sl.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(dataSource: sl()),
  );
  
  // Data sources
  sl.registerLazySingleton<FirebaseDataSource>(
    () => FirebaseDataSourceImpl(),
  );
}
