import 'package:cuidapet_mobile/app/models/social_network_model.dart';

abstract class RepositorySocial {
  Future<SocialNetworkModel> gooleLogin();
  Future<SocialNetworkModel> facebookLogin();
}
