
import 'package:cuidapet_mobile/app/core/ui/widgets/loader.dart';
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
    Loader.show();
    print(login);
    print(password);
    await Future.delayed(const Duration(seconds: 2));
    Loader.hide();
  }
}
