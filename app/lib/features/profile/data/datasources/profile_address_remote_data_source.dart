import 'package:app/core/network/api_config.dart';
import 'package:app/features/profile/data/models/user_address_model.dart';
import 'package:dio/dio.dart';

abstract interface class ProfileAddressRemoteDataSource {
  Future<UserAddressModel?> getAddress();

  Future<UserAddressModel> saveAddress(UserAddressModel address);
}

class ProfileAddressRemoteDataSourceImpl
    implements ProfileAddressRemoteDataSource {
  const ProfileAddressRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  Map<String, dynamic>? _asStringKeyMap(Object? value) {
    if (value is! Map) {
      return null;
    }
    return Map<String, dynamic>.from(value);
  }

  @override
  Future<UserAddressModel?> getAddress() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.authMeAddress,
    );
    final data = _asStringKeyMap(response.data?['data']);
    if (data == null) {
      return null;
    }

    final address = _asStringKeyMap(data['address']);
    if (address == null || address.isEmpty) {
      return null;
    }

    final detail = address['detail'] as String? ?? '';
    final label = address['label'] as String? ?? '';
    final hasCoordinates =
        address['latitude'] != null || address['longitude'] != null;
    if (detail.trim().isEmpty && label.trim().isEmpty && !hasCoordinates) {
      return null;
    }

    return UserAddressModel.fromJson(address);
  }

  @override
  Future<UserAddressModel> saveAddress(UserAddressModel address) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.authMeAddress,
      data: address.toJson(),
    );
    final data = _asStringKeyMap(response.data?['data']);
    final rawAddress = _asStringKeyMap(data?['address']);
    if (rawAddress == null) {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        message: 'Invalid address response from server.',
      );
    }
    return UserAddressModel.fromJson(rawAddress);
  }
}
