import 'package:cuidapet_mobile/app/core/helpers/constants.dart';
import 'package:cuidapet_mobile/app/core/rest_client/dio/rest_client_exception.dart';
import 'package:cuidapet_mobile/app/core/ui/exception/expire_token_execptions.dart';
import 'package:dio/dio.dart';

import 'package:cuidapet_mobile/app/core/local_storage/local_storage.dart';
import 'package:cuidapet_mobile/app/core/logger/app_logger.dart';
import 'package:cuidapet_mobile/app/core/rest_client/rest_client.dart';
import 'package:cuidapet_mobile/app/mudules/core/auth/auth_store.dart';

class AuthRefleshTokenInterceptors extends Interceptor {
  final AuthStore _authStore;
  final LocalStorage _localStorage;
  final LocalSecureStorage _localSecureStorage;
  final RestClient _restClient;
  final AppLogger _log;
  AuthRefleshTokenInterceptors({
    required AuthStore authStore,
    required LocalStorage localStorage,
    required LocalSecureStorage localSecureStorage,
    required RestClient restClient,
    required AppLogger log,
  })  : _authStore = authStore,
        _localStorage = localStorage,
        _localSecureStorage = localSecureStorage,
        _restClient = restClient,
        _log = log;
  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    try {
      final respStatusCode = err.response?.statusCode ?? 0;
      final reqPath = err.requestOptions.path;

      //* pode ser que tenhamos que fazer o reflesh token
      if (respStatusCode == 403 || respStatusCode == 401) {
        if (reqPath != '/auth/refresh') {
          //! verificando se a requisição era para ser autenticada
          final authRequerid = err.requestOptions
                  .extra[Constants.REST_CLIENT_AUTH_REQUIRED_KEY] ??
              false;

          if (authRequerid) {
            _log.info('=>=>=>=>=>=>=> Refresh Token <=<=<=<=<=<=<=');
            await _refleshtoken(err);
            await _retryRequest(err, handler);
            _log.info('=>=>=>=>=>=>=> Refresh Token success <=<=<=<=<=<=<=');
          } else {
            throw err;
          }
        } else {
          throw err;
        }
      } else {
        throw err;
      }
    } on ExpireTokenExecptions {
      _log.info('=>=>=>=>=>=>=> Refresh Token Expirado <=<=<=<=<=<=<=');
      _authStore.logout();
      handler.next(err);
    } on DioError catch (e) {
      handler.next(e);
    } catch (e, s) {
      _log.info('=>=>=>=>=>=>=> Erro Rest Client <=<=<=<=<=<=<=');
      _log.error('Erro rest client', e, s);
      handler.next(err);
    } 
  }

  Future<void> _refleshtoken(DioError erro) async {
    final refleshToken = await _localSecureStorage
        .read(Constants.LOCAL_STORAGE_REFLESH_TOKEN_KEY);

    if (refleshToken == null) {
      throw ExpireTokenExecptions();
    }

    final resultRefleshToken =
        await _restClient.auth().put('/auth/refresh', data: {
      'refresh_token': refleshToken,
    });

    // ! atualizando os token
    await _localStorage.write<String>(Constants.LOCAL_STORAGE_ACCESS_TOKEN_KEY,
        resultRefleshToken.data['access_token']);

    await _localSecureStorage.write<String>(
        Constants.LOCAL_STORAGE_REFLESH_TOKEN_KEY,
        resultRefleshToken.data['refresh_token']);
  }

  Future<void> _retryRequest(
      DioError err, ErrorInterceptorHandler handler) async {
    _log.info('=>=>=>=>=>=>=> Retry request  ${(err.requestOptions.path)}<=<=<=<=<=<=<=');

    //! pegando nosso request anterior
    final requestOptions = err.requestOptions;

    //* criando a requisição novamente
    final result = await _restClient.request(
      requestOptions.path,
      method: requestOptions.method,
      data: {requestOptions.data},
      headers: requestOptions.headers,
      queryParamiters: requestOptions.queryParameters,
    );

    handler.resolve(Response(
      requestOptions: requestOptions,
      data: result.data,
      statusCode: result.statusCode,
      statusMessage: result.statusMessage,
    ));
  }
}
