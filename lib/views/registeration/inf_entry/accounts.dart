import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:little_reader/views/home/home.dart';
import 'package:little_reader/views/registeration/inf_entry/add_child.dart';
import 'package:little_reader/views/registeration/inf_entry/first_page.dart';

final _auth = FirebaseAuth.instance;
String? email = _auth.currentUser!.email;

class Accounts extends StatefulWidget {
  Accounts({Key? key}) : super(key: key);

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  final _firestore = FirebaseFirestore.instance;

  getCurrentUser() {
    var user = _auth.currentUser;
    print(user!.email);
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentwidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const FirstPage()),
                  (Route<dynamic> route) => false);
            },
            iconSize: currentHeight / 16,
          ),
        ],
        toolbarHeight: currentHeight / 8,
        leading: Column(
          children: [
            IconButton(
              icon: const Icon(
                Icons.account_circle_sharp,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, AddChild.ScreenRoute);
              },
              iconSize: currentHeight / 14,
            ),
          ],
        ),
        leadingWidth: 100,
        backgroundColor: Color.fromRGBO(7, 205, 219, 1),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('parents')
                  .doc('${_auth.currentUser!.email}')
                  .collection('children')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                List<ChildInf> childInfList = [];
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator(); //If no data return this
                }
                final information = snapshot.data!
                    .docs; //information: stores gets the data from firebase documents

                for (var item in information) {
                  final getChildAvatar =
                      item.data().toString().contains('avatar_url')
                          ? item.get('avatar_url')
                          : 'No url Found';
                  final getChildName = item.data().toString().contains('name')
                      ? item.get('name')
                      : 0;

                  final getChildId = item.data().toString().contains('childID')
                      ? item.get('childID')
                      : 0;

                  final addToList = ChildInf(
                    child_avatarUrl: getChildAvatar,
                    name: getChildName,
                    childID: getChildId,
                  );

                  childInfList.add(addToList);
                }
                return Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: childInfList),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChildInf extends StatelessWidget {
  late String child_avatarUrl;
  late String name;
  final String? childID;

  ChildInf({
    Key? key,
    required this.child_avatarUrl,
    required this.name,
    this.childID,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;

    WidgetsFlutterBinding.ensureInitialized();

    //these lines of code to make the screen in horizontal state
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Home(
                    childID: childID!,
                    currentAvatar: child_avatarUrl,
                    currentName: name),
              ),
            );
          },
          splashColor: Colors.orange,
          child: Ink.image(
            image: NetworkImage(child_avatarUrl),
            height: currentHeight / 3,
            width: currentWidth / 4,
          ),
        ),
        Text(
          name,
          style: TextStyle(fontFamily: 'Lalezar', fontSize: currentWidth / 22),
        ),
      ],
    );
  }
}
