//! vai rodar em cima do num, porque vamos rodar em cima dos numeros
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ESTAMOS ENCAPSULANDO O ScreenUtil
extension SizeScrenExtension on num {
  //! Metodo do tipo get e passamos o this, porque é o numero que eu estou colocando
  double get w => ScreenUtil().setHeight(this);
  double get h => ScreenUtil().setHeight(this);
  double get r => ScreenUtil().radius(this);
  //* Metodo do tipo get -> para trabalharmos com texto
  double get sp => ScreenUtil().setSp(this);
  //* Metodo do tipo get -> que é o tamanho da minha tela porpriamente dita
  double get sw => ScreenUtil().screenWidth * this;
  double get sh => ScreenUtil().screenHeight * this;
  double get statusBar => ScreenUtil().statusBarHeight * this;
}
