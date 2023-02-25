import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:little_reader/services/database.dart';
import 'package:little_reader/views/registeration/inf_entry/accounts.dart';
import 'package:little_reader/views/registeration/inf_entry/child_statistics.dart';
import 'package:little_reader/views/registeration/inf_entry/first_page.dart';
import '../user_inf.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class AddChild extends StatefulWidget {
  // ignore: constant_identifier_names
  static const String ScreenRoute = 'add_child';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;

  const AddChild({
    Key? key,
    this.childID,
    this.currentAvatar,
    this.currentName,
  }) : super(key: key);

  @override
  State<AddChild> createState() => _AddChildState();
}

//where we are going to call child's variable from ListChild class
class _AddChildState extends State<AddChild> {
  final formKey = GlobalKey<FormState>(); //to handle any states of widget
  final ageList = [3, 4, 5, 6, 7, 8, 9, 10];
  final relationList = [
    'الأب',
    'الأم',
    'الأخ',
    'أخت',
    'العم',
    'العمة',
    'الخال',
    'الخالة'
  ];

  //Editable text variable
  TextEditingController child_name = TextEditingController();

  var selectedAge;

  var selectedRelation;

  String? selectedAvatar;

  int _correctLetters = 0;
  int _wrongLetters = 0;

  int _correctWords = 0;
  int _wrongWords = 0;

  int _correctStoryWords = 0;
  int _wrongStoryWords = 0;

  int level1 = 0;
  int level2 = 0;
  int level3 = 0;

  var index;
  int correctWords = 0;
  int wrongWords = 0;

  addnewChild() async {
    // Object of DatabaseServices class
    DatabaseServices db = DatabaseServices();

    //calling this method from the DatabaseServices class and pass the parameters
    db.setChildInformationData(
        child_name.text, selectedAge, selectedRelation, selectedAvatar);

    _firestore
        .collection('Statistics')
        .doc("${_auth.currentUser!.email}")
        .collection('children')
        .doc(child_name.text)
        .collection('letters')
        .doc('letters')
        .set({
      "correct_letters": _correctLetters,
      "wrong_letters": _wrongLetters,
    });
    _firestore
        .collection('Statistics')
        .doc("${_auth.currentUser!.email}")
        .collection('children')
        .doc(child_name.text)
        .collection('words')
        .doc('words')
        .set({
      "correct_words": _correctWords,
      "wrong_words": _wrongWords,
    });
    _firestore
        .collection('Statistics')
        .doc("${_auth.currentUser!.email}")
        .collection('children')
        .doc(child_name.text)
        .collection('words_of_story')
        .doc('words_of_story')
        .set({
      "correct_WordsStory": _correctStoryWords,
      "wrong_WordsStory": _wrongStoryWords,
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentwidth = MediaQuery.of(context).size.width;
    WidgetsFlutterBinding.ensureInitialized();

    //these lines of code to make the screen in vertical state.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return SafeArea(
      child: Directionality(
        //Direction right to left.
        textDirection: TextDirection.rtl,
        child: Scaffold(
          //holds the buttons in their place to avoid any overflow error.
          resizeToAvoidBottomInset: false,

          //appBar is the top bar of the screen
          appBar: AppBar(
            actions: [
              IconButton(
                icon: Icon(
                  Icons.settings,
                  size: currentHeight / 18,
                ),
                onPressed: () {
                  //push to UserInformationPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserInformationPage(),
                    ),
                  );
                },
                color: Colors.grey[500],
                iconSize: currentHeight / 24,
              ),
            ],
            leading: IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.red,
                size: currentHeight / 20,
              ),
              onPressed: () {
                //when press on log-out button; Show dialog that asks the user Yes or No ?.
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      contentPadding: const EdgeInsets.all(10),
                      titlePadding: const EdgeInsets.all(10),
                      buttonPadding: const EdgeInsets.all(10),
                      title: Center(
                        child: Text(
                          'هل أنت متأكد من أنك تريد تسجيل الخروج ؟',
                          style: TextStyle(
                              fontFamily: 'Lalezar',
                              fontSize: currentHeight / 28,
                              color: Colors.red),
                        ),
                      ),
                      actions: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              //if No?  close the dialog.
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'لا',
                                style: TextStyle(
                                    fontFamily: 'Lalezar',
                                    fontSize: currentHeight / 32),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            InkWell(
                              onTap: () {
                                //if Yes? call signOut() from firebase and return back to the first screen.
                                _auth.signOut();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const FirstPage()),
                                    (Route<dynamic> route) => false);
                              },
                              child: Text(
                                'نعم',
                                style: TextStyle(
                                    fontFamily: 'Lalezar',
                                    fontSize: currentHeight / 32),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );

                //////////////
              },
            ),
            backgroundColor: const Color.fromARGB(255, 249, 249, 249),
            elevation: 0,
          ),

          //body of screen
          body: FutureBuilder<QuerySnapshot>(
            future: _firestore
                .collection('parents')
                .doc(_auth.currentUser!.email)
                .collection('children')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'لا يوجد أطفال مسجلين',
                    style: TextStyle(
                        fontSize: currentHeight / 22,
                        fontFamily: 'Lalezar',
                        color: Colors.grey[400]),
                  ),
                );
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, i) {
                    final name = snapshot.data!.docs[i].get('name');
                    final avatar = snapshot.data!.docs[i].get('avatar_url');
                    final id = snapshot.data!.docs[i].get('childID');
                    final relation = snapshot.data!.docs[i].get('relation');
                    final age = snapshot.data!.docs[i].get('age');

                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => childStatistics(
                                    name_st: name,
                                    avatar_url_st: avatar,
                                    id_st: id),
                              ),
                            );
                          },
                          child: Stack(
                            key: UniqueKey(),
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              ChildrenList(
                                childName: name,
                                avatarURL: avatar,
                                childID: id,
                                relation: relation,
                                age: age,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(25.0),
                                child: Column(
                                  children: [
                                    MaterialButton(
                                      color: Colors.grey[300],
                                      onPressed: () {
                                        showModalBottomSheet(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          context: context,
                                          builder: ((context) {
                                            return StatefulBuilder(
                                              builder: (BuildContext context,
                                                  void Function(void Function())
                                                      setState) {
                                                return Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(
                                                                  () {
                                                                    index = 0;
                                                                    selectedAvatar =
                                                                        'https://pbs.twimg.com/media/FgAHvO4XwAA53r1?format=jpg&name=medium';
                                                                  },
                                                                );
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  color: index == 0
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                                child:
                                                                    const CircleAvatar(
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          'https://pbs.twimg.com/media/FgAHvO4XwAA53r1?format=jpg&name=medium'),
                                                                  backgroundColor:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          178,
                                                                          71),
                                                                  radius: 35,
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(
                                                                  () {
                                                                    index = 1;
                                                                    selectedAvatar =
                                                                        'https://pbs.twimg.com/media/FgAIYSjWYAEXbCi?format=jpg&name=medium';
                                                                  },
                                                                );
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  color: index == 1
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                                child:
                                                                    const CircleAvatar(
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          'https://pbs.twimg.com/media/FgAIYSjWYAEXbCi?format=jpg&name=medium'),
                                                                  backgroundColor:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          178,
                                                                          71),
                                                                  radius: 35,
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(
                                                                  () {
                                                                    index = 2;
                                                                    selectedAvatar =
                                                                        'https://pbs.twimg.com/media/FgAGfWFWQAMuUY8?format=jpg&name=medium';
                                                                  },
                                                                );
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  color: index == 2
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                                child:
                                                                    const CircleAvatar(
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          'https://pbs.twimg.com/media/FgAGfWFWQAMuUY8?format=jpg&name=medium'),
                                                                  backgroundColor:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          178,
                                                                          71),
                                                                  radius: 35,
                                                                ),
                                                              ),
                                                            ),
                                                            GestureDetector(
                                                              onTap: () {
                                                                setState(
                                                                  () {
                                                                    index = 3;
                                                                    selectedAvatar =
                                                                        'https://pbs.twimg.com/media/FgAIbPqWAAI6vwp?format=jpg&name=medium';
                                                                  },
                                                                );
                                                              },
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  color: index == 3
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                                child:
                                                                    const CircleAvatar(
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          'https://pbs.twimg.com/media/FgAIbPqWAAI6vwp?format=jpg&name=medium'),
                                                                  backgroundColor:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          255,
                                                                          178,
                                                                          71),
                                                                  radius: 35,
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'اسم الطفل: ',
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontFamily:
                                                                      'Lalezar'),
                                                            ),
                                                            Form(
                                                              child: Expanded(
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      child_name,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    enabledBorder:
                                                                        const OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            201,
                                                                            201,
                                                                            201),
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            10),
                                                                      ),
                                                                    ),
                                                                    focusedBorder:
                                                                        const OutlineInputBorder(
                                                                      borderSide:
                                                                          BorderSide(
                                                                        color: Color.fromRGBO(
                                                                            255,
                                                                            166,
                                                                            0,
                                                                            1),
                                                                      ),
                                                                    ),
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    filled:
                                                                        true,
                                                                    labelStyle: TextStyle(
                                                                        color: Colors.grey[
                                                                            400],
                                                                        fontFamily:
                                                                            'Lalezar'),
                                                                    labelText:
                                                                        "أدخل اسم الطفل",
                                                                    fillColor:
                                                                        Colors
                                                                            .white70,
                                                                  ),
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .emailAddress,
                                                                  maxLines: 1,
                                                                  onSaved:
                                                                      (value) {
                                                                    value =
                                                                        child_name
                                                                            .text;
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'العمر: ',
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontFamily:
                                                                      'Lalezar'),
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  DropdownButtonFormField(
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                  ),
                                                                ),
                                                                elevation: 30,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                hint: Text(
                                                                  'اختر عمر الطفل',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Lalezar',
                                                                    color: Colors
                                                                            .grey[
                                                                        400],
                                                                  ),
                                                                ),
                                                                items: ageList
                                                                    .map(
                                                                      (e) =>
                                                                          DropdownMenuItem(
                                                                        value:
                                                                            e,
                                                                        child:
                                                                            Text(
                                                                          '$e',
                                                                          style: const TextStyle(
                                                                              fontFamily: 'Lalezar',
                                                                              fontSize: 20),
                                                                        ),
                                                                      ),
                                                                    )
                                                                    .toList(),
                                                                onChanged:
                                                                    (val) {
                                                                  setState(
                                                                    () {
                                                                      selectedAge =
                                                                          val;
                                                                    },
                                                                  );
                                                                },
                                                                value:
                                                                    selectedAge,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            const Text(
                                                              'العلاقة: ',
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontFamily:
                                                                      'Lalezar'),
                                                            ),
                                                            Expanded(
                                                              child:
                                                                  DropdownButtonFormField(
                                                                decoration:
                                                                    InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                  ),
                                                                ),
                                                                elevation: 30,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                hint: Text(
                                                                  'اختر علاقتك بطفلك',
                                                                  style:
                                                                      TextStyle(
                                                                    fontFamily:
                                                                        'Lalezar',
                                                                    color: Colors
                                                                            .grey[
                                                                        400],
                                                                  ),
                                                                ),
                                                                items:
                                                                    relationList
                                                                        .map(
                                                                          (e) =>
                                                                              DropdownMenuItem(
                                                                            value:
                                                                                e,
                                                                            child:
                                                                                Text(
                                                                              '$e',
                                                                              style: const TextStyle(fontFamily: 'Lalezar', fontSize: 20),
                                                                            ),
                                                                          ),
                                                                        )
                                                                        .toList(),
                                                                onChanged:
                                                                    (val) {
                                                                  setState(
                                                                    () {
                                                                      selectedRelation =
                                                                          val;
                                                                    },
                                                                  );
                                                                },
                                                                value:
                                                                    selectedRelation,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        RawMaterialButton(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30),
                                                          ),

                                                          onPressed: () async {
                                                            FirebaseFirestore
                                                                db =
                                                                FirebaseFirestore
                                                                    .instance;
                                                            try {
                                                              final update =
                                                                  db.collection(
                                                                      'parents');

                                                              final update2 =
                                                                  update.doc(_auth
                                                                      .currentUser!
                                                                      .email);

                                                              final update3 =
                                                                  update2.collection(
                                                                      'children');

                                                              final update4 =
                                                                  update3.doc(
                                                                      snapshot
                                                                          .data!
                                                                          .docs[
                                                                              i]
                                                                          .id);

                                                              await update4
                                                                  .update({
                                                                "name":
                                                                    child_name
                                                                        .text,
                                                                "age":
                                                                    selectedAge,
                                                                "relation":
                                                                    selectedRelation,
                                                                "avatar_url":
                                                                    selectedAvatar
                                                              });
                                                            } catch (e) {
                                                              print(
                                                                  e.toString());
                                                            }

                                                            // ignore: use_build_context_synchronously
                                                            Navigator.pop(
                                                                context);

                                                            // ignore: use_build_context_synchronously
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                action:
                                                                    SnackBarAction(
                                                                  label: 'حسنا',
                                                                  onPressed:
                                                                      () {},
                                                                ),
                                                                content:
                                                                    const Text(
                                                                  'تم تحديث الحساب بنجاح',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Lalezar'),
                                                                ),
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            5),
                                                                width: double
                                                                    .infinity, // Width of the SnackBar.
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      15.0, // Inner padding for SnackBar content.
                                                                ),

                                                                behavior:
                                                                    SnackBarBehavior
                                                                        .floating,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.0),
                                                                ),
                                                              ),
                                                            );
                                                          },

                                                          elevation: 10,
                                                          fillColor: const Color
                                                                  .fromRGBO(
                                                              7, 205, 219, 1),
                                                          // ignore: sort_child_properties_last
                                                          child: const Text(
                                                            'حفظ',
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255),
                                                              fontSize: 30,
                                                              fontFamily:
                                                                  'Lalezar',
                                                            ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10.0),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }),
                                        );
                                      },
                                      child: const Text(
                                        'تعديل',
                                        style: TextStyle(
                                          fontFamily: 'Lalezar',
                                        ),
                                      ),
                                    ),
                                    Container(
                                      child: MaterialButton(
                                        color: Colors.red,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                contentPadding:
                                                    const EdgeInsets.all(10),
                                                titlePadding:
                                                    const EdgeInsets.all(10),
                                                buttonPadding:
                                                    const EdgeInsets.all(10),
                                                title: const Center(
                                                  child: Text(
                                                    'هل أنت متأكد من أنك تريد حذف الحساب ؟',
                                                    style: TextStyle(
                                                        fontFamily: 'Lalezar',
                                                        fontSize: 20,
                                                        color: Colors.red),
                                                  ),
                                                ),
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          'لا',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Lalezar',
                                                              fontSize: 30),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 30,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          try {
                                                            _firestore
                                                                .collection(
                                                                    'parents')
                                                                .doc(_auth
                                                                    .currentUser!
                                                                    .email)
                                                                .collection(
                                                                    'children')
                                                                .doc(snapshot
                                                                    .data!
                                                                    .docs[i]
                                                                    .id)
                                                                .delete();
                                                          } catch (e) {
                                                            print(e.toString());
                                                          }

                                                          setState(() {});

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text(
                                                          'نعم',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'Lalezar',
                                                              fontSize: 30),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Text(
                                          'حذف',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Lalezar',
                                              fontSize: 23),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),

          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    isDismissible: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    context: context,
                    builder: ((context) {
                      //statefulBuilder to update any changes immediately.
                      return StatefulBuilder(
                        builder: (BuildContext context,
                            void Function(void Function()) setState) {
                          return Directionality(
                            textDirection: TextDirection.rtl,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                //spaces between widgets.
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            //first avatar
                                            index = 0;
                                            selectedAvatar =
                                                'https://pbs.twimg.com/media/FgAHvO4XwAA53r1?format=jpg&name=medium';
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),

                                            //if user selects to index 0 ? then change the color to red, else keep it white.
                                            color: index == 0
                                                ? Colors.red
                                                : Colors.white,
                                          ),
                                          child: const CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                'https://pbs.twimg.com/media/FgAHvO4XwAA53r1?format=jpg&name=medium'),
                                            backgroundColor: Color.fromARGB(
                                                255, 255, 178, 71),
                                            radius: 35,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            //second avatar.
                                            index = 1;
                                            selectedAvatar =
                                                'https://pbs.twimg.com/media/FgAIYSjWYAEXbCi?format=jpg&name=medium';
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),

                                            //if user selects to index 1 ? then change the color to red, else keep it white.
                                            color: index == 1
                                                ? Colors.red
                                                : Colors.white,
                                          ),
                                          child: const CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                'https://pbs.twimg.com/media/FgAIYSjWYAEXbCi?format=jpg&name=medium'),
                                            backgroundColor: Color.fromARGB(
                                                255, 255, 178, 71),
                                            radius: 35,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            //third avatar.
                                            index = 2;
                                            selectedAvatar =
                                                'https://pbs.twimg.com/media/FgAGfWFWQAMuUY8?format=jpg&name=medium';
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),

                                            //if user selects to index 2 ? then change the color to red, else keep it white.
                                            color: index == 2
                                                ? Colors.red
                                                : Colors.white,
                                          ),
                                          child: const CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                'https://pbs.twimg.com/media/FgAGfWFWQAMuUY8?format=jpg&name=medium'),
                                            backgroundColor: Color.fromARGB(
                                                255, 255, 178, 71),
                                            radius: 35,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          //fourth avatar.
                                          setState(() {
                                            index = 3;
                                            selectedAvatar =
                                                'https://pbs.twimg.com/media/FgAIbPqWAAI6vwp?format=jpg&name=medium';
                                          });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            //if user selects to index 3 ? then change the color to red, else keep it white.

                                            color: index == 3
                                                ? Colors.red
                                                : Colors.white,
                                          ),
                                          child: const CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                'https://pbs.twimg.com/media/FgAIbPqWAAI6vwp?format=jpg&name=medium'),
                                            backgroundColor: Color.fromARGB(
                                                255, 255, 178, 71),
                                            radius: 35,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'اسم الطفل: ',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontFamily: 'Lalezar'),
                                      ),

                                      //Name Text form Field
                                      Form(
                                        key: formKey,
                                        child: Expanded(
                                          child: TextFormField(
                                            controller: child_name,
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
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              filled: true,
                                              labelStyle: TextStyle(
                                                  color: Colors.grey[400],
                                                  fontFamily: 'Lalezar'),
                                              labelText: ":أدخل اسم الطفل",
                                              fillColor: Colors.white70,
                                            ),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            maxLines: 1,
                                            onChanged: (value) {
                                              value = child_name.text;
                                            },
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'الرجاء أدخل اسم الطفل';
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'العمر: ',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontFamily: 'Lalezar'),
                                        maxLines: 1,
                                      ),
                                      Expanded(
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          elevation: 30,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          hint: Text('اختر عمر الطفل',
                                              style: TextStyle(
                                                fontFamily: 'Lalezar',
                                                color: Colors.grey[400],
                                              ),
                                              maxLines: 1),
                                          items: ageList
                                              .map(
                                                (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(
                                                    '$e',
                                                    style: const TextStyle(
                                                        fontFamily: 'Lalezar',
                                                        fontSize: 20),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (val) {
                                            setState(
                                              () {
                                                selectedAge = val;
                                              },
                                            );
                                          },
                                          value: selectedAge,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'العلاقة: ',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontFamily: 'Lalezar'),
                                        maxLines: 1,
                                      ),
                                      Expanded(
                                        child: DropdownButtonFormField(
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                          ),
                                          elevation: 30,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          hint: Text(
                                            'اختر علاقتك بطفلك',
                                            style: TextStyle(
                                              fontFamily: 'Lalezar',
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                          items: relationList
                                              .map(
                                                (e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text('$e',
                                                      style: const TextStyle(
                                                          fontFamily: 'Lalezar',
                                                          fontSize: 20),
                                                      maxLines: 1),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (val) {
                                            setState(
                                              () {
                                                selectedRelation = val;
                                              },
                                            );
                                          },
                                          value: selectedRelation,
                                        ),
                                      ),
                                    ],
                                  ),
                                  RawMaterialButton(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),

                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        addnewChild();
                                        Navigator.pop(
                                          context,
                                        );
                                      } else {
                                        AwesomeDialog(
                                          context: context,
                                          title: '',
                                          body: const Text(
                                            'الرجاء أكمل البيانات',
                                            style: TextStyle(
                                                fontFamily: 'Lalezar',
                                                fontSize: 25),
                                          ),
                                        ).show();
                                      }
                                    },

                                    elevation: 10,
                                    fillColor:
                                        const Color.fromRGBO(7, 205, 219, 1),
                                    // ignore: sort_child_properties_last
                                    child: const Text(
                                      'حفظ',
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        fontSize: 30,
                                        fontFamily: 'Lalezar',
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(10.0),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  );
                },
                backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                elevation: 10,
                child: Icon(
                  Icons.add,
                  size: currentHeight / 22,
                ),
              ),
              RawMaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),

                onPressed: () {
                  //pushes to Accounts page.
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Accounts(),
                    ),
                  );
                  //}
                },
                elevation: 10,
                fillColor: const Color.fromRGBO(7, 205, 219, 1),
                // ignore: sort_child_properties_last
                child: Text(
                  'ابدأ اللعب',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: currentwidth / 11,
                    fontFamily: 'Lalezar',
                  ),
                  maxLines: 1,
                ),
                padding: const EdgeInsets.all(10.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//where we are going to initialize child's variable and pass it
class ChildrenList extends StatelessWidget {
  final String? childName;
  final String? relation;
  final String? avatarURL;
  final int? age;
  String? childID;

  ///////////////////////////////////////////////
  ///
  ///
  ChildrenList(
      {Key? key,
      required this.childName,
      this.childID,
      this.avatarURL,
      required this.relation,
      required this.age})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 10,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    '$avatarURL',
                    height: 100,
                    width: 80,
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          '${childName!}: ',
                          style: const TextStyle(
                              fontSize: 25, fontFamily: 'Lalezar'),
                          maxLines: 1,
                        ),
                        Text(
                          '${age!} سنوات',
                          style: const TextStyle(
                              fontSize: 20, fontFamily: 'Lalezar'),
                          maxLines: 1,
                        ),
                      ],
                    ),
                    subtitle: Text(
                      'علاقتك مع الطفل: $relation',
                      style: const TextStyle(fontFamily: 'Lalezar'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
