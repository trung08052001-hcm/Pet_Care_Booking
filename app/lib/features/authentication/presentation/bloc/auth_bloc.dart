import 'package:app/features/authentication/domain/usecases/restore_session_usecase.dart';
import 'package:app/features/authentication/domain/usecases/sign_in_usecase.dart';
import 'package:app/features/authentication/domain/usecases/sign_up_usecase.dart';
import 'package:app/features/authentication/presentation/bloc/auth_event.dart';
import 'package:app/features/authentication/presentation/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._signInUseCase,
    this._signUpUseCase,
    this._restoreSessionUseCase,
  ) : super(const AuthState()) {
    on<AuthSessionRestoreRequested>(_onSessionRestoreRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthFeedbackCleared>(_onFeedbackCleared);
  }

  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final RestoreSessionUseCase _restoreSessionUseCase;

  Future<void> _onSessionRestoreRequested(
    AuthSessionRestoreRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        action: AuthAction.restoreSession,
        submissionStatus: AuthSubmissionStatus.loading,
        clearMessage: true,
      ),
    );

    final result = await _restoreSessionUseCase();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            submissionStatus: AuthSubmissionStatus.failure,
            action: AuthAction.restoreSession,
            message: failure.message,
            clearSession: true,
          ),
        );
      },
      (session) {
        emit(
          state.copyWith(
            status: session == null
                ? AuthStatus.unauthenticated
                : AuthStatus.authenticated,
            submissionStatus: AuthSubmissionStatus.success,
            action: AuthAction.restoreSession,
            session: session,
            clearMessage: true,
            clearSession: session == null,
          ),
        );
      },
    );
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        action: AuthAction.signIn,
        submissionStatus: AuthSubmissionStatus.loading,
        clearMessage: true,
      ),
    );

    final result = await _signInUseCase(
      SignInParams(
        identifier: event.identifier,
        password: event.password,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            submissionStatus: AuthSubmissionStatus.failure,
            action: AuthAction.signIn,
            message: failure.message,
          ),
        );
      },
      (session) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            submissionStatus: AuthSubmissionStatus.success,
            action: AuthAction.signIn,
            session: session,
            message: 'Sign in successful.',
          ),
        );
      },
    );
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        action: AuthAction.signUp,
        submissionStatus: AuthSubmissionStatus.loading,
        clearMessage: true,
      ),
    );

    final result = await _signUpUseCase(
      SignUpParams(
        fullName: event.fullName,
        email: event.email,
        phone: event.phone,
        password: event.password,
        confirmPassword: event.confirmPassword,
        acceptTerms: event.acceptTerms,
      ),
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            submissionStatus: AuthSubmissionStatus.failure,
            action: AuthAction.signUp,
            message: failure.message,
          ),
        );
      },
      (session) {
        emit(
          state.copyWith(
            status: AuthStatus.authenticated,
            submissionStatus: AuthSubmissionStatus.success,
            action: AuthAction.signUp,
            session: session,
            message: 'Sign up successful.',
          ),
        );
      },
    );
  }

  void _onFeedbackCleared(
    AuthFeedbackCleared event,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(
        submissionStatus: AuthSubmissionStatus.initial,
        action: AuthAction.idle,
        clearMessage: true,
      ),
    );
  }
}
