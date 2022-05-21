import 'package:cuidapet_mobile/app/core/life_cycle/life_cycle_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'home_controller.g.dart';

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store, LifeCycleController {
  @override
  void onIniti([Map<String, dynamic>? params]) {}

  @override
  Future<void> onReady() async {
    await _hasRegisteredAddress();
  }

  Future<void> _hasRegisteredAddress() async {
    await Modular.to.pushNamed('/address/');
  }
}
