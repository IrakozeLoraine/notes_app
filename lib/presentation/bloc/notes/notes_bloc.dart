import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/domain/entities/note.dart';
import 'package:notes/domain/usecases/add_note.dart';
import 'package:notes/domain/usecases/delete_note.dart';
import 'package:notes/domain/usecases/get_note.dart';
import 'package:notes/domain/usecases/update_note.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final GetNotes getNotes;
  final AddNote addNote;
  final UpdateNote updateNote;
  final DeleteNote deleteNote;

  NotesBloc({
    required this.getNotes,
    required this.addNote,
    required this.updateNote,
    required this.deleteNote,
  }) : super(NotesInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNoteEvent>(_onAddNote);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<DeleteNoteEvent>(_onDeleteNote);
  }

  Future<void> _onLoadNotes(LoadNotes event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    try {
      final notes = await getNotes();
      emit(NotesLoaded(notes: notes));
    } catch (e) {
      emit(NotesError(message: e.toString()));
    }
  }

  Future<void> _onAddNote(AddNoteEvent event, Emitter<NotesState> emit) async {
    try {
      await addNote(event.text);
      final notes = await getNotes();
      emit(NotesOperationSuccess(message: 'Note added successfully', notes: notes));
    } catch (e) {
      emit(NotesError(message: 'Failed to add note: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateNote(UpdateNoteEvent event, Emitter<NotesState> emit) async {
    try {
      await updateNote(event.id, event.text);
      final notes = await getNotes();
      emit(NotesOperationSuccess(message: 'Note updated successfully', notes: notes));
    } catch (e) {
      emit(NotesError(message: 'Failed to update note: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteNote(DeleteNoteEvent event, Emitter<NotesState> emit) async {
    try {
      await deleteNote(event.id);
      final notes = await getNotes();
      emit(NotesOperationSuccess(message: 'Note deleted successfully', notes: notes));
    } catch (e) {
      emit(NotesError(message: 'Failed to delete note: ${e.toString()}'));
    }
  }
}
