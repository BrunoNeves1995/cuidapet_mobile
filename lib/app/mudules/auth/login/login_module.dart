import 'package:cuidapet_mobile/app/mudules/auth/login/login_page.dart';
import 'package:cuidapet_mobile/app/mudules/auth/login/widgets/login_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class LoginModule extends Module {
  @override
  final List<Bind> binds = [
    
    Bind.lazySingleton((i) => LoginController(
          userService: i(), // pegando do AuthModulo,
          log: i(), // pegando do coreModule,
        ))
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, __) => const LoginPage()),
  ];
}
