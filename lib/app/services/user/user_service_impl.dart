import 'package:cuidapet_mobile/app/core/logger/app_logger.dart';
import 'package:cuidapet_mobile/app/core/ui/exception/failere.dart';
import 'package:cuidapet_mobile/app/core/ui/exception/user_exists_exceptions.dart';
import 'package:cuidapet_mobile/app/core/ui/exception/user_not_exist_exceptions.dart';
import 'package:cuidapet_mobile/app/repositories/user/user_repository.dart';
import 'package:cuidapet_mobile/app/services/user/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final AppLogger _log;

  UserServiceImpl({
    required UserRepository userRepository,
    required AppLogger log,
  })  : _log = log,
        _userRepository = userRepository;

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
        // email verificado com sucesso
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
}
