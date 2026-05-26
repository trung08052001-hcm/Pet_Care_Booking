import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

sealed class AppException implements Exception {
  const AppException({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}

class ApiException extends AppException {
  const ApiException({
    required super.message,
    super.statusCode,
  });

  factory ApiException.fromDioException(DioException exception) {
    final statusCode = exception.response?.statusCode;
    final message = switch (exception.type) {
      DioExceptionType.connectionTimeout => 'Connection timeout. Please try again.',
      DioExceptionType.sendTimeout => 'Request send timeout. Please try again.',
      DioExceptionType.receiveTimeout => 'Response timeout. Please try again.',
      DioExceptionType.connectionError => 'No internet connection.',
      DioExceptionType.cancel => 'Request was cancelled.',
      DioExceptionType.badResponse => _messageFromResponse(exception),
      DioExceptionType.badCertificate => 'Bad certificate received from server.',
      DioExceptionType.unknown => 'Something went wrong. Please try again.',
    };

    return ApiException(
      message: message,
      statusCode: statusCode,
    );
  }

  static String _messageFromResponse(DioException exception) {
    final response = exception.response;
    final data = response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    return switch (response?.statusCode) {
      401 => 'Your session has expired. Please sign in again.',
      403 => 'You do not have permission to perform this action.',
      404 => 'Requested resource was not found.',
      422 => 'The server could not process the request.',
      500 => 'Server error. Please try again later.',
      _ => 'Unexpected server error. Please try again later.',
    };
  }
}

class CacheException extends AppException {
  const CacheException({required super.message});
}

class Failure extends Equatable {
  const Failure({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;

  @override
  List<Object?> get props => [
        message,
        statusCode,
      ];
}

class FailureMapper {
  const FailureMapper._();

  static Failure fromException(
    Object exception, {
    StackTrace? stackTrace,
  }) {
    if (exception is Failure) {
      return exception;
    }

    if (exception is ApiException) {
      return Failure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    }

    if (exception is DioException) {
      final apiException = ApiException.fromDioException(exception);
      return Failure(
        message: apiException.message,
        statusCode: apiException.statusCode,
      );
    }

    if (exception is CacheException) {
      return Failure(message: exception.message);
    }

    return const Failure(
      message: 'Unexpected error. Please try again.',
    );
  }
}
