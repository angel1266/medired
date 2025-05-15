import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:reportes_medired/my_home_page.dart';
import 'login_page.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var login = (prefs.getString("login") ?? "0") == "1" ? true : false;

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: FirebaseConfig.apiKey,
      authDomain: FirebaseConfig.authDomain,
      projectId: FirebaseConfig.projectId,
      storageBucket: FirebaseConfig.storageBucket,
      messagingSenderId: FirebaseConfig.messagingSenderId,
      appId: FirebaseConfig.appId,
    ),
  );
  runApp(MyApp(login: login,));
}

class MyApp extends StatelessWidget {
  final bool login;
  MyApp({required this.login});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reportes Medired',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:login ? MyHomePage() : LoginPage(),
    );
  }
}
