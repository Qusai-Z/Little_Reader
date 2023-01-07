import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPass extends StatefulWidget {
  static const String ScreenRoute = 'forget_pass';
  const ForgetPass({Key? key}) : super(key: key);

  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  final formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String? _email;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                'انشاء كلمة مرور جديدة',
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Lalezar',
                ),
              ),
            ),
            backgroundColor: Color.fromRGBO(7, 205, 219, 1),
          ),
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'من فضلك أدخل البريد الإلكتروني المسجل ',
                    style: TextStyle(
                      fontFamily: 'Lalezar',
                      color: Color.fromRGBO(245, 171, 0, 1),
                      fontSize: 20,
                    ),
                  ),
                  // ignore: prefer_const_constructors

                  // ignore: sized_box_for_whitespace
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 40, right: 40, top: 30),
                          child: Form(
                            key: formKey,
                            child: TextFormField(
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 201, 201, 201),
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromRGBO(255, 113, 25, 1),
                                  ),
                                ),
                                suffixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: Color.fromARGB(255, 201, 201, 201),
                                ),
                                filled: true,
                                labelStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontFamily: 'Lalezar',
                                ),
                                labelText: "أدخل البريد الإلكتروني",
                                fillColor: Colors.white70,
                              ),
                              keyboardType: TextInputType.emailAddress,
                              maxLines: 1,
                              onChanged: (value) {
                                _email = value;
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'الرجاء ادخال بريد الكتروني';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}')
                                    .hasMatch(value)) {
                                  return 'الرجاء ادخال بريد الكتروني صحيح';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
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

                            elevation: 10,
                            fillColor: Color.fromRGBO(245, 171, 0, 1),
                            // ignore: sort_child_properties_last
                            child: const Text(
                              'ارسال',
                              // ignore: unnecessary_const
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontFamily: 'Lalezar'),
                            ),
                            padding: const EdgeInsets.all(10.0),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                try {
                                  _auth.sendPasswordResetEmail(email: _email!);
                                } catch (e) {
                                  print(e.toString());
                                }
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
          ),
        ),
      ),
    );
  }
}
