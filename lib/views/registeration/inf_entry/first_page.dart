import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:little_reader/services/auth.dart';
import '../../home/home.dart';
import './sign_up.dart';
import 'sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class FirstPage extends StatefulWidget {
  // ignore: constant_identifier_names
  static const String ScreenRoute = 'first_page';
  const FirstPage({Key? key}) : super(key: key);

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool isLoading = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  signInAnonoumouslyFirebase() async {
    Auth auth = Auth();

    await auth.Anonymous_SignIn();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return SafeArea(
      //ModalProgressHUD is for displaying circle loading when switching between screens
      child: ModalProgressHUD(
        //color of circle loading shape
        color: Color.fromRGBO(245, 171, 0, 1),
        //false by default
        inAsyncCall: isLoading,
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),

                  Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://pbs.twimg.com/media/Ffr0h0NWQAMYEVi?format=png&name=small'),
                      ),
                    ),
                  ),

                  const Text(
                    'أهلا بك مع القارئ الصغير',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Lalezar',
                      color: Color.fromRGBO(245, 171, 0, 1),
                    ),
                  ),
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: 200,
                    height: 50,
                    // ignore: prefer_const_constructors
                    child: Divider(
                      thickness: 3,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // ignore: sized_box_for_whitespace
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 100, right: 100),
                          width: 300,
                          child: RawMaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),

                            onPressed: () async {
                              //change the state of the isLoading variable to true

                              signInAnonoumouslyFirebase();

                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Home(
                                    childID: '',
                                    currentAvatar: '',
                                    currentName: '',
                                  ),
                                ),
                              );
                              //after finishing the process; set the state to false again
                            },
                            elevation: 10,
                            fillColor: Color.fromRGBO(7, 205, 219, 1),
                            // ignore: sort_child_properties_last
                            child: const Text(
                              'دخول الطفل',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 30,
                                fontFamily: 'Lalezar',
                              ),
                            ),
                            padding: const EdgeInsets.all(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  // ignore: sized_box_for_whitespace
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 100, right: 100),
                          width: 270,
                          child: RawMaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            onPressed: () async {
                              // ignore: use_build_context_synchronously
                              Navigator.pushNamed(context, SignUp.ScreenRoute);
                            },
                            elevation: 10.0,
                            fillColor: Color.fromRGBO(245, 171, 0, 1),
                            // ignore: sort_child_properties_last
                            child: const Text(
                              'دخول ولي الأمر',
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 25,
                                fontFamily: 'Lalezar',
                              ),
                            ),
                            padding: const EdgeInsets.all(10.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: (() {
                      Navigator.pushNamed(context, SignIn.ScreenRoute);
                    }),
                    child: const Text(
                      'تسجيل الدخول',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lalezar',
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(245, 171, 0, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
