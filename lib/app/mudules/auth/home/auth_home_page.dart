import 'package:cuidapet_mobile/app/core/ui/extensions/size_scren_extension.dart';
import 'package:cuidapet_mobile/app/models/user_model.dart';
import 'package:cuidapet_mobile/app/mudules/core/auth/auth_store.dart';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class AuthHomePage extends StatefulWidget {
  final AuthStore _authStore;
  const AuthHomePage({Key? key, required AuthStore authStore})
      : _authStore = authStore,
        super(key: key);

  @override
  State<AuthHomePage> createState() => _AuthHomePageState();
}

class _AuthHomePageState extends State<AuthHomePage> {
  @override
  void initState() {
    super.initState();
    //! vai ficar escutando meu usuario logado : effect -> quando acontecer uma alteração ele faz algo
    reaction<UserModel?>((_) => widget._authStore.userLogged, (userLogged) {
      if (userLogged != null && userLogged.email.isNotEmpty) {
        Modular.to.navigate('/home/');
      } else {
        Modular.to.navigate('/auth/login/');
      }
    });

    //! addPostFrameCallback -> é escutando sempre no final quando nossa pagiana ja esta carregada
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget._authStore.loadUserLogged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 162.w,
          height: 130.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
