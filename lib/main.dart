import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:little_reader/views/home/letters/letters.dart';
import 'package:little_reader/views/home/stories/hard/test.dart';
import 'package:little_reader/views/registeration/inf_entry/add_child.dart';
import 'package:little_reader/views/registeration/inf_entry/inf_entry.dart';
import 'views/registeration/inf_entry/accounts.dart';
import 'views/registeration/inf_entry/first_page.dart';
import 'views/registeration/inf_entry/forget_pass.dart';
import 'views/registeration/inf_entry/sign_in.dart';
import 'views/registeration/inf_entry/sign_up.dart';

bool? isLoggedIn;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    isLoggedIn = true;
  } else {
    isLoggedIn = false;
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: isLoggedIn == true ? const Accounts() : const FirstPage(),
      routes: {
        FirstPage.ScreenRoute: (context) => const FirstPage(),
        SignIn.ScreenRoute: (context) => const SignIn(),
        SignUp.ScreenRoute: (context) => const SignUp(),
        ForgetPass.ScreenRoute: (context) => const ForgetPass(),
        InfEntry.ScreenRoute: (context) => const InfEntry(email: ''),
        AddChild.ScreenRoute: (context) => const AddChild(),
        LettersPage.ScreenRoute: (context) => const LettersPage(),
        LettersPage2.ScreenRoute: (context) => const LettersPage2(),
      },
    );
  }
}
