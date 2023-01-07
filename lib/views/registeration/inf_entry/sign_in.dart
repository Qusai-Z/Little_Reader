import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:little_reader/views/registeration/inf_entry/add_child.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'forget_pass.dart';
import 'sign_up.dart';

class SignIn extends StatefulWidget {
  // ignore: constant_identifier_names
  static const ScreenRoute = 'sign_in';
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _auth = FirebaseAuth.instance;
  late String _emailAddress;
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                  child: Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Lalezar',
                    ),
                  ),
                ),
              ),
              backgroundColor: Color.fromRGBO(7, 205, 219, 1),
              elevation: 10,
            ),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'imgs/little-kid.png',
                      height: 130,
                    ),
                    // ignore: sized_box_for_whitespace
                    Form(
                      key: formKey,
                      // ignore: sized_box_for_whitespace
                      child: Column(
                        children: [
                          // ignore: sized_box_for_whitespace
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 40, right: 40),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 201, 201, 201),
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromRGBO(255, 113, 25, 1),
                                        ),
                                      ),
                                      suffixIcon: const Icon(
                                        Icons.email_outlined,
                                        color:
                                            Color.fromARGB(255, 201, 201, 201),
                                      ),
                                      border: const OutlineInputBorder(),
                                      filled: true,
                                      labelStyle: TextStyle(
                                          color: Colors.grey[400],
                                          fontFamily: 'Lalezar'),
                                      labelText: "أدخل البريد الإلكتروني",
                                      fillColor: Colors.white70,
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    maxLines: 1,
                                    onChanged: (value) {
                                      _emailAddress = value;
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'الرجاء ادخال بريد الكتروني';
                                      }
                                      if (!RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                          .hasMatch(value)) {
                                        return 'الرجاء ادخال بريد الكتروني صحيح';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // ignore: sized_box_for_whitespace
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 40, right: 40),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        enabledBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 201, 201, 201),
                                          ),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color:
                                                Color.fromRGBO(255, 113, 25, 1),
                                          ),
                                        ),
                                        suffixIcon: const Icon(
                                          Icons.lock_outline,
                                          color: Color.fromARGB(
                                              255, 201, 201, 201),
                                        ),
                                        border: const OutlineInputBorder(),
                                        filled: true,
                                        labelStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontFamily: 'Lalezar'),
                                        labelText: "أدخل كلمة المرور",
                                        fillColor: Colors.white70),
                                    obscureText: true,
                                    maxLines: 1,
                                    controller: _password,
                                    validator: (value) {
                                      if (value!.isEmpty || value.length < 6) {
                                        return 'الرجاء ادخال كلمة مرور لا تقل عن ستة خانات';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),

                          // ignore: sized_box_for_whitespace
                        ],
                      ),
                    ),

                    // ignore: sized_box_for_whitespace
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(
                                left: 100, right: 100, top: 30),
                            child: RawMaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();

                                  setState(() {
                                    isLoading = true;
                                  });

                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: _emailAddress,
                                            password: _password.text);
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushReplacementNamed(
                                        context, AddChild.ScreenRoute);
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'user-not-found') {
                                      AwesomeDialog(
                                        context: context,
                                        title: '!خطأ',
                                        body: const Text(
                                          'لا يوجد بريد مسجل بهذا الاسم',
                                          style: TextStyle(
                                              fontFamily: 'Lalezar',
                                              fontSize: 25,
                                              color: Colors.red),
                                        ),
                                      ).show();
                                      print('No user found for that email.');
                                    } else if (e.code == 'wrong-password') {
                                      AwesomeDialog(
                                        context: context,
                                        title: '!خطأ',
                                        body: const Text(
                                          'كلمة المرور غير صحيحة',
                                          style: TextStyle(
                                              fontFamily: 'Lalezar',
                                              fontSize: 25,
                                              color: Colors.red),
                                        ),
                                      ).show();
                                      print(
                                          'Wrong password provided for that user.');
                                    }
                                  }
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              },

                              elevation: 10,
                              fillColor: Color.fromRGBO(245, 171, 0, 1),
                              // ignore: sort_child_properties_last
                              child: const Text(
                                'التالي',
                                // ignore: unnecessary_const
                                style: const TextStyle(
                                  color: Colors.white,
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
                      height: 60,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          ' هل نسيت كلمة المرور ؟',
                          style: TextStyle(
                            fontFamily: 'Lalezar',
                            fontSize: 20,
                            color: Color.fromRGBO(245, 171, 0, 1),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ForgetPass.ScreenRoute);
                          },
                          child: const Text(
                            ' اضغط هنا',
                            style: TextStyle(
                              fontFamily: 'Lalezar',
                              fontSize: 20,
                              color: Color.fromRGBO(99, 149, 255, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'ليس لديك حساب  ؟ ',
                          style: TextStyle(
                            fontFamily: 'Lalezar',
                            fontSize: 20,
                            color: Color.fromRGBO(245, 171, 0, 1),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, SignUp.ScreenRoute);
                          },
                          child: const Text(
                            'اضغط هنا',
                            style: TextStyle(
                              fontFamily: 'Lalezar',
                              fontSize: 20,
                              color: Color.fromRGBO(99, 149, 255, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
