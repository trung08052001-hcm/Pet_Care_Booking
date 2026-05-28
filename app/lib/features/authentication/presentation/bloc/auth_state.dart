import 'package:app/features/authentication/domain/entities/auth_session.dart';
import 'package:equatable/equatable.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

enum AuthSubmissionStatus {
  initial,
  loading,
  success,
  failure,
}

enum AuthAction {
  idle,
  restoreSession,
  signIn,
  signUp,
  signInWithGoogle,
  signInWithZalo,
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.submissionStatus = AuthSubmissionStatus.initial,
    this.action = AuthAction.idle,
    this.session,
    this.message,
  });

  final AuthStatus status;
  final AuthSubmissionStatus submissionStatus;
  final AuthAction action;
  final AuthSession? session;
  final String? message;

  AuthState copyWith({
    AuthStatus? status,
    AuthSubmissionStatus? submissionStatus,
    AuthAction? action,
    AuthSession? session,
    String? message,
    bool clearMessage = false,
    bool clearSession = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      action: action ?? this.action,
      session: clearSession ? null : (session ?? this.session),
      message: clearMessage ? null : (message ?? this.message),
    );
  }

  bool get isLoading => submissionStatus == AuthSubmissionStatus.loading;

  @override
  List<Object?> get props => [
        status,
        submissionStatus,
        action,
        session,
        message,
      ];
}
