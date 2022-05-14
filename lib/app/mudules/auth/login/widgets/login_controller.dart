import 'package:cuidapet_mobile/app/core/ui/exception/failere.dart';
import 'package:cuidapet_mobile/app/core/ui/exception/user_not_exist_exceptions.dart';
import 'package:cuidapet_mobile/app/core/ui/widgets/loader.dart';
import 'package:cuidapet_mobile/app/mudules/auth/login/widgets/messages.dart';
import 'package:mobx/mobx.dart';
import 'package:cuidapet_mobile/app/core/logger/app_logger.dart';
import 'package:cuidapet_mobile/app/services/user/user_service.dart';

part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  final UserService _userService;
  final AppLogger _log;
  _LoginControllerBase({
    required UserService userService,
    required AppLogger log,
  })  : _userService = userService,
        _log = log;

  Future<void> login(String login, String password) async {
    try {
      Loader.show();
      await _userService.login(login, password);
      Loader.hide();
    } on Failere catch (e, s) {
      final errorMessage = e.message ?? 'Erro ao realizar login';
      _log.error(errorMessage, e, s);
      Loader.hide();
      Messages.alert(errorMessage);
    } on UserNotExistExceptions {
      const errorMessage = 'Usuario não cadastrado';
      _log.error(errorMessage);
      Loader.hide();
      Messages.alert(errorMessage);
    }
  }
}
