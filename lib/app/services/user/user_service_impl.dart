import 'package:cuidapet_mobile/app/core/helpers/constants.dart';
import 'package:cuidapet_mobile/app/core/local_storage/local_storage.dart';
import 'package:cuidapet_mobile/app/core/logger/app_logger.dart';
import 'package:cuidapet_mobile/app/core/ui/exception/failere.dart';
import 'package:cuidapet_mobile/app/core/ui/exception/user_exists_exceptions.dart';
import 'package:cuidapet_mobile/app/core/ui/exception/user_not_exist_exceptions.dart';
import 'package:cuidapet_mobile/app/models/social_login_type.dart';
import 'package:cuidapet_mobile/app/models/social_network_model.dart';
import 'package:cuidapet_mobile/app/repositories/social/repository_social.dart';
import 'package:cuidapet_mobile/app/repositories/user/user_repository.dart';
import 'package:cuidapet_mobile/app/services/user/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final AppLogger _log;
  final LocalStorage _localStorage;
  final LocalSecureStorage _localSecureStorage;
  final RepositorySocial _repositorySocial;

  UserServiceImpl({
    required UserRepository userRepository,
    required AppLogger log,
    required LocalStorage localStorage,
    required LocalSecureStorage localSecureStorage,
    required RepositorySocial repositorySocial,
  })  : _log = log,
        _userRepository = userRepository,
        _localStorage = localStorage,
        _localSecureStorage = localSecureStorage,
        _repositorySocial = repositorySocial;

  @override
  Future<void> register(String email, String password) async {
    //! 1º parte -> verificar se o usuario esta cadastrado dentro do firebase
    try {
      final firebaseAuth = FirebaseAuth.instance;
      final userMethod = await firebaseAuth.fetchSignInMethodsForEmail(email);

      if (userMethod.isNotEmpty) {
        throw UserExistsExceptions();
      } else {
        //! se o nosso repository conseguiu cadastrar nosso usuario sem nenhum erro
        //* agora vamos fazer o cadastro dentro do nosso backend
        await _userRepository.register(email, password);

        //! agora vamos criar dentro do firebaseauth
        final userRegisterCredencial = await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        //! enviando um email de verificação ao nosso usuario
        await userRegisterCredencial.user?.sendEmailVerification();
      }
    } on FirebaseException catch (e, s) {
      _log.error('Erro ao criar usuário no faribase', e, s);
      throw Failere(message: 'Erro ao criar usuarios');
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      final firebaseAuth = FirebaseAuth.instance;
      final loginMethods = await firebaseAuth.fetchSignInMethodsForEmail(email);

      if (loginMethods.isEmpty) {
        throw UserNotExistExceptions();
      }
      //! 1º verificar se o email existe dentro do farebase
      if (loginMethods.contains('password')) {
        //! 2º fazer o login com firebase
        final userCredencial = await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);
        final userVerified = userCredencial.user?.emailVerified ?? false;
        if (!userVerified) {
          userCredencial.user?.sendEmailVerification();
          throw Failere(
              message:
                  'Email não confirmado, por favor verifique sua caixa de spam');
        }
        //! 2º fazer o login com backend
        final accessToken = await _userRepository.login(email, password);
        await _saveAccessToken(accessToken);
        await _confirmLogin();
        await _getUserData();
      } else {
        throw Failere(
            message:
                'Login não pode ser feito por login e senha, por favor utilize outro método');
      }
    } on FirebaseAuthException catch (e, s) {
      _log.error(
          'Usuario ou senha inválida, FirebaseAuthException [${e.code}]', e, s);
      throw Failere(message: 'Usuario ou senha inválidos!');
    }
  }

  Future<void> _saveAccessToken(String accessToken) => _localStorage
      .write<String>(Constants.LOCAL_STORAGE_ACCESS_TOKEN_KEY, accessToken);

  Future<void> _confirmLogin() async {
    final confirmLoginModel = await _userRepository.confirmLogin();
    //! gravando nosso accessToken
    await _saveAccessToken(confirmLoginModel.accessToken);
    //! gravando nosso refleshToken
    await _localSecureStorage.write<String>(
        Constants.LOCAL_STORAGE_REFLESH_TOKEN_KEY,
        confirmLoginModel.refleshToken);
  }

  Future<void> _getUserData() async {
    final userModel = await _userRepository.getUserLogged();
    //! gravando os dados dentro do localStorage
    await _localStorage.write<String>(
        Constants.LOCAL_STORAGE_USER_LOGGED_DATA_KEY, userModel.toJson());
  }

  @override
  Future<void> socialLogin(SocialLoginType socialLoginType) async {
    try {
      final SocialNetworkModel socialModel;
      final AuthCredential authCredential;
      final firebaseAuth = FirebaseAuth.instance;

      switch (socialLoginType) {
        case SocialLoginType.facebook:
          socialModel = await _repositorySocial.facebookLogin();
          authCredential =
              FacebookAuthProvider.credential(socialModel.accessToken);
          break;
        case SocialLoginType.google:
          socialModel = await _repositorySocial.gooleLogin();
          authCredential = GoogleAuthProvider.credential(
            accessToken: socialModel.accessToken,
            idToken: socialModel.id,
          );
          break;
      }
      final loginMethods =
          await firebaseAuth.fetchSignInMethodsForEmail(socialModel.email);

      final methodCheck = _getMethodSocialLoginType(socialLoginType);

      // se o login não for nullo e o login nao conter google
      if (loginMethods.isNotEmpty && !loginMethods.contains(methodCheck)) {
        throw Failere(
            message:
                'Login não pode ser feito por $methodCheck, por favor utilize outro método');
      }

      await firebaseAuth.signInWithCredential(authCredential);
      final accessToken = await _userRepository.socialSocial(socialModel);
      await _saveAccessToken(accessToken);
      await _confirmLogin();
      await _getUserData();
    } on FirebaseAuthException catch (e, s) {
      _log.error('Erro ao realizar login com $socialLoginType', e, s);
      Failere(message: 'Erro ao realizar login');
    }
  }

  String _getMethodSocialLoginType(SocialLoginType socialLoginType) {
    switch (socialLoginType) {
      case SocialLoginType.facebook:
        return 'facebook.com';
      case SocialLoginType.google:
        return 'google.com';
    }
  }
}
