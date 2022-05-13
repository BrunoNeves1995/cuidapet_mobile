import 'package:cuidapet_mobile/app/mudules/auth/register/register_page.dart';
import 'package:cuidapet_mobile/app/mudules/auth/register/widgets/register_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RegisterModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => RegisterController(
          log: i(), // importando do AuthModule
          userService: i(), // importando do coreModule
        )),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, __) => const RegisterPage()),
  ];
}
