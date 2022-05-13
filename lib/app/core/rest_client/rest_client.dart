import 'package:cuidapet_mobile/app/core/rest_client/rest_client_response.dart';

abstract class RestClient {
  //! rest cliente -> acesso ao nosso backend autenticado
  RestClient auth();

  //! rest cliente -> acesso ao nosso backend não autenticado
  RestClient unAuth();

  Future<RestClientResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParamiters,
    Map<String, dynamic>? headers,
  });

  Future<RestClientResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParamiters,
    Map<String, dynamic>? headers,
  });

  Future<RestClientResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParamiters,
    Map<String, dynamic>? headers,
  });

  Future<RestClientResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParamiters,
    Map<String, dynamic>? headers,
  });

  Future<RestClientResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParamiters,
    Map<String, dynamic>? headers,
  });

  Future<RestClientResponse<T>> request<T>(
    String path, {
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParamiters,
    Map<String, dynamic>? headers,
  });
}
