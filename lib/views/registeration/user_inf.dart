import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:little_reader/services/database.dart';
import 'package:little_reader/views/registeration/inf_entry/first_page.dart';
import 'package:little_reader/views/registeration/inf_entry/forget_pass.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class UserInformationPage extends StatefulWidget {
  @override
  State<UserInformationPage> createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
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
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(7, 205, 219, 1),
            title: const Center(
              child: Text(
                'تعديل البيانات',
                style: TextStyle(fontFamily: 'Lalezar', fontSize: 25),
              ),
            ),
            elevation: 10,
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('parents')
                    .where("email", isEqualTo: _auth.currentUser!.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  List<UserInf> userInfList = []; //List to Store users

                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator(); //If no data return this
                  }

                  final information = snapshot.data!
                      .docs; //information: stores gets the data from firebase documents

                  for (var item in information) {
                    final getAvatar =
                        item.data().toString().contains('avatar_url')
                            ? item.get('avatar_url')
                            : 'No url Found';
                    final getName = item.data().toString().contains('name')
                        ? item.get('name')
                        : 0;

                    final addToList = UserInf(
                      avatarUrl: getAvatar,
                      name: getName,
                    );

                    userInfList.add(addToList);
                  }
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: userInfList,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInf extends StatelessWidget {
  final String? avatarUrl;
  late String name;

  final formKey = GlobalKey<FormState>();

  editInf() {
    DatabaseServices db = DatabaseServices();
    db.changeUserInformationData(name);
  }

  UserInf({
    Key? key,
    required this.avatarUrl,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: NetworkImage('$avatarUrl'),
          backgroundColor: Colors.white,
        ),
        const SizedBox(
          height: 30,
        ),
        Form(
          key: formKey,
          child: Container(
            margin: const EdgeInsets.only(right: 40, left: 40),
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                labelStyle:
                    TextStyle(color: Colors.grey[400], fontFamily: 'Lalezar'),
                labelText: name,
                fillColor: Colors.white70,
              ),
              onChanged: (value) {
                name = value;
              },
              maxLines: 1,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: const EdgeInsets.only(right: 40, left: 40),
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
                Icons.email_outlined,
                color: Color.fromARGB(255, 201, 201, 201),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              labelStyle:
                  TextStyle(color: Colors.grey[400], fontFamily: 'Lalezar'),
              labelText: '${_auth.currentUser!.email}',
              fillColor: Colors.white70,
            ),
            maxLines: 1,
            readOnly: true,
            enabled: false,
          ),
        ),
        const SizedBox(
          height: 30,
        ),

        Container(
          margin: const EdgeInsets.only(right: 40, left: 40),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              labelStyle:
                  TextStyle(color: Colors.grey[400], fontFamily: 'Lalezar'),
              labelText: '********',
              fillColor: Colors.white70,
            ),
            onChanged: (value) {
              name = value;
            },
            maxLines: 1,
            readOnly: true,
            enabled: false,
          ),
        ),

        const SizedBox(
          height: 20,
        ),
        // ignore: sized_box_for_whitespace
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, ForgetPass.ScreenRoute);
          },
          child: const Text(
            'تغيير كلمة المرور',
            style: TextStyle(
                fontFamily: 'Lalezar', fontSize: 25, color: Colors.blue),
          ),
        ),

        const SizedBox(
          height: 40,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5, right: 10),
                  child: RawMaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),

                    onPressed: () {
                      editInf();
                    },
                    elevation: 10,
                    fillColor: Color.fromRGBO(7, 205, 219, 1),
                    // ignore: sort_child_properties_last
                    child: const Text(
                      'حفظ التغييرات',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20,
                        fontFamily: 'Lalezar',
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 5),
                  child: RawMaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),

                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(10),
                            titlePadding: const EdgeInsets.all(10),
                            buttonPadding: const EdgeInsets.all(10),
                            title: const Center(
                              child: Text(
                                'هل أنت متأكد من أنك تريد حذف الحساب ؟',
                                style: TextStyle(
                                    fontFamily: 'Lalezar',
                                    fontSize: 30,
                                    color: Colors.red),
                              ),
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'لا',
                                      style: TextStyle(
                                          fontFamily: 'Lalezar', fontSize: 25),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      try {
                                        _auth.currentUser?.delete();
                                        Navigator.pushReplacementNamed(
                                            context, FirstPage.ScreenRoute);
                                      } catch (e) {
                                        print(e.toString());
                                      }
                                    },
                                    child: const Text(
                                      'نعم',
                                      style: TextStyle(
                                          fontFamily: 'Lalezar', fontSize: 30),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    elevation: 10,
                    fillColor: Colors.red,
                    // ignore: sort_child_properties_last
                    child: const Text(
                      'حذف الحساب',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 20,
                        fontFamily: 'Lalezar',
                      ),
                    ),
                    padding: const EdgeInsets.all(10.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
