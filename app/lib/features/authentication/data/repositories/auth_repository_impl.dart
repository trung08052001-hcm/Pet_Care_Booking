import 'package:app/core/error/app_error.dart';
import 'package:app/core/network/network_info.dart';
import 'package:app/features/authentication/data/datasources/auth_data_sources.dart';
import 'package:app/features/authentication/data/models/auth_models.dart';
import 'package:app/features/authentication/domain/entities/auth_session.dart';
import 'package:app/features/authentication/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, AuthSession>> signIn({
    required String identifier,
    required String password,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(Failure(message: 'No internet connection.'));
      }

      final session = await _remoteDataSource.signIn(
        SignInRequestModel(
          identifier: identifier.trim(),
          password: password,
        ),
      );
      await _localDataSource.saveSession(session);
      return Right(session.toEntity());
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(
          exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, AuthSession>> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required bool acceptTerms,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(Failure(message: 'No internet connection.'));
      }

      final session = await _remoteDataSource.signUp(
        SignUpRequestModel(
          fullName: fullName.trim(),
          email: email.trim(),
          phone: phone.trim(),
          password: password,
          confirmPassword: confirmPassword,
          acceptTerms: acceptTerms,
        ),
      );
      await _localDataSource.saveSession(session);
      return Right(session.toEntity());
    } on Exception catch (exception, stackTrace) {
      return Left(
        FailureMapper.fromException(
          exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, AuthSession?>> restoreSession() async {
    try {
      final session = await _localDataSource.getCachedSession();
      return Right(session?.toEntity());
    } on Exception catch (exception, stackTrace) {
      await _localDataSource.clearSession();
      return Left(
        FailureMapper.fromException(
          exception,
          stackTrace: stackTrace,
        ),
      );
    }
  }
}
