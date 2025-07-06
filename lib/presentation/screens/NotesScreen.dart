import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/core/utils/snackbar_utils.dart';
import 'package:notes/domain/entities/note.dart';
import 'package:notes/presentation/bloc/auth/auth_bloc.dart';
import 'package:notes/presentation/bloc/notes/notes_bloc.dart';
import 'package:notes/presentation/screens/LoginScreen.dart';
import 'package:notes/presentation/widgets/loading_widget.dart';
import 'package:notes/presentation/widgets/note_card.dart';
import 'package:notes/presentation/widgets/note_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotesBloc>().add(LoadNotes());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sign Out'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(SignOutRequested());
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is NotesOperationSuccess) {
            SnackBarUtils.showSuccess(context, state.message);
          } else if (state is NotesError) {
            SnackBarUtils.showError(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is NotesLoading) {
            return const LoadingWidget(message: 'Loading notes...');
          }

          if (state is NotesLoaded || state is NotesOperationSuccess) {
            final notes = state is NotesLoaded 
                ? state.notes 
                : (state as NotesOperationSuccess).notes;

            if (notes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.note_add_outlined,
                      size: 80,
                      color: Colors.grey[600],
                    ),
                    SizedBox(height: 32),
                    Text(
                      'Nothing here yet. Tap + to add a note.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return NoteCard(
                  note: notes[index],
                  onEdit: (note) => _showNoteDialog(note: note),
                  onDelete: (noteId) => _showDeleteDialog(noteId),
                );
              },
            );
          }

          if (state is NotesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NotesBloc>().add(LoadNotes());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showNoteDialog({Note? note}) {
    showDialog(
      context: context,
      builder: (context) => NoteDialog(
        note: note,
        onSave: (text) {
          if (note == null) {
            context.read<NotesBloc>().add(AddNoteEvent(text: text));
          } else {
            context.read<NotesBloc>().add(
              UpdateNoteEvent(id: note.id, text: text),
            );
          }
        },
      ),
    );
  }

  void _showDeleteDialog(String noteId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<NotesBloc>().add(DeleteNoteEvent(id: noteId));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
