import 'package:cuidapet_mobile/app/core/ui/exception/user_exists_exceptions.dart';
import 'package:cuidapet_mobile/app/core/ui/widgets/loader.dart';
import 'package:cuidapet_mobile/app/mudules/auth/login/widgets/messages.dart';
import 'package:cuidapet_mobile/app/services/user/user_service.dart';
import 'package:mobx/mobx.dart';

import 'package:cuidapet_mobile/app/core/logger/app_logger.dart';

part 'register_controller.g.dart';

class RegisterController = RegisterControllerBase with _$RegisterController;

abstract class RegisterControllerBase with Store {
  final UserService _userService;
  final AppLogger _log;
  RegisterControllerBase({
    required UserService userService,
    required AppLogger log,
  })  : _log = log,
        _userService = userService;

  Future<void> register(
      {required String email, required String password}) async {
    try {
      Loader.show();
      await _userService.register(email, password);

      Loader.hide();
      Messages.info('Inviamos um e-mail de confirmação no email cadastrado');
    } on UserExistsExceptions {
      Loader.hide();
      Messages.alert('E-mail já utilizado, por favor escolha outro');
    } catch (e, s) {
      _log.error('Erro ao registrar usuário', e, s);
      Loader.hide();
      Messages.alert('Erro ao registrar usuário');
    }
  }
}
