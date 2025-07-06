import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/data/models/note_model.dart';

// The FirebaseDataSource interface defines the methods for interacting with Firebase services
// such as fetching, adding, updating, and deleting notes, as well as user authentication methods
abstract class FirebaseDataSource {
  Future<List<NoteModel>> getNotes();
  Future<void> addNote(String text);
  Future<void> updateNote(String id, String text);
  Future<void> deleteNote(String id);
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> createUserWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  User? getCurrentUser();
}

class FirebaseDataSourceImpl implements FirebaseDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<NoteModel>> getNotes() async {
    // Ensure the user is authenticated before fetching notes
    // If the user is not authenticated, throw an exception
    // to handle the error gracefully in the UI.
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final querySnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => NoteModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> addNote(String text) async {
    // Ensure the user is authenticated before adding a note
    // If the user is not authenticated, throw an exception
    // to handle the error gracefully in the UI.
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final now = DateTime.now();
    final noteModel = NoteModel(
      id: '',
      text: text,
      createdAt: now,
      updatedAt: now,
    );

    // Add the note to the user's notes collection
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .add(noteModel.toFirestore());
  }

  @override
  Future<void> updateNote(String id, String text) async {
    // Ensure the user is authenticated before updating a note
    // If the user is not authenticated, throw an exception
    // to handle the error gracefully in the UI.
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');
    
    // Update the note in the user's notes collection
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .doc(id)
        .update({
      'text': text,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  @override
  Future<void> deleteNote(String id) async {
    // Ensure the user is authenticated before deleting a note
    // If the user is not authenticated, throw an exception
    // to handle the error gracefully in the UI.
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    // Delete the note from the user's notes collection
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .doc(id)
        .delete();
  }

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    // Attempt to sign in the user with the provided email and password
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  @override
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    // Attempt to create a new user with the provided email and password
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  @override
  Future<void> signOut() async {
    // Sign out the current user
    await _auth.signOut();
  }

  @override
  User? getCurrentUser() {
    // Return the currently signed-in user
    // If no user is signed in, this will return null.
    return _auth.currentUser;
  }
}
