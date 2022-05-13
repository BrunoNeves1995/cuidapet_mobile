import 'package:cuidapet_mobile/app/models/user_model.dart';
import 'package:mobx/mobx.dart';
part 'auth_store.g.dart';

class AuthStore = _AuthStoreBase with _$AuthStore;

abstract class _AuthStoreBase with Store {
  @readonly
  UserModel? _userLogged;

  //! dizendo para o AuthStore que ele precisa se carregar
  @action
  Future<void> loadUserLogged() async {
    //* UserModel.empty() é um usuario não logado
    _userLogged = UserModel.empty();
  }
}
