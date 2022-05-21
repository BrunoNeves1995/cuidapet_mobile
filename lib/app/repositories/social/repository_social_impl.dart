import 'package:cuidapet_mobile/app/core/ui/exception/failere.dart';
import 'package:cuidapet_mobile/app/models/social_network_model.dart';
import 'package:cuidapet_mobile/app/repositories/social/repository_social.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RepositorySocialImpl implements RepositorySocial {
  @override
  Future<SocialNetworkModel> facebookLogin() async {
    final facebookAuth = FacebookAuth.instance;
    final result = await facebookAuth.login();

    switch (result.status) {
      case LoginStatus.success:
        final userData = await facebookAuth.getUserData();
        return SocialNetworkModel(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          type: 'Facebook',
          avatar: userData['picture']['data']['url'],
          accessToken: result.accessToken?.token ?? '',
        );
      case LoginStatus.cancelled:
        throw Failere(message: 'Login cancelado');
      case LoginStatus.failed:
      case LoginStatus.operationInProgress:
        throw Failere(message: result.message);
    }
  }

  @override
  Future<SocialNetworkModel> gooleLogin() async {
    final gooleSignIn = GoogleSignIn();

    //! verificnado se ele ja não esta logado
    if (await gooleSignIn.isSignedIn()) {
      gooleSignIn.disconnect();
    }

    final gooleUser = await gooleSignIn.signIn();
    final googleAuth = await gooleUser?.authentication;

    if (googleAuth != null && gooleUser != null) {
      return SocialNetworkModel(
        id: googleAuth.idToken ?? '',
        name: gooleUser.displayName ?? '',
        email: gooleUser.email,
        type: 'Google',
        avatar: gooleUser.photoUrl ?? '',
        accessToken: googleAuth.accessToken ?? '',
      );
    } else {
      throw Failere(message: 'Erro ao realizar login com o google');
    }
  }
}
