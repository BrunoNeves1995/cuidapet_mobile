import 'package:cuidapet_mobile/app/core/helpers/envirioments.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ApplicationConfig {
  Future<void> configureApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await _firebaseCoreConfig();
    await _loadEnv();
  }

  Future<void> _firebaseCoreConfig() async {
    await Firebase.initializeApp();
  }

  Future<void> _loadEnv() => Envirioments.loadEnvs();
  
}
