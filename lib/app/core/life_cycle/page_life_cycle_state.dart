import 'package:cuidapet_mobile/app/core/life_cycle/life_cycle_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';

abstract class PageLifeCycleState<C extends LifeCycleController,
    P extends StatefulWidget> extends State<P> {
  final controller = Modular.get<C>();

  Map<String, dynamic>? get params => null;

  @override
  void initState() {
    super.initState();
    controller.onIniti(params);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => controller.onReady());
  }
}
