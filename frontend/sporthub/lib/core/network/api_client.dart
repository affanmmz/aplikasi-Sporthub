import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  // Ganti dengan IP lokal (misal 10.0.2.2:3000 untuk emulator Android) atau URL server Express.js
  static const String baseUrl = 'http://10.0.2.2:3000/api/v1';

  final Dio dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  ApiClient()
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        )) {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        // TODO: Implementasi refresh token ke POST /auth/refresh jika status 401
        return handler.next(e);
      },
    ));
  }
}