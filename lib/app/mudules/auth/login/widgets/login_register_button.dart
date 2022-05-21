part of '../login_page.dart';

class _LoginRegisterButton extends StatelessWidget {
  final controller = Modular.get<LoginController>();
  _LoginRegisterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          children: [
            CuidapetDefaultIconButton(
              onPressed: () {
                controller.socialLogin(SocialLoginType.facebook);
              },
              color: const Color(0xFF4267B3),
              icon: CuidapetIcons.facebook,
              label: 'Facebook',
              width: .42.sw,
            ),
            CuidapetDefaultIconButton(
              onPressed: () {
                controller.socialLogin(SocialLoginType.google);
              },
              color: const Color(0xFFE15031),
              icon: CuidapetIcons.google,
              label: 'Google',
              width: .42.sw,
            ),
            CuidapetDefaultIconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/auth/register/');
              },
              color: context.primaryColorDark,
              icon: Icons.mail,
              label: 'Cadastre-se',
              width: .42.sw,
            ),
          ],
        ),
      ),
    );
  }
}
