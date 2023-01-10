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
    final currentHeight = MediaQuery.of(context).size.height;
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
              title: Directionality(
                textDirection: TextDirection.rtl,
                child: Center(
                  child: Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontSize: currentHeight / 24,
                      fontFamily: 'Lalezar',
                    ),
                  ),
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: currentHeight / 30,
                ),
              ),
              backgroundColor: const Color.fromRGBO(7, 205, 219, 1),
              elevation: 10,
            ),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Image.asset(
                      'imgs/little-kid.png',
                      height: currentHeight / 4,
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
                                    style:
                                        TextStyle(fontSize: currentHeight / 42),
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
                                      suffixIcon: Icon(
                                        Icons.email_outlined,
                                        color: const Color.fromARGB(
                                            255, 201, 201, 201),
                                        size: currentHeight / 26,
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
                                    style:
                                        TextStyle(fontSize: currentHeight / 42),
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
                                        suffixIcon: Icon(
                                          Icons.lock_outline,
                                          color: const Color.fromARGB(
                                              255, 201, 201, 201),
                                          size: currentHeight / 26,
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
                                        body: Text(
                                          'لا يوجد بريد مسجل بهذا الاسم',
                                          style: TextStyle(
                                              fontFamily: 'Lalezar',
                                              fontSize: currentHeight / 28,
                                              color: Colors.red),
                                        ),
                                      ).show();
                                      print('No user found for that email.');
                                    } else if (e.code == 'wrong-password') {
                                      AwesomeDialog(
                                        context: context,
                                        title: '!خطأ',
                                        body: Text(
                                          'كلمة المرور غير صحيحة',
                                          style: TextStyle(
                                              fontFamily: 'Lalezar',
                                              fontSize: currentHeight / 28,
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
                              fillColor: const Color.fromRGBO(245, 171, 0, 1),
                              // ignore: sort_child_properties_last
                              child: Text(
                                'التالي',
                                // ignore: unnecessary_const
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: currentHeight / 24,
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
                        Text(
                          ' هل نسيت كلمة المرور ؟',
                          style: TextStyle(
                            fontFamily: 'Lalezar',
                            fontSize: currentHeight / 28,
                            color: const Color.fromRGBO(245, 171, 0, 1),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, ForgetPass.ScreenRoute);
                          },
                          child: Text(
                            ' اضغط هنا',
                            style: TextStyle(
                              fontFamily: 'Lalezar',
                              fontSize: currentHeight / 28,
                              color: const Color.fromRGBO(99, 149, 255, 1),
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
                        Text(
                          'ليس لديك حساب  ؟ ',
                          style: TextStyle(
                            fontFamily: 'Lalezar',
                            fontSize: currentHeight / 32,
                            color: const Color.fromRGBO(245, 171, 0, 1),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, SignUp.ScreenRoute);
                          },
                          child: Text(
                            'اضغط هنا',
                            style: TextStyle(
                              fontFamily: 'Lalezar',
                              fontSize: currentHeight / 32,
                              color: const Color.fromRGBO(99, 149, 255, 1),
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
