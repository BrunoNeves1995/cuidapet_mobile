import 'package:cuidapet_mobile/app/core/helpers/constants.dart';
import 'package:cuidapet_mobile/app/core/helpers/envirioments.dart';
import 'package:cuidapet_mobile/app/core/local_storage/local_storage.dart';
import 'package:cuidapet_mobile/app/core/logger/app_logger.dart';
import 'package:cuidapet_mobile/app/core/rest_client/dio/interceptors/auth_reflesh_token_interceptors.dart';
import 'package:cuidapet_mobile/app/core/rest_client/dio/interceptors/dio_interceptor.dart';
import 'package:cuidapet_mobile/app/core/rest_client/dio/rest_client_exception.dart';
import 'package:cuidapet_mobile/app/core/rest_client/rest_client.dart';
import 'package:cuidapet_mobile/app/core/rest_client/rest_client_response.dart';
import 'package:cuidapet_mobile/app/mudules/core/auth/auth_store.dart';
import 'package:dio/dio.dart';

class DioRestClient implements RestClient {
  late final Dio _dio;

  final _defaultBaseOptions = BaseOptions(
    baseUrl: Envirioments.param(Constants.ENV_BASE_URL_KEY) ?? '',
    connectTimeout: int.parse(
        Envirioments.param(Constants.ENV_REST_CLIENT_CONNECT_TIMEOUT_KEY) ??
            '0'),
    receiveTimeout: int.parse(
        Envirioments.param(Constants.ENV_REST_CLIENT_RECEIVE_TIMEOUT_KEY) ??
            '0'),
  );

  DioRestClient(
      {
      //! no construtor constumizamos defaultBaseOptions para que eu possa passar outro defaultBaseOptions que nao seja o meu
      BaseOptions? baseOptions,
      required LocalStorage localStorage,
      required LocalSecureStorage localSecureStorage,
      required AppLogger log,
      required AuthStore authStore}) {
    //* associando o dio a variavel privada
    _dio = Dio(baseOptions ?? _defaultBaseOptions);
    _dio.interceptors.addAll([
      DioInterceptor(localStorage: localStorage, authStore: authStore),
      AuthRefleshTokenInterceptors(
        authStore: authStore,
        localStorage: localStorage,
        localSecureStorage: localSecureStorage,
        restClient: this,
        log: log,
      ),
      LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  @override
  RestClient auth() {
    //! serve para informa para o Dio que nos vamos utilizar autenticação ou que nos não vamos usar uma autenticação
    //* enviando um parametro para dentro do Dio, onde nos possamos pegar ele  depois
    _defaultBaseOptions.extra[Constants.REST_CLIENT_AUTH_REQUIRED_KEY] = true;
    return this;
  }

  @override
  RestClient unAuth() {
    //* enviando um parametro para dentro do Dio, onde nos possamos pegar ele  depois
    _defaultBaseOptions.extra[Constants.REST_CLIENT_AUTH_REQUIRED_KEY] = false;
    return this;
  }

  @override
  Future<RestClientResponse<T>> delete<T>(String path,
      {data,
      Map<String, dynamic>? queryParamiters,
      Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParamiters,
        options: Options(headers: headers),
      );
      return _dioResponseConverter(response);
    } on DioError catch (e) {
      _throwRestClienteException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParamiters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParamiters,
        options: Options(headers: headers),
      );
      return _dioResponseConverter(response);
    } on DioError catch (e) {
      _throwRestClienteException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> patch<T>(String path,
      {data,
      Map<String, dynamic>? queryParamiters,
      Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.patch(
        path,
        data: data,
        queryParameters: queryParamiters,
        options: Options(headers: headers),
      );
      return _dioResponseConverter(response);
    } on DioError catch (e) {
      _throwRestClienteException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> post<T>(String path,
      {data,
      Map<String, dynamic>? queryParamiters,
      Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParamiters,
        options: Options(headers: headers),
      );
      return _dioResponseConverter(response);
    } on DioError catch (e) {
      _throwRestClienteException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> put<T>(String path,
      {data,
      Map<String, dynamic>? queryParamiters,
      Map<String, dynamic>? headers}) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParamiters,
        options: Options(headers: headers),
      );
      return _dioResponseConverter(response);
    } on DioError catch (e) {
      _throwRestClienteException(e);
    }
  }

  @override
  Future<RestClientResponse<T>> request<T>(
    String path, {
    required String method,
    data,
    Map<String, dynamic>? queryParamiters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParamiters,
        options: Options(
          headers: headers,
          method: method,
        ),
      );
      return _dioResponseConverter(response);
    } on DioError catch (e) {
      _throwRestClienteException(e);
    }
  }

  Future<RestClientResponse<T>> _dioResponseConverter<T>(
      Response<dynamic> response) async {
    return RestClientResponse<T>(
      data: response.data,
      statusCode: response.statusCode,
      statusMessage: response.statusMessage,
    );
  }

  Never _throwRestClienteException(DioError dioError) {
    final response = dioError.response;
    throw RestClientException(
      error: dioError.error,
      message: response?.statusMessage,
      statusCode: response?.statusCode,
      response: RestClientResponse(
        data: response?.data,
        statusCode: response?.statusCode,
        statusMessage: response?.statusMessage,
      ),
    );
  }
}
