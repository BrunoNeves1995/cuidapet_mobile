import 'package:cuidapet_mobile/app/core/ui/exception/failere.dart';
import 'package:cuidapet_mobile/app/models/social_network_model.dart';
import 'package:cuidapet_mobile/app/repositories/social/repository_social.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RepositorySocialImpl implements RepositorySocial {
  @override
  Future<SocialNetworkModel> facebookLogin() {
    // TODO: implement facebookLogin
    throw UnimplementedError();
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
