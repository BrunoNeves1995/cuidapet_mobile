import 'package:cuidapet_mobile/app/core/helpers/constants.dart';
import 'package:dio/dio.dart';

import 'package:cuidapet_mobile/app/core/local_storage/local_storage.dart';
import 'package:cuidapet_mobile/app/core/logger/app_logger.dart';

//* quando extendo alguma cosia -> tenho a capacidade de sobrescrever os metodos
class DioInterceptor extends Interceptor {
  final LocalStorage _localStorage;
  final AppLogger _log;
  DioInterceptor({
    required LocalStorage localStorage,
    required AppLogger log,
  })  : _localStorage = localStorage,
        _log = log;

  //! onRequest -> é sempre executado antes de enviar nossa requisão la para dentro do backend antes de sair do nosso app
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final authRequerid =
        options.extra[Constants.REST_CLIENT_AUTH_REQUIRED_KEY] ?? false;

    if (authRequerid) {
      final accessToken = await _localStorage
          .read<String>(Constants.LOCAL_STORAGE_ACCESS_TOKEN_KEY);
      //! verificar aqui bruno -> || access_token.isEmpty - ta a mais
      if (accessToken == null) {
        return handler.reject(
          DioError(
            requestOptions: options,
            error: 'Expire Token',
            type: DioErrorType.cancel,
          ),
        );
      }

      options.headers['Authorization'] = accessToken;
    } else {
      options.headers.remove('Authorization');
    }

    //*dizemos para o dio que ele pode dar continuidade na requisição
    handler.next(options);
  }

  // //! vai ser executado antes de mandar para quem nos chamou
  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   super.onResponse(response, handler);
  // }

  // //! antes de disparar o erro, executa esse metodo primeiro
  // @override
  // void onError(DioError err, ErrorInterceptorHandler handler) {
  //   super.onError(err, handler);
  // }
}
