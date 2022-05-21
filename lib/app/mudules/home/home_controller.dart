import 'package:cuidapet_mobile/app/core/life_cycle/life_cycle_controller.dart';
import 'package:mobx/mobx.dart';
part 'home_controller.g.dart';

class HomeController = HomeControllerBase with _$HomeController;

abstract class HomeControllerBase with Store, LifeCycleController {
  @override
  void onIniti([Map<String, dynamic>? params]) {
    print('on init chamado');
  }

  @override
  void onReady() {
    print('on onready chamado');
  }

}

