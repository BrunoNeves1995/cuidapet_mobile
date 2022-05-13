import 'package:cuidapet_mobile/app/mudules/auth/home/auth_home_page.dart';
import 'package:cuidapet_mobile/app/mudules/auth/login/login_module.dart';
import 'package:cuidapet_mobile/app/mudules/auth/register/register_module.dart';
import 'package:cuidapet_mobile/app/mudules/core/core_module.dart';
import 'package:cuidapet_mobile/app/repositories/user/user_repository.dart';
import 'package:cuidapet_mobile/app/repositories/user/user_repository_impl.dart';
import 'package:cuidapet_mobile/app/services/user/user_service.dart';
import 'package:cuidapet_mobile/app/services/user/user_service_impl.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton<UserRepository>((i) => UserRepositoryImpl(
          log: i(), // esta no CoreModule
          restClient: i(), // esta no CoreModule
        )),
    Bind.lazySingleton<UserService>((i) => UserServiceImpl(
          log: i(), // esta no CoreModule
          userRepository: i(), // esta no AuthModule
        )),
  ];

  @override
  List<Module> get imports => [
        CoreModule(),
      ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      Modular.initialRoute,
      child: (_, __) => AuthHomePage(
        authStore: Modular.get(),
      ),
    ),
    ModuleRoute('/login', module: LoginModule()),
    ModuleRoute('/register', module: RegisterModule()),
  ];
}
