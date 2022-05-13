import 'package:cuidapet_mobile/app/core/ui/extensions/size_scren_extension.dart';
import 'package:cuidapet_mobile/app/core/ui/extensions/theme_extensions.dart';
import 'package:cuidapet_mobile/app/core/ui/icons/cuidapet_icons.dart';
import 'package:cuidapet_mobile/app/core/ui/widgets/cuidapet_default_button.dart';
import 'package:cuidapet_mobile/app/core/ui/widgets/cuidapet_default_icon_button.dart';
import 'package:cuidapet_mobile/app/core/ui/widgets/cuidapet_textform_field.dart';
import 'package:cuidapet_mobile/app/mudules/auth/login/widgets/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:validatorless/validatorless.dart';


part 'widgets/login_form.dart';
part 'widgets/login_register_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: 100.h),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 162.w,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 20.0),
              const _LoginForm(),
              const SizedBox(height: 20.0),
              const _OrSeparator(),
              const _LoginRegisterButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrSeparator extends StatelessWidget {
  const _OrSeparator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Text(
            'OU',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
                color: context.primaryColor),
          ),
        ),
        const Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
