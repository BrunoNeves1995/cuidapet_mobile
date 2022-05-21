part of '../login_page.dart';

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

//! Acessando a nossa LoginController -> ModularState<_LoginForm, LoginController>
class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _loginEC = TextEditingController();
  final _passwordEC = TextEditingController();
  final controller = Modular.get<LoginController>();
  @override
  void dispose() {
    _loginEC.dispose();
    _passwordEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CuidapetTextformField(
            label: 'Login',
            controller: _loginEC,
            validator: Validatorless.multiple([
              Validatorless.required('E-mail obrigatório'),
              Validatorless.email('E-mail inválido'),
            ]),
          ),
          const SizedBox(height: 20),
          CuidapetTextformField(
            label: 'Senha',
            obscureText: true,
            controller: _passwordEC,
            validator: Validatorless.multiple([
              Validatorless.required('Senha obrigatória'),
              Validatorless.min(6, 'Senha deve conter pelo menos 6 caracteres'),
              //Validatorless.number('m')
            ]),
          ),
          const SizedBox(height: 20),
          CuidapetDefaultButton(
            onPressed: () async {
              final formValid = _formKey.currentState?.validate() ?? false;
              if (formValid) {
                await controller.login(_loginEC.text, _passwordEC.text);
              }
            },
            label: 'Entrar',
          ),
        ],
      ),
    );
  }
}
