import 'package:cuidapet_mobile/app/core/rest_client/rest_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            child: const Text('Logout'),
          ),
          TextButton(
            onPressed: () async {
              final categoriesresponse =
                  await Modular.get<RestClient>().auth().get('/categories/');
              print(categoriesresponse.data);
            },
            child: const Text('teste reflesh token'),
          ),
        ],
      ),
    );
  }
}
