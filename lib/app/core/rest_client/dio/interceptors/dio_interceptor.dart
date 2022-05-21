import 'package:cuidapet_mobile/app/core/helpers/constants.dart';
import 'package:cuidapet_mobile/app/mudules/core/auth/auth_store.dart';
import 'package:dio/dio.dart';

import 'package:cuidapet_mobile/app/core/local_storage/local_storage.dart';
//* quando extendo alguma cosia -> tenho a capacidade de sobrescrever os metodos
class DioInterceptor extends Interceptor {
  final LocalStorage _localStorage;

  final AuthStore _authStore;
  DioInterceptor(
      {required LocalStorage localStorage,
    
      required AuthStore authStore})
      : _localStorage = localStorage,
       
        _authStore = authStore;

  //! onRequest -> é sempre executado antes de enviar nossa requisão la para dentro do backend antes de sair do nosso app
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final authRequerid =
        options.extra[Constants.REST_CLIENT_AUTH_REQUIRED_KEY] ?? false;

    if (authRequerid) {
      final accessToken = await _localStorage
          .read<String>(Constants.LOCAL_STORAGE_ACCESS_TOKEN_KEY);
      if (accessToken == null) {
        _authStore.logout();
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

 
}
