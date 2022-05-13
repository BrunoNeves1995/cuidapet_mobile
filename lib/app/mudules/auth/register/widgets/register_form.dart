part of '../register_page.dart';

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

//! acessando diretamente pelo ModularState, a classe register_controller e pegando a instancia de controller
class _RegisterFormState
    extends ModularState<_RegisterForm, RegisterController> {
  final _formKey = GlobalKey<FormState>();
  final _loginEC = TextEditingController();
  final _passwordEC = TextEditingController();

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
          // const SizedBox(height: 20.0),
          CuidapetTextformField(
            controller: _loginEC,
            label: 'E-mail',
            validator: Validatorless.multiple([
              Validatorless.required('Campo Obrigatório'),
              Validatorless.email('E-mail inválido'),
            ]),
          ),
          const SizedBox(height: 20.0),
          CuidapetTextformField(
            controller: _passwordEC,
            label: 'Senha',
            obscureText: true,
            validator: Validatorless.multiple([
              Validatorless.required('Campo Obrigatório'),
              Validatorless.min(6, 'Senha precisa ter no minimo 6 caracteres'),
            ]),
          ),
          const SizedBox(height: 20.0),
          CuidapetTextformField(
            label: 'Confirma Senha',
            obscureText: true,
            validator: Validatorless.multiple([
              Validatorless.required('Campo Obrigatório'),
              Validatorless.min(
                  6, 'Confirma Senha precisa ter no minimo 6 caracteres'),
              Validatorless.compare(
                  _passwordEC, 'Senha e confirma senha devem ser iguais!')
            ]),
          ),
          const SizedBox(height: 20.0),
          CuidapetDefaultButton(
              onPressed: () {
                final formValid = _formKey.currentState?.validate() ?? false;
                if (formValid) {
                  controller.register(email: _loginEC.text, password: _passwordEC.text);
                }
              },
              label: 'Cadastrar')
        ],
      ),
    );
  }
}
