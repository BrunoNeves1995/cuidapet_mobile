import 'package:cuidapet_mobile/app/mudules/address/address_module.dart';
import 'package:cuidapet_mobile/app/mudules/auth/auth_module.dart';
import 'package:cuidapet_mobile/app/mudules/home/home_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  List<Bind<Object>> get binds => [];

  @override
  List<ModularRoute> get routes => [
        ModuleRoute('/auth/', module: AuthModule()),
        ModuleRoute('/home/', module: HomeModule()),
         ModuleRoute('/address/', module: AddressModule()),
      ];
}
