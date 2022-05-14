import 'package:cuidapet_mobile/app/core/logger/app_logger.dart';
import 'package:cuidapet_mobile/app/core/rest_client/dio/rest_client_exception.dart';
import 'package:cuidapet_mobile/app/core/rest_client/rest_client.dart';
import 'package:cuidapet_mobile/app/core/ui/exception/failere.dart';
import 'package:cuidapet_mobile/app/core/ui/exception/user_exists_exceptions.dart';
import 'package:cuidapet_mobile/app/repositories/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final RestClient _restClient;
  final AppLogger _log;

  UserRepositoryImpl({
    required RestClient restClient,
    required AppLogger log,
  })  : _restClient = restClient,
        _log = log;

  @override
  Future<void> register(String email, String password) async {
    //! chamando uma requisição nao autenticada
    try {
      await _restClient.unAuth().post('/auth/register', data: {
        'email': email,
        'password': password,
      });
    } on RestClientException catch (e, s) {
      if (e.statusCode == 400 &&
          e.response.data['message'].contains('Usuário já cadastrado')) {
        _log.error(e.message, e, s);
        throw UserExistsExceptions();
      }

      _log.error('Erro ao tentar cadastrar usuario', e, s);
      throw Failere(message: 'Erro ao registrar o usuario');
    }
  }

  @override
  Future<String> login(String email, String password) async {
    try {
      final result = await _restClient.unAuth().post('/auth/', data: {
        "login": email,
        "password": password,
        "social_login": false,
        "supplier_user": false,
      });
      return result.data['access_token'];
    } on RestClientException catch (e, s) {
      // 403 -> usuario não encontrado
      if (e.statusCode == 403) {
        throw Failere(
            message: 'Usuario inconsistente, entre em contato com o suporte');
      }

      _log.error('erro ao realizar login', e, s);
      throw Failere(
          message: 'erro ao realizar login, tente novamente mais parte');
    }
  }
}
