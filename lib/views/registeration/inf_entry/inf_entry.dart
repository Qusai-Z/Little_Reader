import 'package:flutter/material.dart';
import 'package:little_reader/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'sign_in.dart';

final _auth = FirebaseAuth.instance;

class InfEntry extends StatefulWidget {
  // ignore: non_constant_identifier_names
  static String ScreenRoute = 'inf_intry';

  final String email;

  const InfEntry({Key? key, required this.email}) : super(key: key);

  @override
  State<InfEntry> createState() => _InfEntryState();
}

class _InfEntryState extends State<InfEntry> {
  final formKey = GlobalKey<FormState>();

  // ignore: non_constant_identifier_names
  late String parent_name;
  String? avatarUrl;
  bool isMale = false;
  bool isLoading = false;

  addUserInf() async {
    DatabaseServices db = DatabaseServices();

    await db.setParentInformationData(parent_name, isMale, avatarUrl);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Center(
                child: Text(
                  'املاء البيانات',
                  style: TextStyle(fontFamily: 'Lalezar', fontSize: 25),
                ),
              ),
              backgroundColor: Color.fromRGBO(7, 205, 219, 1),
              elevation: 10,
            ),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isMale = true;
                                avatarUrl =
                                    'https://pbs.twimg.com/media/Ff60Jb9WAAQ-0PD?format=png&name=small';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: isMale ? Colors.grey[300] : Colors.white,
                              ),
                              child: const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://pbs.twimg.com/media/Ff60Jb9WAAQ-0PD?format=png&name=small'),
                                backgroundColor:
                                    Color.fromARGB(255, 255, 178, 71),
                                radius: 60,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isMale = false;
                                avatarUrl =
                                    'https://pbs.twimg.com/media/Ff60L0aXwAkKQXN?format=png&name=small';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color:
                                    !isMale ? Colors.grey[300] : Colors.white,
                              ),
                              child: const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://pbs.twimg.com/media/Ff60L0aXwAkKQXN?format=png&name=small'),
                                backgroundColor: Colors.green,
                                radius: 60,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: 350,
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
                                color: Color.fromRGBO(255, 166, 0, 1),
                              ),
                            ),
                            suffixIcon: const Icon(
                              Icons.person,
                              color: Color.fromARGB(255, 201, 201, 201),
                            ),
                            border: const OutlineInputBorder(),
                            filled: true,
                            labelStyle: TextStyle(
                              color: Colors.grey[400],
                              fontFamily: 'Lalezar',
                            ),
                            labelText: "الاسم",
                            fillColor: Colors.white70),
                        maxLines: 1,
                        onChanged: (value) {
                          parent_name = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'الرجاء املاء الحقل';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  // ignore: sized_box_for_whitespace
                  Container(
                    width: 300,
                    child: RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          addUserInf();
                          Navigator.pushReplacementNamed(
                            context,
                            SignIn.ScreenRoute,
                          );
                        }
                        setState(() {
                          isLoading = false;
                        });
                      },
                      elevation: 10,
                      fillColor: Color.fromRGBO(255, 166, 0, 1),
                      // ignore: sort_child_properties_last
                      child: const Text(
                        'التالي',
                        // ignore: unnecessary_const
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontFamily: 'Lalezar'),
                      ),
                      padding: const EdgeInsets.all(10.0),
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
