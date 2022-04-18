import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gsoc_application/authenticate.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final String? code = Uri.base.queryParameters["code"];
  Firebase.initializeApp(
    options: kIsWeb ? const FirebaseOptions(
      apiKey: "AIzaSyAwCGgt6MvUl3cyqZfIED7pIPztE95a3mU",
      authDomain: "fcdashboard-a0ce8.firebaseapp.com",
      projectId: "fcdashboard-a0ce8",
      storageBucket: "fcdashboard-a0ce8.appspot.com",
      messagingSenderId: "25812727980",
      appId: "1:25812727980:web:0ba4e282a31f44513fc709",
      measurementId: "G-S618BZG9Q6"
    ) : null
  );
  runApp(MyApp(code: code));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, this.code}) : super(key: key);

  final String? code;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Community Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Authenticate(code: code,),
    );
  }
}