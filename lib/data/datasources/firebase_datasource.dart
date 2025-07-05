import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/data/models/note_model.dart';

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
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    final now = DateTime.now();
    final noteModel = NoteModel(
      id: '',
      text: text,
      createdAt: now,
      updatedAt: now,
    );

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .add(noteModel.toFirestore());
  }

  @override
  Future<void> updateNote(String id, String text) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

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
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not authenticated');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .doc(id)
        .delete();
  }

  @override
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  @override
  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
