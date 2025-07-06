import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/data/datasources/firebase_datasource.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Bloc for managing authentication state and actions.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseDataSource dataSource;

  AuthBloc({required this.dataSource}) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  /// Checks the current authentication status and emits the appropriate state.
  void _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) {
    final user = dataSource.getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user: user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  /// Handles sign-in requests and emits the appropriate state based on the result.
  Future<void> _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await dataSource.signInWithEmailAndPassword(event.email, event.password);
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthError(message: 'Failed to sign in'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getAuthErrorMessage(e.code)));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Handles sign-up requests and emits the appropriate state based on the result.
  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await dataSource.createUserWithEmailAndPassword(event.email, event.password);
      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthError(message: 'Failed to create account'));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _getAuthErrorMessage(e.code)));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Handles sign-out requests and emits the unauthenticated state.
  Future<void> _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    try {
      await dataSource.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  /// Returns a user-friendly error message based on the FirebaseAuthException code.
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email address';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      case 'invalid-credential':
        return 'Invalid email or password';
      default:
        return 'Authentication failed';
    }
  }
}
