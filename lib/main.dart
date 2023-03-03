import 'package:dr_appoint_app/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

//firebase libraries
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dr.Appoint',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => const MyHomePage(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _notLoggedIn = true; //TODO: ADD LOGIN REMOVE THIS
  // final firebase = FirebaseAuth.instance;
  // @override
  // void initState() {
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //     setState(() {});
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return _notLoggedIn
        //TODO: Change when added login logic
        // return firebase.currentUser == null
        ? Scaffold(
            body: FlutterLogin(
              title: 'Login',
              onLogin: _authUser,
              onSignup: _signupUser,
              onSubmitAnimationCompleted: () {
                setState(() {});
              },
              onRecoverPassword: _recoverPassword,
            ),
          )
        : const Dashboard();
  }

  Future<String?>? _authUser(LoginData data) async {
    // try {
    //   UserCredential userCredential =
    //       await FirebaseAuth.instance.signInWithEmailAndPassword(
    //     email: data.name,
    //     password: data.password,
    //   );
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     return ('No user found for that email.');
    //   } else if (e.code == 'wrong-password') {
    //     return ('Wrong password provided for that user.');
    //   }
    // }
    // return null;

    //TODO: Remove this when applied login logic
    _notLoggedIn = false;
  }

  Future<String?>? _signupUser(SignupData data) async {
    // try {
    //   UserCredential userCredential =
    //       await firebase.createUserWithEmailAndPassword(
    //     email: data.name!,
    //     password: data.password!,
    //   );
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     return ('The password provided is too weak.');
    //   } else if (e.code == 'email-already-in-use') {
    //     return ('The account already exists for that email.');
    //   }
    // } catch (e) {
    //   return (e.toString());
    // }
    // return null;
  }

  Future<String?>? _recoverPassword(String data) {}
}
