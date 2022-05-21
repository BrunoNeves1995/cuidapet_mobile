import 'package:flutter_modular/flutter_modular.dart';

mixin LifeCycleController implements Disposable {
  
  void onIniti([Map<String, dynamic>? params]);
  
  void onReady();

  @override
  void dispose() {}
}
