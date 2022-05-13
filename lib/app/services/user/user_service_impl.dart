import 'package:cuidapet_mobile/app/core/logger/app_logger.dart';
import 'package:cuidapet_mobile/app/core/ui/exception/failere.dart';
import 'package:cuidapet_mobile/app/core/ui/exception/user_exists_exceptions.dart';
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
      throw Failere(message: 'Erro ao criar usuario');
    }
  }
}
