import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class childStatistics extends StatelessWidget {
  final String? avatar_url_st;
  final String? name_st;
  final String? id_st;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  childStatistics({Key? key, this.name_st, this.avatar_url_st, this.id_st})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentwidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                maxRadius: currentHeight / 12,
                minRadius: currentwidth / 12,
                child: Image.network(
                  '$avatar_url_st',
                ),
              ),
              Text(
                '$name_st',
                style: TextStyle(
                    fontFamily: 'Lalezar', fontSize: currentHeight / 22),
              ),
              const Divider(
                thickness: 3,
              ),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 50, right: 50, bottom: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(228, 0, 250, 1),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'الحروف',
                          style: TextStyle(
                              fontSize: currentHeight / 28,
                              fontFamily: 'Lalezar',
                              color: Colors.yellow),
                        ),
                        SizedBox(height: currentHeight / 55),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: _firestore
                                  .collection('Statistics')
                                  .doc(_auth.currentUser!.email)
                                  .collection('children')
                                  .doc(name_st)
                                  .collection('letters')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                List<LettersSt> letters_List =
                                    []; //List to Store letters

                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator(); //If no data return this
                                }

                                final information = snapshot.data!
                                    .docs; //information: stores gets the data from firebase documents

                                for (var item in information) {
                                  final getCL = item
                                          .data()
                                          .toString()
                                          .contains('correct_letters')
                                      ? item.get('correct_letters')
                                      : 0;
                                  final getWL = item
                                          .data()
                                          .toString()
                                          .contains('wrong_letters')
                                      ? item.get('wrong_letters')
                                      : 0;

                                  final addToList = LettersSt(
                                    cL: getCL,
                                    wL: getWL,
                                  );

                                  letters_List.add(addToList);
                                }
                                return Row(
                                  children: letters_List,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 50, right: 50, bottom: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(109, 8, 250, 1),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'الكلمات',
                          style: TextStyle(
                              fontSize: currentHeight / 28,
                              fontFamily: 'Lalezar',
                              color: Colors.yellow),
                        ),
                        SizedBox(height: currentHeight / 55),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: _firestore
                                  .collection('Statistics')
                                  .doc(_auth.currentUser!.email)
                                  .collection('children')
                                  .doc(name_st)
                                  .collection('words')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                List<WordsSt> words_List =
                                    []; //List to store words

                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator(); //If no data return this
                                }

                                final information = snapshot.data!
                                    .docs; //information: stores gets the data from firebase documents

                                for (var item in information) {
                                  final getCW = item
                                          .data()
                                          .toString()
                                          .contains('correct_words')
                                      ? item.get('correct_words')
                                      : 0;
                                  final getWW = item
                                          .data()
                                          .toString()
                                          .contains('wrong_words')
                                      ? item.get('wrong_words')
                                      : 0;

                                  final addToList = WordsSt(
                                    cW: getCW,
                                    wW: getWW,
                                  );

                                  words_List.add(addToList);
                                }
                                return Row(
                                  children: words_List,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 50, right: 50, bottom: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color.fromRGBO(9, 136, 173, 1),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'القصص',
                          style: TextStyle(
                              fontSize: currentHeight / 28,
                              fontFamily: 'Lalezar',
                              color: Colors.yellow),
                        ),
                        SizedBox(height: currentHeight / 55),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder<QuerySnapshot>(
                              stream: _firestore
                                  .collection('Statistics')
                                  .doc(_auth.currentUser!.email)
                                  .collection('children')
                                  .doc(name_st)
                                  .collection('words_of_story')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                List<StoriesSt> stories_List =
                                    []; //List to store words

                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator(); //If no data return this
                                }

                                final information = snapshot.data!
                                    .docs; //information: stores gets the data from firebase documents

                                for (var item in information) {
                                  final getCS = item
                                          .data()
                                          .toString()
                                          .contains('correct_WordsStory')
                                      ? item.get('correct_WordsStory')
                                      : 0;
                                  final getWS = item
                                          .data()
                                          .toString()
                                          .contains('wrong_WordsStory')
                                      ? item.get('wrong_WordsStory')
                                      : 0;

                                  final addToList = StoriesSt(
                                    cS: getCS,
                                    wS: getWS,
                                  );

                                  stories_List.add(addToList);
                                }
                                return Row(
                                  children: stories_List,
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LettersSt extends StatelessWidget {
  int cL;
  int wL;
  LettersSt({super.key, required this.cL, required this.wL});

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentwidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: [
            Text(
              '$cL',
              style: TextStyle(
                  fontSize: currentHeight / 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'حرف قرئ بشكل صحيح ',
              style: TextStyle(
                  fontSize: currentHeight / 38,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '$wL',
              style: TextStyle(
                  fontSize: currentHeight / 38,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'حرف قرئ بشكل خاطئ ',
              style: TextStyle(
                  fontSize: currentHeight / 38,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}

class WordsSt extends StatelessWidget {
  int cW;
  int wW;
  WordsSt({super.key, required this.cW, required this.wW});

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentwidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: [
            Text(
              '$cW',
              style: TextStyle(
                  fontSize: currentHeight / 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'كلمة قرئت بشكل صحيح ',
              style: TextStyle(
                  fontSize: currentHeight / 38,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '$wW',
              style: TextStyle(
                  fontSize: currentHeight / 38,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'كلمة قرئت بشكل خاطئ ',
              style: TextStyle(
                  fontSize: currentHeight / 38,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}

class StoriesSt extends StatelessWidget {
  int cS;
  int wS;
  StoriesSt({super.key, required this.cS, required this.wS});

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentwidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: [
            Text(
              '$cS',
              style: TextStyle(
                  fontSize: currentHeight / 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'كلمة قرئت بشكل صحيح ',
              style: TextStyle(
                  fontSize: currentHeight / 38,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              '$wS',
              style: TextStyle(
                  fontSize: currentHeight / 38,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              'كلمة قرئت بشكل خاطئ ',
              style: TextStyle(
                  fontSize: currentHeight / 38,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}
