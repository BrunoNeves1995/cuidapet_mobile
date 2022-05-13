// NESSA CLASSE TEREMOS ATRIBUTOS DE CLASSE
import 'package:flutter/material.dart';

class UiConfig {
  UiConfig._();

  //* METODO DO TIPO GET ->  TITLE DO NOSSO TEMA
  static String get title => 'Cuidapet';

   //* METODO DO TIPO GET ->  THEME DO NOSSO SISTEMA
   static ThemeData get theme  => ThemeData(
     primaryColor: const Color(0xFFA8CE4B),
     primaryColorDark: const Color(0xFF689F38),
     primaryColorLight: const Color(0xFFDDE9C7),
     appBarTheme: const AppBarTheme(
       backgroundColor:Color(0xFFA8CE4B),
     ),
   );

}
