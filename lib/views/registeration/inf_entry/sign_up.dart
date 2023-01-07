import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'inf_entry.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  // ignore: constant_identifier_names
  static const String ScreenRoute = 'sign_up';

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late String _emailAddress;
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool isLoading = false;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(
              title: const Center(
                child: Text(
                  'إنشاء حساب جديد',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Lalezar',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
              backgroundColor: Color.fromRGBO(7, 205, 219, 1),
              elevation: 10,
            ),
            body: Center(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
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
                                                Color.fromRGBO(255, 166, 0, 1),
                                          ),
                                        ),
                                        suffixIcon: const Icon(
                                          Icons.email_outlined,
                                          color: Color.fromARGB(
                                              255, 201, 201, 201),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
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
                                                "[a-zA-Z0-9+._%-+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+")
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
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 201, 201, 201),
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  255, 166, 0, 1),
                                            ),
                                          ),
                                          suffixIcon: const Icon(
                                            Icons.lock_outline,
                                            color: Color.fromARGB(
                                                255, 201, 201, 201),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          filled: true,
                                          labelStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontFamily: 'Lalezar',
                                          ),
                                          labelText: "أدخل كلمة المرور",
                                          fillColor: Colors.white70),
                                      obscureText: true, //hide the password
                                      controller: _password,
                                      maxLines: 1,
                                      validator: (value) {
                                        if (value!.isEmpty ||
                                            value.length < 6) {
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
                                          enabledBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  255, 201, 201, 201),
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Color.fromRGBO(
                                                  255, 166, 0, 1),
                                            ),
                                          ),
                                          suffixIcon: const Icon(
                                            Icons.lock_outline,
                                            color: Color.fromARGB(
                                                255, 201, 201, 201),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          filled: true,
                                          labelStyle: TextStyle(
                                            color: Colors.grey[400],
                                            fontFamily: 'Lalezar',
                                          ),
                                          labelText: "تأكيد كلمة المرور",
                                          fillColor: Colors.white70),
                                      obscureText: true,
                                      maxLines: 1,
                                      controller: _confirmPassword,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'الرجاء املاء الحقل';
                                        }
                                        if (_confirmPassword.text !=
                                            _password.text) {
                                          return 'كلمة المرور غير متطابقة';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                              width: 300,
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
                                  }
                                  try {
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: _emailAddress,
                                            password: _password.text);
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushReplacementNamed(
                                        context, InfEntry.ScreenRoute);
                                  } on FirebaseAuthException catch (e) {
                                    if (e.code == 'weak-password') {
                                      AwesomeDialog(
                                        context: context,
                                        title: 'Error',
                                        body: const Text(
                                          'كلمة المرور ضعيفة جدا',
                                          style: TextStyle(
                                              fontFamily: 'Lalezar',
                                              fontSize: 25,
                                              color: Colors.red),
                                        ),
                                      ).show();
                                      print(
                                          'The password provided is too weak.');
                                    } else if (e.code ==
                                        'email-already-in-use') {
                                      AwesomeDialog(
                                        context: context,
                                        title: 'Error',
                                        body: const Text(
                                          'البريد مسجل بالفعل',
                                          style: TextStyle(
                                              fontFamily: 'Lalezar',
                                              fontSize: 25,
                                              color: Colors.red),
                                        ),
                                      ).show();

                                      print(
                                          'The account already exists for that email.');
                                    }
                                  } catch (e) {
                                    print(e);
                                  }

                                  //////
                                  setState(() {
                                    isLoading = false;
                                  });
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
                        height: 100,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'لديك حساب بالفعل ؟ ',
                            style: TextStyle(
                              fontFamily: 'Lalezar',
                              fontSize: 20,
                              color: Color.fromRGBO(245, 171, 0, 1),
                            ),
                            maxLines: 1,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      InfEntry(email: _emailAddress),
                                ),
                              );
                            },
                            child: const Text(
                              'اضغط هنا',
                              style: TextStyle(
                                fontFamily: 'Lalezar',
                                fontSize: 20,
                                color: Color.fromRGBO(99, 149, 255, 1),
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 100,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'بتسجيلك أنت توافق على',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Lalezar',
                              color: Color.fromRGBO(245, 171, 0, 1),
                            ),
                          ),
                          InkWell(
                            onTap: (() {}),
                            child: const Text(
                              ' الأحكام والشروط',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Lalezar',
                                color: Color.fromRGBO(99, 149, 255, 1),
                              ),
                            ),
                          ),
                          const Text(
                            ' و ',
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Lalezar',
                              color: Color.fromRGBO(245, 171, 0, 1),
                            ),
                          ),
                          InkWell(
                            onTap: (() {}),
                            child: const Text(
                              'سياسة الخصوصية',
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: 'Lalezar',
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
      ),
    );
  }
}
