import 'package:cuidapet_mobile/app/mudules/core/core_module.dart';
import 'package:cuidapet_mobile/app/mudules/home/home_controller.dart';
import 'package:cuidapet_mobile/app/mudules/home/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => HomeController()),
  ];

   @override
  List<Module> get imports => [
        CoreModule(),
      ];
  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, __) => const HomePage()),
  ];
}
