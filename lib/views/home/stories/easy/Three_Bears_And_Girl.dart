import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:little_reader/views/home/letters/letters.dart';
import 'package:little_reader/views/home/stories/counter.dart';

import '../../home.dart';

List<String> list = [];

final _auth = FirebaseAuth.instance;

Color colorGreen = Colors.green;
Color colorRed = Colors.red;
Color colorBlack = Colors.black;

const languages = [
  Language('Arabic', 'ar-Ar'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class BandG extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;

  bool? correct;
  bool? correct1;
  bool? correct2;
  bool? correct3;
  bool? correct4;
  bool? correct5;
  bool? correct6;
  bool? correct7;
  bool? correct8;
  bool? correct9;
  bool? correct10;
  bool? correct11;
  bool? correct12;
  bool? correct13;
  bool? correct14;
  bool? correct15;
  bool? correct16;
  bool? correct17;
  bool? correct18;

  bool? wrong;
  bool? wrong1;
  bool? wrong2;
  bool? wrong3;
  bool? wrong4;
  bool? wrong5;
  bool? wrong6;
  bool? wrong7;
  bool? wrong8;
  bool? wrong9;
  bool? wrong10;
  bool? wrong11;
  bool? wrong12;
  bool? wrong13;
  bool? wrong14;
  bool? wrong15;
  bool? wrong16;
  bool? wrong17;
  bool? wrong18;

  bool? isMatched;
  bool? isMatched1;
  bool? isMatched2;
  bool? isMatched3;
  bool? isMatched4;
  bool? isMatched5;
  bool? isMatched6;
  bool? isMatched7;
  bool? isMatched8;
  bool? isMatched9;
  bool? isMatched10;
  bool? isMatched11;
  bool? isMatched12;
  bool? isMatched13;
  bool? isMatched14;
  bool? isMatched15;
  bool? isMatched16;
  bool? isMatched17;
  bool? isMatched18;

  BandG(
      {Key? key,
      required this.childID,
      required this.currentAvatar,
      required this.currentName})
      : super(key: key);
  @override
  _BandGState createState() => _BandGState();
}

class _BandGState extends State<BandG> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  String _currentLocale = 'ar_Ar';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();

    // matchingWords();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_BandGState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('ar_Ar').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    //these lines of code to make the screen in horizontal state
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidht = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/stories_imgs/bears1.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.9),
                      ),
                      height: currentHeight / 2.5,
                      width: currentWidht / 1.4,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('Stories')
                            .where('ID', isEqualTo: 'Sy_Three_Bears_And_Girl')
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, i) {
                                var content =
                                    snapshot.data!.docs[i].get('Text')[0];

                                list.add(content);

                                return Content_1(
                                  text1: content.toString(),
                                  correct: widget.correct,
                                  correct1: widget.correct1,
                                  correct2: widget.correct2,
                                  correct3: widget.correct3,
                                  correct4: widget.correct4,
                                  correct5: widget.correct5,
                                  correct6: widget.correct6,
                                  correct7: widget.correct7,
                                  correct8: widget.correct8,
                                  correct9: widget.correct9,
                                  correct10: widget.correct10,
                                  correct11: widget.correct11,
                                  correct12: widget.correct12,
                                  correct13: widget.correct13,
                                  correct14: widget.correct14,
                                  correct15: widget.correct15,
                                  correct16: widget.correct16,
                                  correct17: widget.correct17,
                                  correct18: widget.correct18,
                                  wrong: widget.wrong,
                                  wrong1: widget.wrong1,
                                  wrong2: widget.wrong2,
                                  wrong3: widget.wrong3,
                                  wrong4: widget.wrong4,
                                  wrong5: widget.wrong5,
                                  wrong6: widget.wrong6,
                                  wrong7: widget.wrong7,
                                  wrong8: widget.wrong8,
                                  wrong9: widget.wrong9,
                                  wrong10: widget.wrong10,
                                  wrong11: widget.wrong11,
                                  wrong12: widget.wrong12,
                                  wrong13: widget.wrong13,
                                  wrong14: widget.wrong14,
                                  wrong15: widget.wrong15,
                                  wrong16: widget.wrong16,
                                  wrong17: widget.wrong17,
                                  wrong18: widget.wrong18,
                                  isMatched: widget.isMatched,
                                  isMatched1: widget.isMatched1,
                                  isMatched2: widget.isMatched2,
                                  isMatched3: widget.isMatched3,
                                  isMatched4: widget.isMatched4,
                                  isMatched5: widget.isMatched5,
                                  isMatched6: widget.isMatched6,
                                  isMatched7: widget.isMatched7,
                                  isMatched8: widget.isMatched8,
                                  isMatched9: widget.isMatched9,
                                  isMatched10: widget.isMatched10,
                                  isMatched11: widget.isMatched11,
                                  isMatched12: widget.isMatched12,
                                  isMatched13: widget.isMatched13,
                                  isMatched14: widget.isMatched14,
                                  isMatched15: widget.isMatched15,
                                  isMatched16: widget.isMatched16,
                                  isMatched17: widget.isMatched17,
                                  isMatched18: widget.isMatched18,
                                );
                              },
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BandG2(
                              childID: widget.childID,
                              currentAvatar: widget.currentAvatar,
                              currentName: widget.currentName,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 28,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 28,
                        ),
                      ),
                    ),
                    GestureDetector(
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 28,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 28,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: currentHeight / 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (_speechRecognitionAvailable && !_isListening) {
                          start();
                        }
                        null;
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 16,
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_off,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false);
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 16,
                        child: Icon(
                          Icons.home,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            print('tapped');
                            // if (play == true) {
                            //   play = false;
                            // } else {
                            //   if (play == false) {
                            //     play = true;
                            //   }
                            // }
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: currentHeight / 16,
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        child: Icon(
                          Icons.volume_up,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Statistics')
                      .doc(_auth.currentUser!.email)
                      .collection('children')
                      .doc(widget.currentName)
                      .collection('words_of_story ')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator(); //If no data return this
                    }

                    final information = snapshot.data!
                        .docs; //information: stores gets the data from firebase documents

                    for (var item in information) {
                      final getCS =
                          item.data().toString().contains('correct_WordsStory')
                              ? item.get('correct_WordsStory')
                              : 0;
                      final getWS =
                          item.data().toString().contains('wrong_WordsStory')
                              ? item.get('wrong_WordsStory')
                              : 0;

                      Counter.correctStoryCounter = getCS;
                      Counter.wrongStoryCounter = getWS;
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_BandGState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_BandGState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_BandGState.onRecognitionResult... $text');
    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    dynamic my_words = text.toString().split(" ");

    if (my_words[0] == 'استيقظت') {
      widget.isMatched = true;
      widget.correct = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[0] != 'استيقظت') {
      widget.isMatched = false;
      widget.wrong = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }

    if (my_words[1] == 'الدب') {
      widget.isMatched1 = true;
      widget.correct1 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[1] != 'الدب') {
      widget.isMatched1 = false;
      widget.wrong1 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[2] == 'الام') {
      widget.isMatched2 = true;
      widget.correct2 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[2] != 'الام') {
      widget.isMatched2 = false;
      widget.wrong2 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[3] == 'مبكرا') {
      widget.isMatched3 = true;
      widget.correct3 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[3] != 'مبكرا') {
      widget.isMatched3 = false;
      widget.wrong3 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[4] == 'واعدت' || my_words[4] == 'وعده') {
      widget.isMatched4 = true;
      widget.correct4 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[4] != 'واعدت' && my_words[4] != 'وعده') {
      widget.isMatched4 = false;
      widget.wrong4 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[5] == 'الطعام') {
      widget.isMatched5 = true;
      widget.correct5 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[5] != 'الطعام') {
      widget.isMatched5 = false;
      widget.wrong5 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[6] == 'ثم') {
      widget.isMatched6 = true;
      widget.correct6 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[6] != 'ثم') {
      widget.isMatched6 = false;
      widget.wrong6 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[7] == 'وضعته') {
      widget.isMatched7 = true;
      widget.correct7 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[7] != 'وضعته') {
      widget.isMatched7 = false;
      widget.wrong7 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[8] == 'في') {
      widget.isMatched8 = true;
      widget.correct8 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[8] != 'في') {
      widget.isMatched8 = false;
      widget.wrong8 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[9] == 'ثلاثه') {
      widget.isMatched9 = true;
      widget.correct9 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[9] != 'ثلاثه') {
      widget.isMatched9 = false;
      widget.wrong9 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[10] == 'اطباق') {
      widget.isMatched10 = true;
      widget.correct10 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[10] != 'اطباق') {
      widget.isMatched10 = false;
      widget.wrong10 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[11] == 'طبق') {
      widget.isMatched11 = true;
      widget.correct11 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[11] != 'طبق') {
      widget.isMatched11 = false;
      widget.wrong11 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[12] == 'لها') {
      widget.isMatched12 = true;
      widget.correct12 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[12] != 'لها') {
      widget.isMatched12 = false;
      widget.wrong12 = true;
      Counter.wrongStoryCounter++;
    }
    if (my_words[13] == 'وطبق') {
      widget.isMatched13 = true;
      widget.correct13 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[13] != 'وطبق') {
      widget.isMatched13 = false;
      widget.wrong13 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[14] == 'لزوجها') {
      widget.isMatched14 = true;
      widget.correct14 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[14] != 'لزوجها') {
      widget.isMatched14 = false;
      widget.wrong14 = true;
      Counter.wrongStoryCounter++;
    }
    if (my_words[15] == 'الدب') {
      widget.isMatched15 = true;
      widget.correct15 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[15] != 'الدب') {
      widget.isMatched15 = false;
      widget.wrong15 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[16] == 'وطبق') {
      widget.isMatched16 = true;
      widget.correct16 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[16] != 'وطبق') {
      widget.isMatched16 = false;
      widget.wrong16 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[17] == 'لابنها') {
      widget.isMatched17 = true;
      widget.correct17 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[17] != 'لابنها') {
      widget.isMatched17 = false;
      widget.wrong17 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[18] == 'الدب') {
      widget.isMatched18 = true;
      widget.correct18 = true;

      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
      _Next();
    }
    if (my_words[18] != 'الدب') {
      widget.isMatched18 = false;
      widget.wrong18 = true;

      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
      _Next();
    } else {
      print('Finished');
    }
  }

  void errorHandler() => activateSpeechRecognizer();

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });

  Future _Next() => Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BandG2(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class Content_1 extends StatelessWidget {
  String text1;
  bool? correct;
  bool? correct1;
  bool? correct2;
  bool? correct3;
  bool? correct4;
  bool? correct5;
  bool? correct6;
  bool? correct7;
  bool? correct8;
  bool? correct9;
  bool? correct10;
  bool? correct11;
  bool? correct12;
  bool? correct13;
  bool? correct14;
  bool? correct15;
  bool? correct16;
  bool? correct17;
  bool? correct18;

  bool? wrong;
  bool? wrong1;
  bool? wrong2;
  bool? wrong3;
  bool? wrong4;
  bool? wrong5;
  bool? wrong6;
  bool? wrong7;
  bool? wrong8;
  bool? wrong9;
  bool? wrong10;
  bool? wrong11;
  bool? wrong12;
  bool? wrong13;
  bool? wrong14;
  bool? wrong15;
  bool? wrong16;
  bool? wrong17;
  bool? wrong18;

  bool? isMatched;
  bool? isMatched1;
  bool? isMatched2;
  bool? isMatched3;
  bool? isMatched4;
  bool? isMatched5;
  bool? isMatched6;
  bool? isMatched7;
  bool? isMatched8;
  bool? isMatched9;
  bool? isMatched10;
  bool? isMatched11;
  bool? isMatched12;
  bool? isMatched13;
  bool? isMatched14;
  bool? isMatched15;
  bool? isMatched16;
  bool? isMatched17;
  bool? isMatched18;

  Content_1({
    Key? key,
    required this.text1,
    required this.correct,
    required this.correct1,
    required this.correct2,
    required this.correct3,
    required this.correct4,
    required this.correct5,
    required this.correct6,
    required this.correct7,
    required this.correct8,
    required this.correct9,
    required this.correct10,
    required this.correct11,
    required this.correct12,
    required this.correct13,
    required this.correct14,
    required this.correct15,
    required this.correct16,
    required this.correct17,
    required this.correct18,
    required this.wrong,
    required this.wrong1,
    required this.wrong2,
    required this.wrong3,
    required this.wrong4,
    required this.wrong5,
    required this.wrong6,
    required this.wrong7,
    required this.wrong8,
    required this.wrong9,
    required this.wrong10,
    required this.wrong11,
    required this.wrong12,
    required this.wrong13,
    required this.wrong14,
    required this.wrong15,
    required this.wrong16,
    required this.wrong17,
    required this.wrong18,
    required this.isMatched,
    required this.isMatched1,
    required this.isMatched2,
    required this.isMatched3,
    required this.isMatched4,
    required this.isMatched5,
    required this.isMatched6,
    required this.isMatched7,
    required this.isMatched8,
    required this.isMatched9,
    required this.isMatched10,
    required this.isMatched11,
    required this.isMatched12,
    required this.isMatched13,
    required this.isMatched14,
    required this.isMatched15,
    required this.isMatched16,
    required this.isMatched17,
    required this.isMatched18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    var colored_text = text1.toString().split(" ");

    return Column(
      children: [
        SizedBox(
          height: currentHeight / 12,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  colored_text[0],
                  style: TextStyle(
                      color: isMatched == true
                          ? Colors.green
                          : wrong == true
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[1],
                  style: TextStyle(
                      color: isMatched1 == true
                          ? Colors.green
                          : wrong1 == true
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[2],
                  style: TextStyle(
                      color: isMatched2 == true
                          ? Colors.green
                          : wrong2 == true
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[3],
                  style: TextStyle(
                      color: isMatched3 == true
                          ? Colors.green
                          : wrong3 == true
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[4],
                  style: TextStyle(
                      color: isMatched4 == true
                          ? Colors.green
                          : wrong4 == true
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[5],
                  style: TextStyle(
                      color: isMatched5 == true
                          ? Colors.green
                          : wrong5 == true
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  colored_text[6],
                  style: TextStyle(
                      color: isMatched6 == true
                          ? Colors.green
                          : wrong6 == true
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[7],
                  style: TextStyle(
                      color: isMatched7 == true
                          ? Colors.green
                          : wrong7 == true
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[8],
                  style: TextStyle(
                      color: isMatched8 == true
                          ? Colors.green
                          : wrong8 == true
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[9],
                  style: TextStyle(
                      color: isMatched9 == true
                          ? Colors.green
                          : wrong9 == true
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[10],
                  style: TextStyle(
                      color: isMatched10 == true
                          ? Colors.green
                          : wrong10 == true
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[11],
                  style: TextStyle(
                      color: isMatched11 == true
                          ? Colors.green
                          : wrong11 == true
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[12],
                  style: TextStyle(
                      color: isMatched12 == true
                          ? Colors.green
                          : wrong12 == true
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
              ],
            ),
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                colored_text[13],
                style: TextStyle(
                    color: isMatched13 == true
                        ? Colors.green
                        : wrong13 == true
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                colored_text[14],
                style: TextStyle(
                    color: isMatched14 == true
                        ? Colors.green
                        : wrong14 == true
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                colored_text[15],
                style: TextStyle(
                    color: isMatched15 == true
                        ? Colors.green
                        : wrong15 == true
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              Text(
                colored_text[16],
                style: TextStyle(
                    color: isMatched16 == true
                        ? Colors.green
                        : wrong15 == true
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              Text(
                colored_text[17],
                style: TextStyle(
                    color: isMatched17 == true
                        ? Colors.green
                        : wrong15 == true
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              Text(
                colored_text[18],
                style: TextStyle(
                    color: isMatched15 == true
                        ? Colors.green
                        : wrong15 == true
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BandG2 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;

  bool? correct;
  bool? correct1;
  bool? correct2;
  bool? correct3;
  bool? correct4;
  bool? correct5;
  bool? correct6;
  bool? correct7;
  bool? correct8;
  bool? correct9;
  bool? correct10;
  bool? correct11;
  bool? correct12;
  bool? correct13;
  bool? correct14;
  bool? correct15;
  bool? correct16;
  bool? correct17;
  bool? correct18;
  bool? correct19;
  bool? correct20;
  bool? correct21;
  bool? correct22;

  bool? wrong;
  bool? wrong1;
  bool? wrong2;
  bool? wrong3;
  bool? wrong4;
  bool? wrong5;
  bool? wrong6;
  bool? wrong7;
  bool? wrong8;
  bool? wrong9;
  bool? wrong10;
  bool? wrong11;
  bool? wrong12;
  bool? wrong13;
  bool? wrong14;
  bool? wrong15;
  bool? wrong16;
  bool? wrong17;
  bool? wrong18;
  bool? wrong19;
  bool? wrong20;
  bool? wrong21;
  bool? wrong22;

  bool? isMatched;
  bool? isMatched1;
  bool? isMatched2;
  bool? isMatched3;
  bool? isMatched4;
  bool? isMatched5;
  bool? isMatched6;
  bool? isMatched7;
  bool? isMatched8;
  bool? isMatched9;
  bool? isMatched10;
  bool? isMatched11;
  bool? isMatched12;
  bool? isMatched13;
  bool? isMatched14;
  bool? isMatched15;
  bool? isMatched16;
  bool? isMatched17;
  bool? isMatched18;
  bool? isMatched19;
  bool? isMatched20;
  bool? isMatched21;
  bool? isMatched22;

  BandG2(
      {Key? key,
      required this.childID,
      required this.currentAvatar,
      required this.currentName})
      : super(key: key);
  @override
  _BandG2State createState() => _BandG2State();
}

class _BandG2State extends State<BandG2> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  String _currentLocale = 'ar_Ar';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();

    // matchingWords();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_BandG2State.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('ar_Ar').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    //these lines of code to make the screen in horizontal state
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidht = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/stories_imgs/bears2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.7),
                      ),
                      height: currentHeight / 2.5,
                      width: currentWidht / 1.4,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('Stories')
                            .where('ID', isEqualTo: 'Sy_Three_Bears_And_Girl')
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, i) {
                                var content =
                                    snapshot.data!.docs[i].get('Text')[1];

                                list.add(content);

                                return Content_2(
                                  text1: content.toString(),
                                  correct: widget.correct,
                                  correct1: widget.correct1,
                                  correct2: widget.correct2,
                                  correct3: widget.correct3,
                                  correct4: widget.correct4,
                                  correct5: widget.correct5,
                                  correct6: widget.correct6,
                                  correct7: widget.correct7,
                                  correct8: widget.correct8,
                                  correct9: widget.correct9,
                                  correct10: widget.correct10,
                                  correct11: widget.correct11,
                                  correct12: widget.correct12,
                                  correct13: widget.correct13,
                                  correct14: widget.correct14,
                                  correct15: widget.correct15,
                                  correct16: widget.correct16,
                                  correct17: widget.correct17,
                                  correct18: widget.correct18,
                                  correct19: widget.correct19,
                                  correct20: widget.correct20,
                                  correct21: widget.correct21,
                                  correct22: widget.correct22,
                                  wrong: widget.wrong,
                                  wrong1: widget.wrong1,
                                  wrong2: widget.wrong2,
                                  wrong3: widget.wrong3,
                                  wrong4: widget.wrong4,
                                  wrong5: widget.wrong5,
                                  wrong6: widget.wrong6,
                                  wrong7: widget.wrong7,
                                  wrong8: widget.wrong8,
                                  wrong9: widget.wrong9,
                                  wrong10: widget.wrong10,
                                  wrong11: widget.wrong11,
                                  wrong12: widget.wrong12,
                                  wrong13: widget.wrong13,
                                  wrong14: widget.wrong14,
                                  wrong15: widget.wrong15,
                                  wrong16: widget.wrong16,
                                  wrong17: widget.wrong17,
                                  wrong18: widget.wrong18,
                                  wrong19: widget.wrong19,
                                  wrong20: widget.wrong20,
                                  wrong21: widget.wrong21,
                                  wrong22: widget.wrong22,
                                  isMatched: widget.isMatched,
                                  isMatched1: widget.isMatched1,
                                  isMatched2: widget.isMatched2,
                                  isMatched3: widget.isMatched3,
                                  isMatched4: widget.isMatched4,
                                  isMatched5: widget.isMatched5,
                                  isMatched6: widget.isMatched6,
                                  isMatched7: widget.isMatched7,
                                  isMatched8: widget.isMatched8,
                                  isMatched9: widget.isMatched9,
                                  isMatched10: widget.isMatched10,
                                  isMatched11: widget.isMatched11,
                                  isMatched12: widget.isMatched12,
                                  isMatched13: widget.isMatched13,
                                  isMatched14: widget.isMatched14,
                                  isMatched15: widget.isMatched15,
                                  isMatched16: widget.isMatched16,
                                  isMatched17: widget.isMatched17,
                                  isMatched18: widget.isMatched18,
                                  isMatched19: widget.isMatched19,
                                  isMatched20: widget.isMatched20,
                                  isMatched21: widget.isMatched21,
                                  isMatched22: widget.isMatched22,
                                );
                              },
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BandG3(
                              childID: widget.childID,
                              currentAvatar: widget.currentAvatar,
                              currentName: widget.currentName,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 28,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 28,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BandG(
                              childID: widget.childID,
                              currentAvatar: widget.currentAvatar,
                              currentName: widget.currentName,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 28,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 28,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: currentHeight / 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _speechRecognitionAvailable && !_isListening
                          ? () => start()
                          : null,
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 16,
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_off,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false);
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 16,
                        child: Icon(
                          Icons.home,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            print('tapped');
                            // if (play == true) {
                            //   play = false;
                            // } else {
                            //   if (play == false) {
                            //     play = true;
                            //   }
                            // }
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: currentHeight / 16,
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        child: Icon(
                          Icons.volume_up,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Statistics')
                      .doc(_auth.currentUser!.email)
                      .collection('children')
                      .doc(widget.currentName)
                      .collection('words_of_story ')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator(); //If no data return this
                    }

                    final information = snapshot.data!
                        .docs; //information: stores gets the data from firebase documents

                    for (var item in information) {
                      final getCS =
                          item.data().toString().contains('correct_WordsStory')
                              ? item.get('correct_WordsStory')
                              : 0;
                      final getWS =
                          item.data().toString().contains('wrong_WordsStory')
                              ? item.get('wrong_WordsStory')
                              : 0;

                      Counter.correctStoryCounter = getCS;
                      Counter.wrongStoryCounter = getWS;
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_BandG2State.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_BandG2State.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_BandG2State.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    dynamic my_words = text.toString().split(" ");

    if (my_words[0] == 'دعت') {
      widget.isMatched = true;
      widget.correct = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[0] != 'دعت') {
      widget.isMatched = false;
      widget.wrong = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[1] == 'الدب') {
      widget.isMatched1 = true;
      widget.correct1 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[1] != 'الدب') {
      widget.isMatched1 = false;
      widget.wrong1 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[2] == 'الام') {
      widget.isMatched2 = true;
      widget.correct2 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[2] != 'الام') {
      widget.isMatched2 = false;
      widget.wrong2 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[3] == 'زوجها') {
      widget.isMatched3 = true;
      widget.correct3 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[3] != 'زوجها') {
      widget.isMatched3 = false;
      widget.wrong3 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[4] == 'وابنها') {
      widget.isMatched4 = true;
      widget.correct4 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[4] != 'وابنها') {
      widget.isMatched4 = false;
      widget.wrong4 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[5] == 'لتناول') {
      widget.isMatched5 = true;
      widget.correct5 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[5] != 'لتناول') {
      widget.isMatched5 = false;
      widget.wrong5 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[6] == 'الطعام') {
      widget.isMatched6 = true;
      widget.correct6 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[6] != 'الطعام') {
      widget.isMatched6 = false;
      widget.wrong6 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[7] == 'فاكل') {
      widget.isMatched7 = true;
      widget.correct7 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[7] != 'فاكل') {
      widget.isMatched7 = false;
      widget.wrong7 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[8] == 'كل') {
      widget.isMatched8 = true;
      widget.correct8 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[8] != 'كل') {
      widget.isMatched8 = false;
      widget.wrong8 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[9] == 'واحد') {
      widget.isMatched9 = true;
      widget.correct9 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[9] != 'واحد') {
      widget.isMatched9 = false;
      widget.wrong9 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[10] == 'منهم') {
      widget.isMatched10 = true;
      widget.correct10 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[10] != 'منهم') {
      widget.isMatched10 = false;
      widget.wrong10 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[11] == 'جزءا') {
      widget.isMatched11 = true;
      widget.correct11 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[11] != 'جزءا') {
      widget.isMatched11 = false;
      widget.wrong11 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[12] == 'من') {
      widget.isMatched12 = true;
      widget.correct12 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[12] != 'من') {
      widget.isMatched12 = false;
      widget.wrong12 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[13] == 'الطعام') {
      widget.isMatched13 = true;
      widget.correct13 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[13] != 'الطعام') {
      widget.isMatched13 = false;
      widget.wrong13 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[14] == 'الذي') {
      widget.isMatched14 = true;
      widget.correct14 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[14] != 'الذي') {
      widget.isMatched14 = false;
      widget.wrong14 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[15] == 'وضع') {
      widget.isMatched15 = true;
      widget.correct15 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[15] != 'وضع') {
      widget.isMatched15 = false;
      widget.wrong15 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[16] == 'في') {
      widget.isMatched16 = true;
      widget.correct16 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[16] != 'في') {
      widget.isMatched16 = false;
      widget.wrong16 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[17] == 'طبقه') {
      widget.isMatched17 = true;
      widget.correct17 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[17] != 'طبقه') {
      widget.isMatched17 = false;
      widget.wrong17 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[18] == 'ثم') {
      widget.isMatched18 = true;
      widget.correct18 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[18] != 'ثم') {
      widget.isMatched = false;
      widget.wrong18 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[19] == 'تركوا') {
      widget.isMatched19 = true;
      widget.correct19 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[19] != 'تركوا') {
      widget.isMatched19 = false;
      widget.wrong19 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[20] == 'الباقي') {
      widget.isMatched20 = true;
      widget.correct20 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[20] != 'الباقي') {
      widget.isMatched20 = false;
      widget.wrong20 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[21] == 'على') {
      widget.isMatched21 = true;
      widget.correct21 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[21] != 'على') {
      widget.isMatched21 = false;
      widget.wrong21 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[22] == 'المائده') {
      widget.isMatched22 = true;
      widget.correct22 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
      _Next();
    }
    if (my_words[22] != 'المائده') {
      widget.isMatched22 = false;
      widget.wrong22 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
      _Next();
    } else {
      print('Finished');
    }
  }

  void errorHandler() => activateSpeechRecognizer();

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });
  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BandG3(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class Content_2 extends StatelessWidget {
  String text1;
  bool? correct;
  bool? correct1;
  bool? correct2;
  bool? correct3;
  bool? correct4;
  bool? correct5;
  bool? correct6;
  bool? correct7;
  bool? correct8;
  bool? correct9;
  bool? correct10;
  bool? correct11;
  bool? correct12;
  bool? correct13;
  bool? correct14;
  bool? correct15;
  bool? correct16;
  bool? correct17;
  bool? correct18;
  bool? correct19;
  bool? correct20;
  bool? correct21;
  bool? correct22;

  bool? wrong;
  bool? wrong1;
  bool? wrong2;
  bool? wrong3;
  bool? wrong4;
  bool? wrong5;
  bool? wrong6;
  bool? wrong7;
  bool? wrong8;
  bool? wrong9;
  bool? wrong10;
  bool? wrong11;
  bool? wrong12;
  bool? wrong13;
  bool? wrong14;
  bool? wrong15;
  bool? wrong16;
  bool? wrong17;
  bool? wrong18;
  bool? wrong19;
  bool? wrong20;
  bool? wrong21;
  bool? wrong22;

  bool? isMatched;
  bool? isMatched1;
  bool? isMatched2;
  bool? isMatched3;
  bool? isMatched4;
  bool? isMatched5;
  bool? isMatched6;
  bool? isMatched7;
  bool? isMatched8;
  bool? isMatched9;
  bool? isMatched10;
  bool? isMatched11;
  bool? isMatched12;
  bool? isMatched13;
  bool? isMatched14;
  bool? isMatched15;
  bool? isMatched16;
  bool? isMatched17;
  bool? isMatched18;
  bool? isMatched19;
  bool? isMatched20;
  bool? isMatched21;
  bool? isMatched22;

  Content_2({
    Key? key,
    required this.text1,
    required this.correct,
    required this.correct1,
    required this.correct2,
    required this.correct3,
    required this.correct4,
    required this.correct5,
    required this.correct6,
    required this.correct7,
    required this.correct8,
    required this.correct9,
    required this.correct10,
    required this.correct11,
    required this.correct12,
    required this.correct13,
    required this.correct14,
    required this.correct15,
    required this.correct16,
    required this.correct17,
    required this.correct18,
    required this.correct19,
    required this.correct20,
    required this.correct21,
    required this.correct22,
    required this.wrong,
    required this.wrong1,
    required this.wrong2,
    required this.wrong3,
    required this.wrong4,
    required this.wrong5,
    required this.wrong6,
    required this.wrong7,
    required this.wrong8,
    required this.wrong9,
    required this.wrong10,
    required this.wrong11,
    required this.wrong12,
    required this.wrong13,
    required this.wrong14,
    required this.wrong15,
    required this.wrong16,
    required this.wrong17,
    required this.wrong18,
    required this.wrong19,
    required this.wrong20,
    required this.wrong21,
    required this.wrong22,
    required this.isMatched,
    required this.isMatched1,
    required this.isMatched2,
    required this.isMatched3,
    required this.isMatched4,
    required this.isMatched5,
    required this.isMatched6,
    required this.isMatched7,
    required this.isMatched8,
    required this.isMatched9,
    required this.isMatched10,
    required this.isMatched11,
    required this.isMatched12,
    required this.isMatched13,
    required this.isMatched14,
    required this.isMatched15,
    required this.isMatched16,
    required this.isMatched17,
    required this.isMatched18,
    required this.isMatched19,
    required this.isMatched20,
    required this.isMatched21,
    required this.isMatched22,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    var colored_text = text1.toString().split(" ");

    return Column(
      children: [
        SizedBox(height: currentHeight / 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  colored_text[0],
                  style: TextStyle(
                      color: isMatched == true
                          ? Colors.green
                          : isMatched == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[1],
                  style: TextStyle(
                      color: isMatched1 == true
                          ? Colors.green
                          : isMatched1 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[2],
                  style: TextStyle(
                      color: isMatched2 == true
                          ? Colors.green
                          : isMatched2 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[3],
                  style: TextStyle(
                      color: isMatched3 == true
                          ? Colors.green
                          : isMatched3 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[4],
                  style: TextStyle(
                      color: isMatched4 == true
                          ? Colors.green
                          : isMatched4 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[5],
                  style: TextStyle(
                      color: isMatched5 == true
                          ? Colors.green
                          : isMatched5 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  colored_text[6],
                  style: TextStyle(
                      color: isMatched6 == true
                          ? Colors.green
                          : isMatched6 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[7],
                  style: TextStyle(
                      color: isMatched7 == true
                          ? Colors.green
                          : isMatched7 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[8],
                  style: TextStyle(
                      color: isMatched8 == true
                          ? Colors.green
                          : isMatched8 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[9],
                  style: TextStyle(
                      color: isMatched9 == true
                          ? Colors.green
                          : isMatched9 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[10],
                  style: TextStyle(
                      color: isMatched10 == true
                          ? Colors.green
                          : isMatched10 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[11],
                  style: TextStyle(
                      color: isMatched11 == true
                          ? Colors.green
                          : isMatched11 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
              ],
            ),
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                colored_text[12],
                style: TextStyle(
                    color: isMatched12 == true
                        ? Colors.green
                        : isMatched12 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              Text(
                colored_text[13],
                style: TextStyle(
                    color: isMatched13 == true
                        ? Colors.green
                        : isMatched13 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                colored_text[14],
                style: TextStyle(
                    color: isMatched14 == true
                        ? Colors.green
                        : isMatched14 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                colored_text[15],
                style: TextStyle(
                    color: isMatched15 == true
                        ? Colors.green
                        : isMatched15 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              Text(
                colored_text[16],
                style: TextStyle(
                    color: isMatched16 == true
                        ? Colors.green
                        : isMatched16 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              Text(
                colored_text[17],
                style: TextStyle(
                    color: isMatched17 == true
                        ? Colors.green
                        : isMatched17 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              Text(
                colored_text[18],
                style: TextStyle(
                    color: isMatched18 == true
                        ? Colors.green
                        : isMatched15 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
            ],
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                colored_text[19],
                style: TextStyle(
                    color: isMatched19 == true
                        ? Colors.green
                        : isMatched19 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                colored_text[20],
                style: TextStyle(
                    color: isMatched20 == true
                        ? Colors.green
                        : isMatched20 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                colored_text[21],
                style: TextStyle(
                    color: isMatched21 == true
                        ? Colors.green
                        : isMatched21 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                'المائدة',
                style: TextStyle(
                    color: isMatched22 == true
                        ? Colors.green
                        : isMatched22 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BandG3 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;

  bool? correct;
  bool? correct1;
  bool? correct2;
  bool? correct3;
  bool? correct4;
  bool? correct5;
  bool? correct6;
  bool? correct7;
  bool? correct8;
  bool? correct9;
  bool? correct10;
  bool? correct11;
  bool? correct12;
  bool? correct13;
  bool? correct14;
  bool? correct15;
  bool? correct16;
  bool? correct17;
  bool? correct18;
  bool? correct19;
  bool? correct20;
  bool? correct21;

  bool? wrong;
  bool? wrong1;
  bool? wrong2;
  bool? wrong3;
  bool? wrong4;
  bool? wrong5;
  bool? wrong6;
  bool? wrong7;
  bool? wrong8;
  bool? wrong9;
  bool? wrong10;
  bool? wrong11;
  bool? wrong12;
  bool? wrong13;
  bool? wrong14;
  bool? wrong15;
  bool? wrong16;
  bool? wrong17;
  bool? wrong18;
  bool? wrong19;
  bool? wrong20;
  bool? wrong21;

  bool? isMatched;
  bool? isMatched1;
  bool? isMatched2;
  bool? isMatched3;
  bool? isMatched4;
  bool? isMatched5;
  bool? isMatched6;
  bool? isMatched7;
  bool? isMatched8;
  bool? isMatched9;
  bool? isMatched10;
  bool? isMatched11;
  bool? isMatched12;
  bool? isMatched13;
  bool? isMatched14;
  bool? isMatched15;
  bool? isMatched16;
  bool? isMatched17;
  bool? isMatched18;
  bool? isMatched19;
  bool? isMatched20;
  bool? isMatched21;

  BandG3(
      {Key? key,
      required this.childID,
      required this.currentAvatar,
      required this.currentName})
      : super(key: key);
  @override
  _BandG3State createState() => _BandG3State();
}

class _BandG3State extends State<BandG3> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  String _currentLocale = 'ar_Ar';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();

    // matchingWords();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_BandG2State.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('ar_Ar').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    //these lines of code to make the screen in horizontal state
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidht = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/stories_imgs/bears3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.7),
                      ),
                      height: currentHeight / 2.5,
                      width: currentWidht / 1.4,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('Stories')
                            .where('ID', isEqualTo: 'Sy_Three_Bears_And_Girl')
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, i) {
                                var content =
                                    snapshot.data!.docs[i].get('Text')[2];

                                list.add(content);

                                return Content_3(
                                  text1: content.toString(),
                                  correct: widget.correct,
                                  correct1: widget.correct1,
                                  correct2: widget.correct2,
                                  correct3: widget.correct3,
                                  correct4: widget.correct4,
                                  correct5: widget.correct5,
                                  correct6: widget.correct6,
                                  correct7: widget.correct7,
                                  correct8: widget.correct8,
                                  correct9: widget.correct9,
                                  correct10: widget.correct10,
                                  correct11: widget.correct11,
                                  correct12: widget.correct12,
                                  correct13: widget.correct13,
                                  correct14: widget.correct14,
                                  correct15: widget.correct15,
                                  correct16: widget.correct16,
                                  correct17: widget.correct17,
                                  correct18: widget.correct18,
                                  correct19: widget.correct19,
                                  correct20: widget.correct20,
                                  correct21: widget.correct21,
                                  wrong: widget.wrong,
                                  wrong1: widget.wrong1,
                                  wrong2: widget.wrong2,
                                  wrong3: widget.wrong3,
                                  wrong4: widget.wrong4,
                                  wrong5: widget.wrong5,
                                  wrong6: widget.wrong6,
                                  wrong7: widget.wrong7,
                                  wrong8: widget.wrong8,
                                  wrong9: widget.wrong9,
                                  wrong10: widget.wrong10,
                                  wrong11: widget.wrong11,
                                  wrong12: widget.wrong12,
                                  wrong13: widget.wrong13,
                                  wrong14: widget.wrong14,
                                  wrong15: widget.wrong15,
                                  wrong16: widget.wrong16,
                                  wrong17: widget.wrong17,
                                  wrong18: widget.wrong18,
                                  wrong19: widget.wrong19,
                                  wrong20: widget.wrong20,
                                  wrong21: widget.wrong21,
                                  isMatched: widget.isMatched,
                                  isMatched1: widget.isMatched1,
                                  isMatched2: widget.isMatched2,
                                  isMatched3: widget.isMatched3,
                                  isMatched4: widget.isMatched4,
                                  isMatched5: widget.isMatched5,
                                  isMatched6: widget.isMatched6,
                                  isMatched7: widget.isMatched7,
                                  isMatched8: widget.isMatched8,
                                  isMatched9: widget.isMatched9,
                                  isMatched10: widget.isMatched10,
                                  isMatched11: widget.isMatched11,
                                  isMatched12: widget.isMatched12,
                                  isMatched13: widget.isMatched13,
                                  isMatched14: widget.isMatched14,
                                  isMatched15: widget.isMatched15,
                                  isMatched16: widget.isMatched16,
                                  isMatched17: widget.isMatched17,
                                  isMatched18: widget.isMatched18,
                                  isMatched19: widget.isMatched19,
                                  isMatched20: widget.isMatched20,
                                  isMatched21: widget.isMatched21,
                                );
                              },
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BandG4(
                              childID: widget.childID,
                              currentAvatar: widget.currentAvatar,
                              currentName: widget.currentName,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 28,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 28,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BandG2(
                              childID: widget.childID,
                              currentAvatar: widget.currentAvatar,
                              currentName: widget.currentName,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 28,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 28,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: currentHeight / 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _speechRecognitionAvailable && !_isListening
                          ? () => start()
                          : null,
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 16,
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_off,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false);
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 16,
                        child: Icon(
                          Icons.home,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            print('tapped');
                            // if (play == true) {
                            //   play = false;
                            // } else {
                            //   if (play == false) {
                            //     play = true;
                            //   }
                            // }
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: currentHeight / 16,
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        child: Icon(
                          Icons.volume_up,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Statistics')
                      .doc(_auth.currentUser!.email)
                      .collection('children')
                      .doc(widget.currentName)
                      .collection('words_of_story ')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator(); //If no data return this
                    }

                    final information = snapshot.data!
                        .docs; //information: stores gets the data from firebase documents

                    for (var item in information) {
                      final getCS =
                          item.data().toString().contains('correct_WordsStory')
                              ? item.get('correct_WordsStory')
                              : 0;
                      final getWS =
                          item.data().toString().contains('wrong_WordsStory')
                              ? item.get('wrong_WordsStory')
                              : 0;

                      Counter.correctStoryCounter = getCS;
                      Counter.wrongStoryCounter = getWS;
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_BandG2State.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_BandG2State.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_BandG2State.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    dynamic my_words = text.toString().split(" ");

    if (my_words[0] == 'وبعد') {
      widget.isMatched = true;
      widget.correct = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[0] != 'وبعد') {
      widget.isMatched = false;
      widget.wrong = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[1] == 'تناول') {
      widget.isMatched1 = true;
      widget.correct1 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[1] != 'تناول') {
      widget.isMatched1 = false;
      widget.wrong1 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[2] == 'الطعام') {
      widget.isMatched2 = true;
      widget.correct2 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[2] != 'الطعام') {
      widget.isMatched2 = false;
      widget.wrong2 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[3] == 'خرجت') {
      widget.isMatched3 = true;
      widget.correct3 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[3] != 'خرجت') {
      widget.isMatched3 = false;
      widget.wrong3 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[4] == 'الدببه') {
      widget.isMatched4 = true;
      widget.correct4 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[4] != 'الدببه') {
      widget.isMatched4 = false;
      widget.wrong4 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[5] == 'الثلاثه') {
      widget.isMatched5 = true;
      widget.correct5 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[5] != 'الثلاثه') {
      widget.isMatched5 = false;
      widget.wrong5 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[6] == 'من') {
      widget.isMatched6 = true;
      widget.correct6 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[6] != 'من') {
      widget.isMatched6 = false;
      widget.wrong6 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[7] == 'البيت') {
      widget.isMatched7 = true;
      widget.correct7 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[7] != 'البيت') {
      widget.isMatched7 = false;
      widget.wrong7 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[8] == 'للتنزه') {
      widget.isMatched8 = true;
      widget.correct8 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[8] != 'للتنزه') {
      widget.isMatched8 = false;
      widget.wrong8 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[9] == 'في') {
      widget.isMatched9 = true;
      widget.correct9 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[9] != 'في') {
      widget.isMatched9 = false;
      widget.wrong9 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[10] == 'الغابه') {
      widget.isMatched10 = true;
      widget.correct10 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[10] != 'الغابه') {
      widget.isMatched10 = false;
      widget.wrong10 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[11] == 'وتركوا') {
      widget.isMatched11 = true;
      widget.correct11 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[11] != 'وتركوا') {
      widget.isMatched11 = false;
      widget.wrong11 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[12] == 'باب') {
      widget.isMatched12 = true;
      widget.correct12 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[12] != 'باب') {
      widget.isMatched12 = false;
      widget.wrong12 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[13] == 'بيتهم') {
      widget.isMatched13 = true;
      widget.correct13 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[13] != 'بيتهم') {
      widget.isMatched13 = false;
      widget.wrong13 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[14] == 'مفتوح') {
      widget.isMatched14 = true;
      widget.correct14 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
      _Next();
    }
    if (my_words[14] != 'مفتوح') {
      widget.isMatched14 = false;
      widget.wrong14 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
      _Next();
    } else {
      print('Finished');
    }
  }

  void errorHandler() => activateSpeechRecognizer();

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });
  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BandG4(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class Content_3 extends StatelessWidget {
  String text1;
  bool? correct;
  bool? correct1;
  bool? correct2;
  bool? correct3;
  bool? correct4;
  bool? correct5;
  bool? correct6;
  bool? correct7;
  bool? correct8;
  bool? correct9;
  bool? correct10;
  bool? correct11;
  bool? correct12;
  bool? correct13;
  bool? correct14;
  bool? correct15;
  bool? correct16;
  bool? correct17;
  bool? correct18;
  bool? correct19;
  bool? correct20;
  bool? correct21;

  bool? wrong;
  bool? wrong1;
  bool? wrong2;
  bool? wrong3;
  bool? wrong4;
  bool? wrong5;
  bool? wrong6;
  bool? wrong7;
  bool? wrong8;
  bool? wrong9;
  bool? wrong10;
  bool? wrong11;
  bool? wrong12;
  bool? wrong13;
  bool? wrong14;
  bool? wrong15;
  bool? wrong16;
  bool? wrong17;
  bool? wrong18;
  bool? wrong19;
  bool? wrong20;
  bool? wrong21;

  bool? isMatched;
  bool? isMatched1;
  bool? isMatched2;
  bool? isMatched3;
  bool? isMatched4;
  bool? isMatched5;
  bool? isMatched6;
  bool? isMatched7;
  bool? isMatched8;
  bool? isMatched9;
  bool? isMatched10;
  bool? isMatched11;
  bool? isMatched12;
  bool? isMatched13;
  bool? isMatched14;
  bool? isMatched15;
  bool? isMatched16;
  bool? isMatched17;
  bool? isMatched18;
  bool? isMatched19;
  bool? isMatched20;
  bool? isMatched21;

  Content_3({
    Key? key,
    required this.text1,
    required this.correct,
    required this.correct1,
    required this.correct2,
    required this.correct3,
    required this.correct4,
    required this.correct5,
    required this.correct6,
    required this.correct7,
    required this.correct8,
    required this.correct9,
    required this.correct10,
    required this.correct11,
    required this.correct12,
    required this.correct13,
    required this.correct14,
    required this.correct15,
    required this.correct16,
    required this.correct17,
    required this.correct18,
    required this.correct19,
    required this.correct20,
    required this.correct21,
    required this.wrong,
    required this.wrong1,
    required this.wrong2,
    required this.wrong3,
    required this.wrong4,
    required this.wrong5,
    required this.wrong6,
    required this.wrong7,
    required this.wrong8,
    required this.wrong9,
    required this.wrong10,
    required this.wrong11,
    required this.wrong12,
    required this.wrong13,
    required this.wrong14,
    required this.wrong15,
    required this.wrong16,
    required this.wrong17,
    required this.wrong18,
    required this.wrong19,
    required this.wrong20,
    required this.wrong21,
    required this.isMatched,
    required this.isMatched1,
    required this.isMatched2,
    required this.isMatched3,
    required this.isMatched4,
    required this.isMatched5,
    required this.isMatched6,
    required this.isMatched7,
    required this.isMatched8,
    required this.isMatched9,
    required this.isMatched10,
    required this.isMatched11,
    required this.isMatched12,
    required this.isMatched13,
    required this.isMatched14,
    required this.isMatched15,
    required this.isMatched16,
    required this.isMatched17,
    required this.isMatched18,
    required this.isMatched19,
    required this.isMatched20,
    required this.isMatched21,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    var colored_text = text1.toString().split(" ");

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  colored_text[0],
                  style: TextStyle(
                      color: isMatched == true
                          ? Colors.green
                          : isMatched == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[1],
                  style: TextStyle(
                      color: isMatched1 == true
                          ? Colors.green
                          : isMatched1 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[2],
                  style: TextStyle(
                      color: isMatched2 == true
                          ? Colors.green
                          : isMatched2 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[3],
                  style: TextStyle(
                      color: isMatched3 == true
                          ? Colors.green
                          : isMatched3 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[4],
                  style: TextStyle(
                      color: isMatched4 == true
                          ? Colors.green
                          : isMatched4 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[5],
                  style: TextStyle(
                      color: isMatched5 == true
                          ? Colors.green
                          : isMatched5 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  colored_text[6],
                  style: TextStyle(
                      color: isMatched6 == true
                          ? Colors.green
                          : isMatched6 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[7],
                  style: TextStyle(
                      color: isMatched7 == true
                          ? Colors.green
                          : isMatched7 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[8],
                  style: TextStyle(
                      color: isMatched8 == true
                          ? Colors.green
                          : isMatched8 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[9],
                  style: TextStyle(
                      color: isMatched9 == true
                          ? Colors.green
                          : isMatched9 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[10],
                  style: TextStyle(
                      color: isMatched10 == true
                          ? Colors.green
                          : isMatched10 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[11],
                  style: TextStyle(
                      color: isMatched11 == true
                          ? Colors.green
                          : isMatched11 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
              ],
            ),
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                colored_text[12],
                style: TextStyle(
                    color: isMatched12 == true
                        ? Colors.green
                        : isMatched12 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              const SizedBox(width: 3),
              Text(
                colored_text[13],
                style: TextStyle(
                    color: isMatched13 == true
                        ? Colors.green
                        : isMatched13 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                'مفتوح',
                style: TextStyle(
                    color: isMatched14 == true
                        ? Colors.green
                        : isMatched14 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class BandG4 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;

  bool? correct;
  bool? correct1;
  bool? correct2;
  bool? correct3;
  bool? correct4;
  bool? correct5;
  bool? correct6;
  bool? correct7;
  bool? correct8;
  bool? correct9;
  bool? correct10;
  bool? correct11;
  bool? correct12;
  bool? correct13;

  bool? wrong;
  bool? wrong1;
  bool? wrong2;
  bool? wrong3;
  bool? wrong4;
  bool? wrong5;
  bool? wrong6;
  bool? wrong7;
  bool? wrong8;
  bool? wrong9;
  bool? wrong10;
  bool? wrong11;
  bool? wrong12;
  bool? wrong13;

  bool? isMatched;
  bool? isMatched1;
  bool? isMatched2;
  bool? isMatched3;
  bool? isMatched4;
  bool? isMatched5;
  bool? isMatched6;
  bool? isMatched7;
  bool? isMatched8;
  bool? isMatched9;
  bool? isMatched10;
  bool? isMatched11;
  bool? isMatched12;
  bool? isMatched13;

  BandG4(
      {Key? key,
      required this.childID,
      required this.currentAvatar,
      required this.currentName})
      : super(key: key);
  @override
  _BandG4State createState() => _BandG4State();
}

class _BandG4State extends State<BandG4> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  String _currentLocale = 'ar_Ar';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_BandG4State.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('ar_Ar').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    //these lines of code to make the screen in horizontal state
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidht = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/stories_imgs/bears4.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.7),
                      ),
                      height: currentHeight / 2.5,
                      width: currentWidht / 1.4,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('Stories')
                            .where('ID', isEqualTo: 'Sy_Three_Bears_And_Girl')
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, i) {
                                var content =
                                    snapshot.data!.docs[i].get('Text')[3];

                                list.add(content);

                                return Content_4(
                                  text1: content.toString(),
                                  correct: widget.correct,
                                  correct1: widget.correct1,
                                  correct2: widget.correct2,
                                  correct3: widget.correct3,
                                  correct4: widget.correct4,
                                  correct5: widget.correct5,
                                  correct6: widget.correct6,
                                  correct7: widget.correct7,
                                  correct8: widget.correct8,
                                  correct9: widget.correct9,
                                  correct10: widget.correct10,
                                  correct11: widget.correct11,
                                  correct12: widget.correct12,
                                  correct13: widget.correct13,
                                  wrong: widget.wrong,
                                  wrong1: widget.wrong1,
                                  wrong2: widget.wrong2,
                                  wrong3: widget.wrong3,
                                  wrong4: widget.wrong4,
                                  wrong5: widget.wrong5,
                                  wrong6: widget.wrong6,
                                  wrong7: widget.wrong7,
                                  wrong8: widget.wrong8,
                                  wrong9: widget.wrong9,
                                  wrong10: widget.wrong10,
                                  wrong11: widget.wrong11,
                                  wrong12: widget.wrong12,
                                  wrong13: widget.wrong13,
                                  isMatched: widget.isMatched,
                                  isMatched1: widget.isMatched1,
                                  isMatched2: widget.isMatched2,
                                  isMatched3: widget.isMatched3,
                                  isMatched4: widget.isMatched4,
                                  isMatched5: widget.isMatched5,
                                  isMatched6: widget.isMatched6,
                                  isMatched7: widget.isMatched7,
                                  isMatched8: widget.isMatched8,
                                  isMatched9: widget.isMatched9,
                                  isMatched10: widget.isMatched10,
                                  isMatched11: widget.isMatched11,
                                  isMatched12: widget.isMatched12,
                                  isMatched13: widget.isMatched13,
                                );
                              },
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BandG5(
                              childID: widget.childID,
                              currentAvatar: widget.currentAvatar,
                              currentName: widget.currentName,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 28,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 28,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BandG3(
                              childID: widget.childID,
                              currentAvatar: widget.currentAvatar,
                              currentName: widget.currentName,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 28,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 28,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: currentHeight / 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _speechRecognitionAvailable && !_isListening
                          ? () => start()
                          : null,
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 16,
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_off,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false);
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 16,
                        child: Icon(
                          Icons.home,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            print('tapped');
                            // if (play == true) {
                            //   play = false;
                            // } else {
                            //   if (play == false) {
                            //     play = true;
                            //   }
                            // }
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: currentHeight / 16,
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        child: Icon(
                          Icons.volume_up,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Statistics')
                      .doc(_auth.currentUser!.email)
                      .collection('children')
                      .doc(widget.currentName)
                      .collection('words_of_story ')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator(); //If no data return this
                    }

                    final information = snapshot.data!
                        .docs; //information: stores gets the data from firebase documents

                    for (var item in information) {
                      final getCS =
                          item.data().toString().contains('correct_WordsStory')
                              ? item.get('correct_WordsStory')
                              : 0;
                      final getWS =
                          item.data().toString().contains('wrong_WordsStory')
                              ? item.get('wrong_WordsStory')
                              : 0;

                      Counter.correctStoryCounter = getCS;
                      Counter.wrongStoryCounter = getWS;
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_BandG4State.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_BandG4State.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_BandG4State.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    dynamic my_words = text.toString().split(" ");

    if (my_words[0] == 'وكانت') {
      widget.isMatched = true;
      widget.correct = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[0] != 'وكانت') {
      widget.isMatched = false;
      widget.wrong = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[1] == 'هناك') {
      widget.isMatched1 = true;
      widget.correct1 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[1] != 'هناك') {
      widget.isMatched1 = false;
      widget.wrong1 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[2] == 'فتاه') {
      widget.isMatched2 = true;
      widget.correct2 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[2] != 'فتاه') {
      widget.isMatched2 = false;
      widget.wrong2 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[3] == 'تسير') {
      widget.isMatched3 = true;
      widget.correct3 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[3] != 'تسير') {
      widget.isMatched3 = false;
      widget.wrong3 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[4] == 'في') {
      widget.isMatched4 = true;
      widget.correct4 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[4] != 'في') {
      widget.isMatched4 = false;
      widget.wrong4 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[5] == 'الغابه') {
      widget.isMatched5 = true;
      widget.correct5 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[5] != 'الغابه') {
      widget.isMatched5 = false;
      widget.wrong5 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[6] == 'فشعرت') {
      widget.isMatched6 = true;
      widget.correct6 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[6] != 'فشعرت') {
      widget.isMatched6 = false;
      widget.wrong6 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[7] == 'بالجوع') {
      widget.isMatched7 = true;
      widget.correct7 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[7] != 'بالجوع') {
      widget.isMatched7 = false;
      widget.wrong7 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[8] == 'والتعب') {
      widget.isMatched8 = true;
      widget.correct8 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[8] != 'والتعب') {
      widget.isMatched8 = false;
      widget.wrong8 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[9] == 'فرات') {
      widget.isMatched9 = true;
      widget.correct9 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[9] != 'فرات') {
      widget.isMatched9 = false;
      widget.wrong9 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[10] == 'بيتا') {
      widget.isMatched10 = true;
      widget.correct10 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[10] != 'بيتا') {
      widget.isMatched10 = false;
      widget.wrong10 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[11] == 'مفتوحا') {
      widget.isMatched11 = true;
      widget.correct11 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[11] != 'مفتوحا') {
      widget.isMatched11 = false;
      widget.wrong11 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[12] == 'فدخلت') {
      widget.isMatched12 = true;
      widget.correct12 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[12] != 'فدخلت') {
      widget.isMatched12 = false;
      widget.wrong12 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[13] == 'فيه') {
      widget.isMatched13 = true;
      widget.correct13 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    }
    if (my_words[13] != 'فيه') {
      widget.isMatched13 = false;
      widget.wrong13 = true;
      Counter.wrongStoryCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('words_of_story')
          .doc('words_of_story')
          .update({
        "correct_WordsStory": Counter.correctStoryCounter,
        "wrong_WordsStory": Counter.wrongStoryCounter,
      });
    } else {
      print('Finished');
    }
  }

  void errorHandler() => activateSpeechRecognizer();

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });
  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BandG5(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class Content_4 extends StatelessWidget {
  String text1;
  bool? correct;
  bool? correct1;
  bool? correct2;
  bool? correct3;
  bool? correct4;
  bool? correct5;
  bool? correct6;
  bool? correct7;
  bool? correct8;
  bool? correct9;
  bool? correct10;
  bool? correct11;
  bool? correct12;
  bool? correct13;

  bool? wrong;
  bool? wrong1;
  bool? wrong2;
  bool? wrong3;
  bool? wrong4;
  bool? wrong5;
  bool? wrong6;
  bool? wrong7;
  bool? wrong8;
  bool? wrong9;
  bool? wrong10;
  bool? wrong11;
  bool? wrong12;
  bool? wrong13;

  bool? isMatched;
  bool? isMatched1;
  bool? isMatched2;
  bool? isMatched3;
  bool? isMatched4;
  bool? isMatched5;
  bool? isMatched6;
  bool? isMatched7;
  bool? isMatched8;
  bool? isMatched9;
  bool? isMatched10;
  bool? isMatched11;
  bool? isMatched12;
  bool? isMatched13;

  Content_4({
    Key? key,
    required this.text1,
    required this.correct,
    required this.correct1,
    required this.correct2,
    required this.correct3,
    required this.correct4,
    required this.correct5,
    required this.correct6,
    required this.correct7,
    required this.correct8,
    required this.correct9,
    required this.correct10,
    required this.correct11,
    required this.correct12,
    required this.correct13,
    required this.wrong,
    required this.wrong1,
    required this.wrong2,
    required this.wrong3,
    required this.wrong4,
    required this.wrong5,
    required this.wrong6,
    required this.wrong7,
    required this.wrong8,
    required this.wrong9,
    required this.wrong10,
    required this.wrong11,
    required this.wrong12,
    required this.wrong13,
    required this.isMatched,
    required this.isMatched1,
    required this.isMatched2,
    required this.isMatched3,
    required this.isMatched4,
    required this.isMatched5,
    required this.isMatched6,
    required this.isMatched7,
    required this.isMatched8,
    required this.isMatched9,
    required this.isMatched10,
    required this.isMatched11,
    required this.isMatched12,
    required this.isMatched13,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    var colored_text = text1.toString().split(" ");

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(
          left: 5,
        ),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      colored_text[0],
                      style: TextStyle(
                          color: isMatched == true
                              ? Colors.green
                              : isMatched == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[1],
                      style: TextStyle(
                          color: isMatched1 == true
                              ? Colors.green
                              : isMatched1 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[2],
                      style: TextStyle(
                          color: isMatched2 == true
                              ? Colors.green
                              : isMatched2 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[3],
                      style: TextStyle(
                          color: isMatched3 == true
                              ? Colors.green
                              : isMatched3 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[4],
                      style: TextStyle(
                          color: isMatched4 == true
                              ? Colors.green
                              : isMatched4 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[5],
                      style: TextStyle(
                          color: isMatched5 == true
                              ? Colors.green
                              : isMatched5 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      colored_text[6],
                      style: TextStyle(
                          color: isMatched6 == true
                              ? Colors.green
                              : isMatched6 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[7],
                      style: TextStyle(
                          color: isMatched7 == true
                              ? Colors.green
                              : isMatched7 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[8],
                      style: TextStyle(
                          color: isMatched8 == true
                              ? Colors.green
                              : isMatched8 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[9],
                      style: TextStyle(
                          color: isMatched9 == true
                              ? Colors.green
                              : isMatched9 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[10],
                      style: TextStyle(
                          color: isMatched10 == true
                              ? Colors.green
                              : isMatched10 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      colored_text[11],
                      style: TextStyle(
                          color: isMatched11 == true
                              ? Colors.green
                              : isMatched11 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[12],
                      style: TextStyle(
                          color: isMatched12 == true
                              ? Colors.green
                              : isMatched12 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      'فيه',
                      style: TextStyle(
                          color: isMatched13 == true
                              ? Colors.green
                              : isMatched13 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BandG5 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;

  bool? correct;
  bool? correct1;
  bool? correct2;
  bool? correct3;
  bool? correct4;
  bool? correct5;
  bool? correct6;
  bool? correct7;
  bool? correct8;
  bool? correct9;
  bool? correct10;
  bool? correct11;
  bool? correct12;
  bool? correct13;
  bool? correct14;
  bool? correct15;
  bool? correct16;

  bool? wrong;
  bool? wrong1;
  bool? wrong2;
  bool? wrong3;
  bool? wrong4;
  bool? wrong5;
  bool? wrong6;
  bool? wrong7;
  bool? wrong8;
  bool? wrong9;
  bool? wrong10;
  bool? wrong11;
  bool? wrong12;
  bool? wrong13;
  bool? wrong14;
  bool? wrong15;
  bool? wrong16;

  bool? isMatched;
  bool? isMatched1;
  bool? isMatched2;
  bool? isMatched3;
  bool? isMatched4;
  bool? isMatched5;
  bool? isMatched6;
  bool? isMatched7;
  bool? isMatched8;
  bool? isMatched9;
  bool? isMatched10;
  bool? isMatched11;
  bool? isMatched12;
  bool? isMatched13;
  bool? isMatched14;
  bool? isMatched15;
  bool? isMatched16;

  BandG5(
      {Key? key,
      required this.childID,
      required this.currentAvatar,
      required this.currentName})
      : super(key: key);
  @override
  _BandG5State createState() => _BandG5State();
}

class _BandG5State extends State<BandG5> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  String _currentLocale = 'ar_Ar';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();

    // matchingWords();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_BandG2State.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('ar_Ar').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    //these lines of code to make the screen in horizontal state
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidht = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/stories_imgs/bears5.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.7),
                      ),
                      height: currentHeight / 2.5,
                      width: currentWidht / 1.4,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('Stories')
                            .where('ID', isEqualTo: 'Sy_Three_Bears_And_Girl')
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, i) {
                                var content =
                                    snapshot.data!.docs[i].get('Text')[4];

                                list.add(content);

                                return Content_5(
                                  text1: content.toString(),
                                  correct: widget.correct,
                                  correct1: widget.correct1,
                                  correct2: widget.correct2,
                                  correct3: widget.correct3,
                                  correct4: widget.correct4,
                                  correct5: widget.correct5,
                                  correct6: widget.correct6,
                                  correct7: widget.correct7,
                                  correct8: widget.correct8,
                                  correct9: widget.correct9,
                                  correct10: widget.correct10,
                                  correct11: widget.correct11,
                                  correct12: widget.correct12,
                                  correct13: widget.correct13,
                                  correct14: widget.correct14,
                                  correct15: widget.correct15,
                                  correct16: widget.correct16,
                                  wrong: widget.wrong,
                                  wrong1: widget.wrong1,
                                  wrong2: widget.wrong2,
                                  wrong3: widget.wrong3,
                                  wrong4: widget.wrong4,
                                  wrong5: widget.wrong5,
                                  wrong6: widget.wrong6,
                                  wrong7: widget.wrong7,
                                  wrong8: widget.wrong8,
                                  wrong9: widget.wrong9,
                                  wrong10: widget.wrong10,
                                  wrong11: widget.wrong11,
                                  wrong12: widget.wrong12,
                                  wrong13: widget.wrong13,
                                  wrong14: widget.wrong14,
                                  wrong15: widget.wrong15,
                                  wrong16: widget.wrong16,
                                  isMatched: widget.isMatched,
                                  isMatched1: widget.isMatched1,
                                  isMatched2: widget.isMatched2,
                                  isMatched3: widget.isMatched3,
                                  isMatched4: widget.isMatched4,
                                  isMatched5: widget.isMatched5,
                                  isMatched6: widget.isMatched6,
                                  isMatched7: widget.isMatched7,
                                  isMatched8: widget.isMatched8,
                                  isMatched9: widget.isMatched9,
                                  isMatched10: widget.isMatched10,
                                  isMatched11: widget.isMatched11,
                                  isMatched12: widget.isMatched12,
                                  isMatched13: widget.isMatched13,
                                  isMatched14: widget.isMatched14,
                                  isMatched15: widget.isMatched15,
                                  isMatched16: widget.isMatched16,
                                );
                              },
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BandG6(
                              childID: widget.childID,
                              currentAvatar: widget.currentAvatar,
                              currentName: widget.currentName,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 28,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 28,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BandG4(
                              childID: widget.childID,
                              currentAvatar: widget.currentAvatar,
                              currentName: widget.currentName,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 28,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 28,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: currentHeight / 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _speechRecognitionAvailable && !_isListening
                          ? () => start()
                          : null,
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 16,
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_off,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false);
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 16,
                        child: Icon(
                          Icons.home,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            print('tapped');
                            // if (play == true) {
                            //   play = false;
                            // } else {
                            //   if (play == false) {
                            //     play = true;
                            //   }
                            // }
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: currentHeight / 16,
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        child: Icon(
                          Icons.volume_up,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Statistics')
                      .doc(_auth.currentUser!.email)
                      .collection('children')
                      .doc(widget.currentName)
                      .collection('words_of_story ')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator(); //If no data return this
                    }

                    final information = snapshot.data!
                        .docs; //information: stores gets the data from firebase documents

                    for (var item in information) {
                      final getCS =
                          item.data().toString().contains('correct_WordsStory')
                              ? item.get('correct_WordsStory')
                              : 0;
                      final getWS =
                          item.data().toString().contains('wrong_WordsStory')
                              ? item.get('wrong_WordsStory')
                              : 0;

                      Counter.correctStoryCounter = getCS;
                      Counter.wrongStoryCounter = getWS;
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_BandG2State.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_BandG2State.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
  }

  void onRecognitionResult(String text) async {
    print('_BandG2State.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
    dynamic my_words = text.toString().split(" ");

    if (my_words[0] == 'في') {
      widget.isMatched = true;
      widget.correct = true;
    }
    if (my_words[0] != 'في') {
      widget.isMatched = false;
      widget.wrong = true;
    }
    if (my_words[1] == 'بدايه') {
      widget.isMatched1 = true;
      widget.correct1 = true;
    }
    if (my_words[1] != 'بدايه') {
      widget.isMatched1 = false;
      widget.wrong1 = true;
    }
    if (my_words[2] == 'المسابقه') {
      widget.isMatched2 = true;
      widget.correct2 = true;
    }
    if (my_words[2] != 'المسابقه') {
      widget.isMatched2 = false;
      widget.wrong2 = true;
    }
    if (my_words[3] == 'قفز') {
      widget.isMatched3 = true;
      widget.correct3 = true;
    }
    if (my_words[3] != 'قفز') {
      widget.isMatched3 = false;
      widget.wrong3 = true;
    }
    if (my_words[4] == 'الارنب') {
      widget.isMatched4 = true;
      widget.correct4 = true;
    }
    if (my_words[4] != 'الارنب') {
      widget.isMatched4 = false;
      widget.wrong4 = true;
    }
    if (my_words[5] == 'المغرور') {
      widget.isMatched5 = true;
      widget.correct5 = true;
    }
    if (my_words[5] != 'المغرور') {
      widget.isMatched5 = false;
      widget.wrong5 = true;
    }
    if (my_words[6] == 'بسرعه') {
      widget.isMatched6 = true;
      widget.correct6 = true;
    }
    if (my_words[6] != 'بسرعه') {
      widget.isMatched6 = false;
      widget.wrong6 = true;
    }
    if (my_words[7] == 'كبيره') {
      widget.isMatched7 = true;
      widget.correct7 = true;
    }
    if (my_words[7] != 'كبيره') {
      widget.isMatched7 = false;
      widget.wrong7 = true;
    }
    if (my_words[8] == 'بينما') {
      widget.isMatched8 = true;
      widget.correct8 = true;
    }
    if (my_words[8] != 'بينما') {
      widget.isMatched8 = false;
      widget.wrong8 = true;
    }
    if (my_words[9] == 'بدات') {
      widget.isMatched9 = true;
      widget.correct9 = true;
    }
    if (my_words[9] != 'بدات') {
      widget.isMatched9 = false;
      widget.wrong9 = true;
    }
    if (my_words[10] == 'السلحفاه') {
      widget.isMatched10 = true;
      widget.correct10 = true;
    }
    if (my_words[10] != 'السلحفاه') {
      widget.isMatched10 = false;
      widget.wrong10 = true;
    }
    if (my_words[11] == 'النشيطه') {
      widget.isMatched11 = true;
      widget.correct11 = true;
    }
    if (my_words[11] != 'النشيطه') {
      widget.isMatched11 = false;
      widget.wrong11 = true;
    }
    if (my_words[12] == 'في') {
      widget.isMatched12 = true;
      widget.correct12 = true;
    }
    if (my_words[12] != 'في') {
      widget.isMatched12 = false;
      widget.wrong12 = true;
    }
    if (my_words[13] == 'سيرها') {
      widget.isMatched13 = true;
      widget.correct13 = true;
    }
    if (my_words[13] != 'سيرها') {
      widget.isMatched13 = false;
      widget.wrong13 = true;
    }
    if (my_words[14] == 'المعتاد') {
      widget.isMatched14 = true;
      widget.correct14 = true;
    }
    if (my_words[14] != 'المعتاد') {
      widget.isMatched14 = false;
      widget.wrong14 = true;
    }
    if (my_words[15] == 'خلف') {
      widget.isMatched15 = true;
      widget.correct15 = true;
    }
    if (my_words[15] != 'خلف') {
      widget.isMatched15 = false;
      widget.wrong15 = true;
    }
    if (my_words[16] == 'الارنب') {
      widget.isMatched16 = true;
      widget.correct16 = true;
      _Next();
    }
    if (my_words[16] != 'الارنب') {
      widget.isMatched16 = false;
      widget.wrong16 = true;
      _Next();
    } else {
      print('Finished');
    }
  }

  void errorHandler() => activateSpeechRecognizer();

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });
  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BandG6(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class Content_5 extends StatelessWidget {
  String text1;
  bool? correct;
  bool? correct1;
  bool? correct2;
  bool? correct3;
  bool? correct4;
  bool? correct5;
  bool? correct6;
  bool? correct7;
  bool? correct8;
  bool? correct9;
  bool? correct10;
  bool? correct11;
  bool? correct12;
  bool? correct13;
  bool? correct14;
  bool? correct15;
  bool? correct16;

  bool? wrong;
  bool? wrong1;
  bool? wrong2;
  bool? wrong3;
  bool? wrong4;
  bool? wrong5;
  bool? wrong6;
  bool? wrong7;
  bool? wrong8;
  bool? wrong9;
  bool? wrong10;
  bool? wrong11;
  bool? wrong12;
  bool? wrong13;
  bool? wrong14;
  bool? wrong15;
  bool? wrong16;

  bool? isMatched;
  bool? isMatched1;
  bool? isMatched2;
  bool? isMatched3;
  bool? isMatched4;
  bool? isMatched5;
  bool? isMatched6;
  bool? isMatched7;
  bool? isMatched8;
  bool? isMatched9;
  bool? isMatched10;
  bool? isMatched11;
  bool? isMatched12;
  bool? isMatched13;
  bool? isMatched14;
  bool? isMatched15;
  bool? isMatched16;

  Content_5({
    Key? key,
    required this.text1,
    required this.correct,
    required this.correct1,
    required this.correct2,
    required this.correct3,
    required this.correct4,
    required this.correct5,
    required this.correct6,
    required this.correct7,
    required this.correct8,
    required this.correct9,
    required this.correct10,
    required this.correct11,
    required this.correct12,
    required this.correct13,
    required this.correct14,
    required this.correct15,
    required this.correct16,
    required this.wrong,
    required this.wrong1,
    required this.wrong2,
    required this.wrong3,
    required this.wrong4,
    required this.wrong5,
    required this.wrong6,
    required this.wrong7,
    required this.wrong8,
    required this.wrong9,
    required this.wrong10,
    required this.wrong11,
    required this.wrong12,
    required this.wrong13,
    required this.wrong14,
    required this.wrong15,
    required this.wrong16,
    required this.isMatched,
    required this.isMatched1,
    required this.isMatched2,
    required this.isMatched3,
    required this.isMatched4,
    required this.isMatched5,
    required this.isMatched6,
    required this.isMatched7,
    required this.isMatched8,
    required this.isMatched9,
    required this.isMatched10,
    required this.isMatched11,
    required this.isMatched12,
    required this.isMatched13,
    required this.isMatched14,
    required this.isMatched15,
    required this.isMatched16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    var colored_text = text1.toString().split(" ");

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Text(
                  colored_text[0],
                  style: TextStyle(
                      color: isMatched == true
                          ? Colors.green
                          : isMatched == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[1],
                  style: TextStyle(
                      color: isMatched1 == true
                          ? Colors.green
                          : isMatched1 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[2],
                  style: TextStyle(
                      color: isMatched2 == true
                          ? Colors.green
                          : isMatched2 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[3],
                  style: TextStyle(
                      color: isMatched3 == true
                          ? Colors.green
                          : isMatched3 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[4],
                  style: TextStyle(
                      color: isMatched4 == true
                          ? Colors.green
                          : isMatched4 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[5],
                  style: TextStyle(
                      color: isMatched5 == true
                          ? Colors.green
                          : isMatched5 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Text(
                  colored_text[6],
                  style: TextStyle(
                      color: isMatched6 == true
                          ? Colors.green
                          : isMatched6 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[7],
                  style: TextStyle(
                      color: isMatched7 == true
                          ? Colors.green
                          : isMatched7 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[8],
                  style: TextStyle(
                      color: isMatched8 == true
                          ? Colors.green
                          : isMatched8 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[9],
                  style: TextStyle(
                      color: isMatched9 == true
                          ? Colors.green
                          : isMatched9 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  colored_text[10],
                  style: TextStyle(
                      color: isMatched10 == true
                          ? Colors.green
                          : isMatched10 == false
                              ? Colors.red
                              : Colors.black,
                      fontSize: currentHeight / 22),
                ),
                const SizedBox(
                  width: 3,
                ),
              ],
            ),
          ),
        ),
        Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              SizedBox(
                width: currentHeight / 32,
              ),
              Text(
                colored_text[11],
                style: TextStyle(
                    color: isMatched11 == true
                        ? Colors.green
                        : isMatched11 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                colored_text[12],
                style: TextStyle(
                    color: isMatched12 == true
                        ? Colors.green
                        : isMatched12 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              Text(
                colored_text[13],
                style: TextStyle(
                    color: isMatched13 == true
                        ? Colors.green
                        : isMatched13 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                colored_text[14],
                style: TextStyle(
                    color: isMatched14 == true
                        ? Colors.green
                        : isMatched14 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                colored_text[15],
                style: TextStyle(
                    color: isMatched15 == true
                        ? Colors.green
                        : isMatched15 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
              Text(
                colored_text[16],
                style: TextStyle(
                    color: isMatched15 == true
                        ? Colors.green
                        : isMatched15 == false
                            ? Colors.red
                            : Colors.black,
                    fontSize: currentHeight / 22),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BandG6 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;

  bool? correct;
  bool? correct1;
  bool? correct2;
  bool? correct3;
  bool? correct4;
  bool? correct5;
  bool? correct6;
  bool? correct7;
  bool? correct8;
  bool? correct9;
  bool? correct10;
  bool? correct11;
  bool? correct12;
  bool? correct13;
  bool? correct14;
  bool? correct15;
  bool? correct16;
  bool? correct17;
  bool? correct18;
  bool? correct19;
  bool? correct20;
  bool? correct21;

  bool? wrong;
  bool? wrong1;
  bool? wrong2;
  bool? wrong3;
  bool? wrong4;
  bool? wrong5;
  bool? wrong6;
  bool? wrong7;
  bool? wrong8;
  bool? wrong9;
  bool? wrong10;
  bool? wrong11;
  bool? wrong12;
  bool? wrong13;
  bool? wrong14;
  bool? wrong15;
  bool? wrong16;
  bool? wrong17;
  bool? wrong18;
  bool? wrong19;
  bool? wrong20;
  bool? wrong21;

  bool? isMatched;
  bool? isMatched1;
  bool? isMatched2;
  bool? isMatched3;
  bool? isMatched4;
  bool? isMatched5;
  bool? isMatched6;
  bool? isMatched7;
  bool? isMatched8;
  bool? isMatched9;
  bool? isMatched10;
  bool? isMatched11;
  bool? isMatched12;
  bool? isMatched13;
  bool? isMatched14;
  bool? isMatched15;
  bool? isMatched16;
  bool? isMatched17;
  bool? isMatched18;
  bool? isMatched19;
  bool? isMatched20;
  bool? isMatched21;

  BandG6(
      {Key? key,
      required this.childID,
      required this.currentAvatar,
      required this.currentName})
      : super(key: key);
  @override
  _BandG6State createState() => _BandG6State();
}

class _BandG6State extends State<BandG6> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  String _currentLocale = 'ar_Ar';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();

    // matchingWords();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_BandG2State.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('ar_Ar').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    //these lines of code to make the screen in horizontal state
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidht = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/stories_imgs/bears6.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white.withOpacity(0.7),
                      ),
                      height: currentHeight / 2.5,
                      width: currentWidht / 1.4,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('Stories')
                            .where('ID', isEqualTo: 'Sy_Three_Bears_And_Girl')
                            .snapshots(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, i) {
                                var content =
                                    snapshot.data!.docs[i].get('Text')[5];

                                list.add(content);

                                return Content_6(
                                  text1: content.toString(),
                                  correct: widget.correct,
                                  correct1: widget.correct1,
                                  correct2: widget.correct2,
                                  correct3: widget.correct3,
                                  correct4: widget.correct4,
                                  correct5: widget.correct5,
                                  correct6: widget.correct6,
                                  correct7: widget.correct7,
                                  correct8: widget.correct8,
                                  correct9: widget.correct9,
                                  correct10: widget.correct10,
                                  correct11: widget.correct11,
                                  correct12: widget.correct12,
                                  correct13: widget.correct13,
                                  correct14: widget.correct14,
                                  correct15: widget.correct15,
                                  correct16: widget.correct16,
                                  correct17: widget.correct17,
                                  correct18: widget.correct18,
                                  correct19: widget.correct19,
                                  correct20: widget.correct20,
                                  correct21: widget.correct21,
                                  wrong: widget.wrong,
                                  wrong1: widget.wrong1,
                                  wrong2: widget.wrong2,
                                  wrong3: widget.wrong3,
                                  wrong4: widget.wrong4,
                                  wrong5: widget.wrong5,
                                  wrong6: widget.wrong6,
                                  wrong7: widget.wrong7,
                                  wrong8: widget.wrong8,
                                  wrong9: widget.wrong9,
                                  wrong10: widget.wrong10,
                                  wrong11: widget.wrong11,
                                  wrong12: widget.wrong12,
                                  wrong13: widget.wrong13,
                                  wrong14: widget.wrong14,
                                  wrong15: widget.wrong15,
                                  wrong16: widget.wrong16,
                                  wrong17: widget.wrong17,
                                  wrong18: widget.wrong18,
                                  wrong19: widget.wrong19,
                                  wrong20: widget.wrong20,
                                  wrong21: widget.wrong21,
                                  isMatched: widget.isMatched,
                                  isMatched1: widget.isMatched1,
                                  isMatched2: widget.isMatched2,
                                  isMatched3: widget.isMatched3,
                                  isMatched4: widget.isMatched4,
                                  isMatched5: widget.isMatched5,
                                  isMatched6: widget.isMatched6,
                                  isMatched7: widget.isMatched7,
                                  isMatched8: widget.isMatched8,
                                  isMatched9: widget.isMatched9,
                                  isMatched10: widget.isMatched10,
                                  isMatched11: widget.isMatched11,
                                  isMatched12: widget.isMatched12,
                                  isMatched13: widget.isMatched13,
                                  isMatched14: widget.isMatched14,
                                  isMatched15: widget.isMatched15,
                                  isMatched16: widget.isMatched16,
                                  isMatched17: widget.isMatched17,
                                  isMatched18: widget.isMatched18,
                                  isMatched19: widget.isMatched19,
                                  isMatched20: widget.isMatched20,
                                  isMatched21: widget.isMatched21,
                                );
                              },
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BandG7(
                              childID: widget.childID,
                              currentAvatar: widget.currentAvatar,
                              currentName: widget.currentName,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 28,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 28,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BandG5(
                              childID: widget.childID,
                              currentAvatar: widget.currentAvatar,
                              currentName: widget.currentName,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 28,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 28,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: currentHeight / 18,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _speechRecognitionAvailable && !_isListening
                          ? () => start()
                          : null,
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 16,
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_off,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Home(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false);
                      },
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 16,
                        child: Icon(
                          Icons.home,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            print('tapped');
                            // if (play == true) {
                            //   play = false;
                            // } else {
                            //   if (play == false) {
                            //     play = true;
                            //   }
                            // }
                          },
                        );
                      },
                      child: CircleAvatar(
                        radius: currentHeight / 16,
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        child: Icon(
                          Icons.volume_up,
                          color: Colors.white,
                          size: currentHeight / 14,
                        ),
                      ),
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Statistics')
                      .doc(_auth.currentUser!.email)
                      .collection('children')
                      .doc(widget.currentName)
                      .collection('words_of_story ')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator(); //If no data return this
                    }

                    final information = snapshot.data!
                        .docs; //information: stores gets the data from firebase documents

                    for (var item in information) {
                      final getCS =
                          item.data().toString().contains('correct_WordsStory')
                              ? item.get('correct_WordsStory')
                              : 0;
                      final getWS =
                          item.data().toString().contains('wrong_WordsStory')
                              ? item.get('wrong_WordsStory')
                              : 0;

                      Counter.correctStoryCounter = getCS;
                      Counter.wrongStoryCounter = getWS;
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_BandG2State.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_BandG2State.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_BandG2State.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
    dynamic my_words = text.toString().split(" ");

    if (my_words[0] == 'راى') {
      widget.isMatched = true;
      widget.correct = true;
    }
    if (my_words[0] != 'راى') {
      widget.isMatched = false;
      widget.wrong = true;
    }
    if (my_words[1] == 'الارنب') {
      widget.isMatched1 = true;
      widget.correct1 = true;
    }
    if (my_words[1] != 'الارنب') {
      widget.isMatched1 = false;
      widget.wrong1 = true;
    }
    if (my_words[2] == 'المغرور') {
      widget.isMatched2 = true;
      widget.correct2 = true;
    }
    if (my_words[2] != 'المغرور') {
      widget.isMatched2 = false;
      widget.wrong2 = true;
    }
    if (my_words[3] == 'انه') {
      widget.isMatched3 = true;
      widget.correct3 = true;
    }
    if (my_words[3] != 'انه') {
      widget.isMatched3 = false;
      widget.wrong3 = true;
    }
    if (my_words[4] == 'قد') {
      widget.isMatched4 = true;
      widget.correct4 = true;
    }
    if (my_words[4] != 'قد') {
      widget.isMatched4 = false;
      widget.wrong4 = true;
    }
    if (my_words[5] == 'قطع') {
      widget.isMatched5 = true;
      widget.correct5 = true;
    }
    if (my_words[5] != 'قطع') {
      widget.isMatched5 = false;
      widget.wrong5 = true;
    }
    if (my_words[6] == 'مسافه') {
      widget.isMatched6 = true;
      widget.correct6 = true;
    }
    if (my_words[6] != 'مسافه') {
      widget.isMatched6 = false;
      widget.wrong6 = true;
    }
    if (my_words[7] == 'كبيره') {
      widget.isMatched7 = true;
      widget.correct7 = true;
    }
    if (my_words[7] != 'كبيره') {
      widget.isMatched7 = false;
      widget.wrong7 = true;
    }
    if (my_words[8] == 'في') {
      widget.isMatched8 = true;
      widget.correct8 = true;
    }
    if (my_words[8] != 'في') {
      widget.isMatched8 = false;
      widget.wrong8 = true;
    }
    if (my_words[9] == 'السباق') {
      widget.isMatched9 = true;
      widget.correct9 = true;
    }
    if (my_words[9] != 'السباق') {
      widget.isMatched9 = false;
      widget.wrong9 = true;
    }
    if (my_words[10] == 'وما') {
      widget.isMatched10 = true;
      widget.correct10 = true;
    }
    if (my_words[10] != 'وما') {
      widget.isMatched10 = false;
      widget.wrong10 = true;
    }
    if (my_words[11] == 'تزال') {
      widget.isMatched11 = true;
      widget.correct11 = true;
    }
    if (my_words[11] != 'تزال') {
      widget.isMatched11 = false;
      widget.wrong11 = true;
    }
    if (my_words[12] == 'السلحفاه') {
      widget.isMatched12 = true;
      widget.correct12 = true;
    }
    if (my_words[12] != 'السلحفاه') {
      widget.isMatched12 = false;
      widget.wrong12 = true;
    }
    if (my_words[13] == 'تسير') {
      widget.isMatched13 = true;
      widget.correct13 = true;
    }
    if (my_words[13] != 'تسير') {
      widget.isMatched13 = false;
      widget.wrong13 = true;
    }
    if (my_words[14] == 'ببطء') {
      widget.isMatched14 = true;
      widget.correct14 = true;
    }
    if (my_words[14] != 'ببطء') {
      widget.isMatched14 = false;
      widget.wrong14 = true;
    }
    if (my_words[15] == 'فجلس') {
      widget.isMatched15 = true;
      widget.correct15 = true;
    }
    if (my_words[15] != 'فجلس') {
      widget.isMatched15 = false;
      widget.wrong15 = true;
    }
    if (my_words[16] == 'تحت') {
      widget.isMatched16 = true;
      widget.correct16 = true;
    }
    if (my_words[16] != 'تحت') {
      widget.isMatched16 = false;
      widget.wrong16 = true;
    }
    if (my_words[17] == 'شجره') {
      widget.isMatched17 = true;
      widget.correct17 = true;
    }
    if (my_words[17] != 'شجره') {
      widget.isMatched17 = false;
      widget.wrong17 = true;
    }
    if (my_words[18] == 'ياكل') {
      widget.isMatched18 = true;
      widget.correct18 = true;
    }
    if (my_words[18] != 'ياكل') {
      widget.isMatched18 = false;
      widget.wrong18 = true;
    }
    if (my_words[19] == 'جزره') {
      widget.isMatched19 = true;
      widget.correct = true;
      _Next();
    }
    if (my_words[19] != 'جزره') {
      widget.isMatched19 = false;
      widget.wrong19 = true;
      _Next();
    } else {
      print('Finished');
    }
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
  }

  void errorHandler() => activateSpeechRecognizer();

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });
  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BandG7(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class Content_6 extends StatelessWidget {
  String text1;
  bool? correct;
  bool? correct1;
  bool? correct2;
  bool? correct3;
  bool? correct4;
  bool? correct5;
  bool? correct6;
  bool? correct7;
  bool? correct8;
  bool? correct9;
  bool? correct10;
  bool? correct11;
  bool? correct12;
  bool? correct13;
  bool? correct14;
  bool? correct15;
  bool? correct16;
  bool? correct17;
  bool? correct18;
  bool? correct19;
  bool? correct20;
  bool? correct21;

  bool? wrong;
  bool? wrong1;
  bool? wrong2;
  bool? wrong3;
  bool? wrong4;
  bool? wrong5;
  bool? wrong6;
  bool? wrong7;
  bool? wrong8;
  bool? wrong9;
  bool? wrong10;
  bool? wrong11;
  bool? wrong12;
  bool? wrong13;
  bool? wrong14;
  bool? wrong15;
  bool? wrong16;
  bool? wrong17;
  bool? wrong18;
  bool? wrong19;
  bool? wrong20;
  bool? wrong21;

  bool? isMatched;
  bool? isMatched1;
  bool? isMatched2;
  bool? isMatched3;
  bool? isMatched4;
  bool? isMatched5;
  bool? isMatched6;
  bool? isMatched7;
  bool? isMatched8;
  bool? isMatched9;
  bool? isMatched10;
  bool? isMatched11;
  bool? isMatched12;
  bool? isMatched13;
  bool? isMatched14;
  bool? isMatched15;
  bool? isMatched16;
  bool? isMatched17;
  bool? isMatched18;
  bool? isMatched19;
  bool? isMatched20;
  bool? isMatched21;

  Content_6({
    Key? key,
    required this.text1,
    required this.correct,
    required this.correct1,
    required this.correct2,
    required this.correct3,
    required this.correct4,
    required this.correct5,
    required this.correct6,
    required this.correct7,
    required this.correct8,
    required this.correct9,
    required this.correct10,
    required this.correct11,
    required this.correct12,
    required this.correct13,
    required this.correct14,
    required this.correct15,
    required this.correct16,
    required this.correct17,
    required this.correct18,
    required this.correct19,
    required this.correct20,
    required this.correct21,
    required this.wrong,
    required this.wrong1,
    required this.wrong2,
    required this.wrong3,
    required this.wrong4,
    required this.wrong5,
    required this.wrong6,
    required this.wrong7,
    required this.wrong8,
    required this.wrong9,
    required this.wrong10,
    required this.wrong11,
    required this.wrong12,
    required this.wrong13,
    required this.wrong14,
    required this.wrong15,
    required this.wrong16,
    required this.wrong17,
    required this.wrong18,
    required this.wrong19,
    required this.wrong20,
    required this.wrong21,
    required this.isMatched,
    required this.isMatched1,
    required this.isMatched2,
    required this.isMatched3,
    required this.isMatched4,
    required this.isMatched5,
    required this.isMatched6,
    required this.isMatched7,
    required this.isMatched8,
    required this.isMatched9,
    required this.isMatched10,
    required this.isMatched11,
    required this.isMatched12,
    required this.isMatched13,
    required this.isMatched14,
    required this.isMatched15,
    required this.isMatched16,
    required this.isMatched17,
    required this.isMatched18,
    required this.isMatched19,
    required this.isMatched20,
    required this.isMatched21,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    var colored_text = text1.toString().split(" ");

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(
          left: 5,
        ),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      colored_text[0],
                      style: TextStyle(
                          color: isMatched == true
                              ? Colors.green
                              : isMatched == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[1],
                      style: TextStyle(
                          color: isMatched1 == true
                              ? Colors.green
                              : isMatched1 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[2],
                      style: TextStyle(
                          color: isMatched2 == true
                              ? Colors.green
                              : isMatched2 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[3],
                      style: TextStyle(
                          color: isMatched3 == true
                              ? Colors.green
                              : isMatched3 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[4],
                      style: TextStyle(
                          color: isMatched4 == true
                              ? Colors.green
                              : isMatched4 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[5],
                      style: TextStyle(
                          color: isMatched5 == true
                              ? Colors.green
                              : isMatched5 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      colored_text[6],
                      style: TextStyle(
                          color: isMatched6 == true
                              ? Colors.green
                              : isMatched6 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[7],
                      style: TextStyle(
                          color: isMatched7 == true
                              ? Colors.green
                              : isMatched7 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[8],
                      style: TextStyle(
                          color: isMatched8 == true
                              ? Colors.green
                              : isMatched8 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[9],
                      style: TextStyle(
                          color: isMatched9 == true
                              ? Colors.green
                              : isMatched9 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[10],
                      style: TextStyle(
                          color: isMatched10 == true
                              ? Colors.green
                              : isMatched10 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[11],
                      style: TextStyle(
                          color: isMatched11 == true
                              ? Colors.green
                              : isMatched11 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                  ],
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  SizedBox(
                    width: currentHeight / 14,
                  ),
                  Text(
                    colored_text[12],
                    style: TextStyle(
                        color: isMatched12 == true
                            ? Colors.green
                            : isMatched12 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                  Text(
                    colored_text[13],
                    style: TextStyle(
                        color: isMatched13 == true
                            ? Colors.green
                            : isMatched13 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    colored_text[14],
                    style: TextStyle(
                        color: isMatched14 == true
                            ? Colors.green
                            : isMatched14 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    colored_text[15],
                    style: TextStyle(
                        color: isMatched15 == true
                            ? Colors.green
                            : isMatched15 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                  Text(
                    colored_text[16],
                    style: TextStyle(
                        color: isMatched16 == true
                            ? Colors.green
                            : isMatched16 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                ],
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  SizedBox(width: currentHeight / 5),
                  Text(
                    colored_text[17],
                    style: TextStyle(
                        color: isMatched17 == true
                            ? Colors.green
                            : isMatched17 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                  Text(
                    colored_text[18],
                    style: TextStyle(
                        color: isMatched18 == true
                            ? Colors.green
                            : isMatched18 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                  Text(
                    colored_text[19],
                    style: TextStyle(
                        color: isMatched19 == true
                            ? Colors.green
                            : isMatched19 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BandG7 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;

  bool? correct;
  bool? correct1;
  bool? correct2;
  bool? correct3;
  bool? correct4;
  bool? correct5;
  bool? correct6;
  bool? correct7;
  bool? correct8;
  bool? correct9;
  bool? correct10;
  bool? correct11;
  bool? correct12;
  bool? correct13;
  bool? correct14;
  bool? correct15;
  bool? correct16;

  bool? wrong;
  bool? wrong1;
  bool? wrong2;
  bool? wrong3;
  bool? wrong4;
  bool? wrong5;
  bool? wrong6;
  bool? wrong7;
  bool? wrong8;
  bool? wrong9;
  bool? wrong10;
  bool? wrong11;
  bool? wrong12;
  bool? wrong13;
  bool? wrong14;
  bool? wrong15;
  bool? wrong16;

  bool? isMatched;
  bool? isMatched1;
  bool? isMatched2;
  bool? isMatched3;
  bool? isMatched4;
  bool? isMatched5;
  bool? isMatched6;
  bool? isMatched7;
  bool? isMatched8;
  bool? isMatched9;
  bool? isMatched10;
  bool? isMatched11;
  bool? isMatched12;
  bool? isMatched13;
  bool? isMatched14;
  bool? isMatched15;
  bool? isMatched16;

  BandG7(
      {Key? key,
      required this.childID,
      required this.currentAvatar,
      required this.currentName})
      : super(key: key);
  @override
  _BandG7State createState() => _BandG7State();
}

class _BandG7State extends State<BandG7> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  String _currentLocale = 'ar_Ar';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();

    // matchingWords();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_BandGState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('ar_Ar').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    //these lines of code to make the screen in horizontal state
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidht = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('imgs/stories_imgs/bears8'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.7),
                    ),
                    height: currentHeight / 2.5,
                    width: currentWidht / 1.4,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('Stories')
                          .where('ID', isEqualTo: 'Sy_Three_Bears_And_Girl')
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, i) {
                              var content =
                                  snapshot.data!.docs[i].get('Text')[6];

                              list.add(content);

                              return Content_7(
                                text1: content.toString(),
                                correct: widget.correct,
                                correct1: widget.correct1,
                                correct2: widget.correct2,
                                correct3: widget.correct3,
                                correct4: widget.correct4,
                                correct5: widget.correct5,
                                correct6: widget.correct6,
                                correct7: widget.correct7,
                                correct8: widget.correct8,
                                correct9: widget.correct9,
                                correct10: widget.correct10,
                                correct11: widget.correct11,
                                correct12: widget.correct12,
                                correct13: widget.correct13,
                                correct14: widget.correct14,
                                correct15: widget.correct15,
                                correct16: widget.correct16,
                                wrong: widget.wrong,
                                wrong1: widget.wrong1,
                                wrong2: widget.wrong2,
                                wrong3: widget.wrong3,
                                wrong4: widget.wrong4,
                                wrong5: widget.wrong5,
                                wrong6: widget.wrong6,
                                wrong7: widget.wrong7,
                                wrong8: widget.wrong8,
                                wrong9: widget.wrong9,
                                wrong10: widget.wrong10,
                                wrong11: widget.wrong11,
                                wrong12: widget.wrong12,
                                wrong13: widget.wrong13,
                                wrong14: widget.wrong14,
                                wrong15: widget.wrong15,
                                wrong16: widget.wrong16,
                                isMatched: widget.isMatched,
                                isMatched1: widget.isMatched1,
                                isMatched2: widget.isMatched2,
                                isMatched3: widget.isMatched3,
                                isMatched4: widget.isMatched4,
                                isMatched5: widget.isMatched5,
                                isMatched6: widget.isMatched6,
                                isMatched7: widget.isMatched7,
                                isMatched8: widget.isMatched8,
                                isMatched9: widget.isMatched9,
                                isMatched10: widget.isMatched10,
                                isMatched11: widget.isMatched11,
                                isMatched12: widget.isMatched12,
                                isMatched13: widget.isMatched13,
                                isMatched14: widget.isMatched14,
                                isMatched15: widget.isMatched15,
                                isMatched16: widget.isMatched16,
                              );
                            },
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BandG8(
                            childID: widget.childID,
                            currentAvatar: widget.currentAvatar,
                            currentName: widget.currentName,
                          ),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 28,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: currentHeight / 28,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BandG6(
                            childID: widget.childID,
                            currentAvatar: widget.currentAvatar,
                            currentName: widget.currentName,
                          ),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 28,
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: currentHeight / 28,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: currentHeight / 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_speechRecognitionAvailable && !_isListening) {
                        start();
                      }
                      null;
                    },
                    child: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 16,
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_off,
                        color: Colors.white,
                        size: currentHeight / 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(
                              childID: widget.childID,
                              currentAvatar: widget.currentAvatar,
                              currentName: widget.currentName,
                            ),
                          ),
                          (Route<dynamic> route) => false);
                    },
                    child: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 16,
                      child: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: currentHeight / 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          print('tapped');
                          // if (play == true) {
                          //   play = false;
                          // } else {
                          //   if (play == false) {
                          //     play = true;
                          //   }
                          // }
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: currentHeight / 16,
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      child: Icon(
                        Icons.volume_up,
                        color: Colors.white,
                        size: currentHeight / 14,
                      ),
                    ),
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('Statistics')
                    .doc(_auth.currentUser!.email)
                    .collection('children')
                    .doc(widget.currentName)
                    .collection('words_of_story ')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator(); //If no data return this
                  }

                  final information = snapshot.data!
                      .docs; //information: stores gets the data from firebase documents

                  for (var item in information) {
                    final getCS =
                        item.data().toString().contains('correct_WordsStory')
                            ? item.get('correct_WordsStory')
                            : 0;
                    final getWS =
                        item.data().toString().contains('wrong_WordsStory')
                            ? item.get('wrong_WordsStory')
                            : 0;

                    Counter.correctStoryCounter = getCS;
                    Counter.wrongStoryCounter = getWS;
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_BandGState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_BandGState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_BandGState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
    dynamic my_words = text.toString().split(" ");

    if (my_words[0] == 'اكل') {
      widget.isMatched = true;
      widget.correct = true;
    }
    if (my_words[0] != 'اكل') {
      widget.isMatched = false;
      widget.wrong = true;
    }
    if (my_words[1] == 'الارنب') {
      widget.isMatched1 = true;
      widget.correct1 = true;
    }
    if (my_words[1] != 'الارنب') {
      widget.isMatched1 = false;
      widget.wrong1 = true;
    }
    if (my_words[2] == 'المغرور') {
      widget.isMatched2 = true;
      widget.correct2 = true;
    }
    if (my_words[2] != 'المغرور') {
      widget.isMatched2 = false;
      widget.wrong2 = true;
    }
    if (my_words[3] == 'الجزره') {
      widget.isMatched3 = true;
      widget.correct3 = true;
    }
    if (my_words[3] != 'الجزره') {
      widget.isMatched3 = false;
      widget.wrong3 = true;
    }
    if (my_words[4] == 'فنام') {
      widget.isMatched4 = true;
      widget.correct4 = true;
    }
    if (my_words[4] != 'فنام') {
      widget.isMatched4 = false;
      widget.wrong4 = true;
    }
    if (my_words[5] == 'بينما') {
      widget.isMatched5 = true;
      widget.correct5 = true;
    }
    if (my_words[5] != 'بينما') {
      widget.isMatched5 = false;
      widget.wrong5 = true;
    }
    if (my_words[6] == 'وصلت') {
      widget.isMatched6 = true;
      widget.correct6 = true;
    }
    if (my_words[6] != 'وصلت') {
      widget.isMatched6 = false;
      widget.wrong6 = true;
    }
    if (my_words[7] == 'السلحفاه') {
      widget.isMatched7 = true;
      widget.correct7 = true;
    }
    if (my_words[7] != 'السلحفاه') {
      widget.isMatched7 = false;
      widget.wrong7 = true;
    }
    if (my_words[8] == 'النشيطه') {
      widget.isMatched8 = true;
      widget.correct8 = true;
    }
    if (my_words[8] != 'النشيطه') {
      widget.isMatched8 = false;
      widget.wrong8 = true;
    }
    if (my_words[9] == 'سيرها') {
      widget.isMatched9 = true;
      widget.correct9 = true;
    }
    if (my_words[9] != 'سيرها') {
      widget.isMatched9 = false;
      widget.wrong9 = true;
    }
    if (my_words[10] == 'في') {
      widget.isMatched10 = true;
      widget.correct10 = true;
    }
    if (my_words[10] != 'في') {
      widget.isMatched10 = false;
      widget.wrong10 = true;
    }
    if (my_words[11] == 'السباق') {
      widget.isMatched11 = true;
      widget.correct11 = true;
    }
    if (my_words[11] != 'السباق') {
      widget.isMatched11 = false;
      widget.wrong11 = true;
    }
    if (my_words[12] == 'فلحقت') {
      widget.isMatched12 = true;
      widget.correct12 = true;
    }
    if (my_words[12] != 'فلحقت') {
      widget.isMatched12 = false;
      widget.wrong12 = true;
    }
    if (my_words[13] == 'بالارنب') {
      widget.isMatched13 = true;
      widget.correct13 = true;
    }
    if (my_words[13] != 'بالارنب') {
      widget.isMatched13 = false;
      widget.wrong13 = true;
    }
    if (my_words[14] == 'وسبقته') {
      widget.isMatched14 = true;
      widget.correct14 = true;
      _Next();
    }
    if (my_words[14] != 'وسبقته') {
      widget.isMatched14 = false;
      widget.wrong14 = true;

      _Next();
    } else {
      print('Finished');
    }
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
  }

  void errorHandler() => activateSpeechRecognizer();

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => BandG8(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class Content_7 extends StatelessWidget {
  String text1;
  bool? correct;
  bool? correct1;
  bool? correct2;
  bool? correct3;
  bool? correct4;
  bool? correct5;
  bool? correct6;
  bool? correct7;
  bool? correct8;
  bool? correct9;
  bool? correct10;
  bool? correct11;
  bool? correct12;
  bool? correct13;
  bool? correct14;
  bool? correct15;
  bool? correct16;

  bool? wrong;
  bool? wrong1;
  bool? wrong2;
  bool? wrong3;
  bool? wrong4;
  bool? wrong5;
  bool? wrong6;
  bool? wrong7;
  bool? wrong8;
  bool? wrong9;
  bool? wrong10;
  bool? wrong11;
  bool? wrong12;
  bool? wrong13;
  bool? wrong14;
  bool? wrong15;
  bool? wrong16;

  bool? isMatched;
  bool? isMatched1;
  bool? isMatched2;
  bool? isMatched3;
  bool? isMatched4;
  bool? isMatched5;
  bool? isMatched6;
  bool? isMatched7;
  bool? isMatched8;
  bool? isMatched9;
  bool? isMatched10;
  bool? isMatched11;
  bool? isMatched12;
  bool? isMatched13;
  bool? isMatched14;
  bool? isMatched15;
  bool? isMatched16;

  Content_7({
    Key? key,
    required this.text1,
    required this.correct,
    required this.correct1,
    required this.correct2,
    required this.correct3,
    required this.correct4,
    required this.correct5,
    required this.correct6,
    required this.correct7,
    required this.correct8,
    required this.correct9,
    required this.correct10,
    required this.correct11,
    required this.correct12,
    required this.correct13,
    required this.correct14,
    required this.correct15,
    required this.correct16,
    required this.wrong,
    required this.wrong1,
    required this.wrong2,
    required this.wrong3,
    required this.wrong4,
    required this.wrong5,
    required this.wrong6,
    required this.wrong7,
    required this.wrong8,
    required this.wrong9,
    required this.wrong10,
    required this.wrong11,
    required this.wrong12,
    required this.wrong13,
    required this.wrong14,
    required this.wrong15,
    required this.wrong16,
    required this.isMatched,
    required this.isMatched1,
    required this.isMatched2,
    required this.isMatched3,
    required this.isMatched4,
    required this.isMatched5,
    required this.isMatched6,
    required this.isMatched7,
    required this.isMatched8,
    required this.isMatched9,
    required this.isMatched10,
    required this.isMatched11,
    required this.isMatched12,
    required this.isMatched13,
    required this.isMatched14,
    required this.isMatched15,
    required this.isMatched16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    var colored_text = text1.toString().split(" ");

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(
          left: 5,
        ),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      colored_text[0],
                      style: TextStyle(
                          color: isMatched == true
                              ? Colors.green
                              : isMatched == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[1],
                      style: TextStyle(
                          color: isMatched1 == true
                              ? Colors.green
                              : isMatched1 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[2],
                      style: TextStyle(
                          color: isMatched2 == true
                              ? Colors.green
                              : isMatched2 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[3],
                      style: TextStyle(
                          color: isMatched3 == true
                              ? Colors.green
                              : isMatched3 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[4],
                      style: TextStyle(
                          color: isMatched4 == true
                              ? Colors.green
                              : isMatched4 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[5],
                      style: TextStyle(
                          color: isMatched5 == true
                              ? Colors.green
                              : isMatched5 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      colored_text[6],
                      style: TextStyle(
                          color: isMatched6 == true
                              ? Colors.green
                              : isMatched6 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[7],
                      style: TextStyle(
                          color: isMatched7 == true
                              ? Colors.green
                              : isMatched7 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[8],
                      style: TextStyle(
                          color: isMatched8 == true
                              ? Colors.green
                              : isMatched8 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[9],
                      style: TextStyle(
                          color: isMatched9 == true
                              ? Colors.green
                              : isMatched9 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[10],
                      style: TextStyle(
                          color: isMatched10 == true
                              ? Colors.green
                              : isMatched10 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                  ],
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  SizedBox(
                    width: currentHeight / 13,
                  ),
                  Text(
                    colored_text[11],
                    style: TextStyle(
                        color: isMatched11 == true
                            ? Colors.green
                            : isMatched11 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                  Text(
                    colored_text[12],
                    style: TextStyle(
                        color: isMatched12 == true
                            ? Colors.green
                            : isMatched12 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                  Text(
                    colored_text[13],
                    style: TextStyle(
                        color: isMatched13 == true
                            ? Colors.green
                            : isMatched13 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    colored_text[14],
                    style: TextStyle(
                        color: isMatched14 == true
                            ? Colors.green
                            : isMatched14 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BandG8 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;

  bool? correct;
  bool? correct1;
  bool? correct2;
  bool? correct3;
  bool? correct4;
  bool? correct5;
  bool? correct6;
  bool? correct7;
  bool? correct8;
  bool? correct9;
  bool? correct10;
  bool? correct11;
  bool? correct12;
  bool? correct13;
  bool? correct14;
  bool? correct15;
  bool? correct16;
  bool? correct17;
  bool? correct18;
  bool? correct19;
  bool? correct20;

  bool? wrong;
  bool? wrong1;
  bool? wrong2;
  bool? wrong3;
  bool? wrong4;
  bool? wrong5;
  bool? wrong6;
  bool? wrong7;
  bool? wrong8;
  bool? wrong9;
  bool? wrong10;
  bool? wrong11;
  bool? wrong12;
  bool? wrong13;
  bool? wrong14;
  bool? wrong15;
  bool? wrong16;
  bool? wrong17;
  bool? wrong18;
  bool? wrong19;
  bool? wrong20;

  bool? isMatched;
  bool? isMatched1;
  bool? isMatched2;
  bool? isMatched3;
  bool? isMatched4;
  bool? isMatched5;
  bool? isMatched6;
  bool? isMatched7;
  bool? isMatched8;
  bool? isMatched9;
  bool? isMatched10;
  bool? isMatched11;
  bool? isMatched12;
  bool? isMatched13;
  bool? isMatched14;
  bool? isMatched15;
  bool? isMatched16;
  bool? isMatched17;
  bool? isMatched18;
  bool? isMatched19;
  bool? isMatched20;

  BandG8(
      {Key? key,
      required this.childID,
      required this.currentAvatar,
      required this.currentName})
      : super(key: key);
  @override
  _BandG8State createState() => _BandG8State();
}

class _BandG8State extends State<BandG8> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  String _currentLocale = 'ar_Ar';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();

    // matchingWords();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_BandGState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('ar_Ar').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    //these lines of code to make the screen in horizontal state
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidht = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('imgs/stories_imgs/bears8'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white.withOpacity(0.7),
                    ),
                    height: currentHeight / 2.5,
                    width: currentWidht / 1.4,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('Stories')
                          .where('ID', isEqualTo: 'Sy_Three_Bears_And_Girl')
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, i) {
                              var content =
                                  snapshot.data!.docs[i].get('Text')[7];

                              list.add(content);

                              return Content_8(
                                text1: content.toString(),
                                correct: widget.correct,
                                correct1: widget.correct1,
                                correct2: widget.correct2,
                                correct3: widget.correct3,
                                correct4: widget.correct4,
                                correct5: widget.correct5,
                                correct6: widget.correct6,
                                correct7: widget.correct7,
                                correct8: widget.correct8,
                                correct9: widget.correct9,
                                correct10: widget.correct10,
                                correct11: widget.correct11,
                                correct12: widget.correct12,
                                correct13: widget.correct13,
                                correct14: widget.correct14,
                                correct15: widget.correct15,
                                correct16: widget.correct16,
                                correct17: widget.correct17,
                                correct18: widget.correct18,
                                correct19: widget.correct19,
                                correct20: widget.correct20,
                                wrong: widget.wrong,
                                wrong1: widget.wrong1,
                                wrong2: widget.wrong2,
                                wrong3: widget.wrong3,
                                wrong4: widget.wrong4,
                                wrong5: widget.wrong5,
                                wrong6: widget.wrong6,
                                wrong7: widget.wrong7,
                                wrong8: widget.wrong8,
                                wrong9: widget.wrong9,
                                wrong10: widget.wrong10,
                                wrong11: widget.wrong11,
                                wrong12: widget.wrong12,
                                wrong13: widget.wrong13,
                                wrong14: widget.wrong14,
                                wrong15: widget.wrong15,
                                wrong16: widget.wrong16,
                                wrong17: widget.wrong17,
                                wrong18: widget.wrong18,
                                wrong19: widget.wrong19,
                                wrong20: widget.wrong20,
                                isMatched: widget.isMatched,
                                isMatched1: widget.isMatched1,
                                isMatched2: widget.isMatched2,
                                isMatched3: widget.isMatched3,
                                isMatched4: widget.isMatched4,
                                isMatched5: widget.isMatched5,
                                isMatched6: widget.isMatched6,
                                isMatched7: widget.isMatched7,
                                isMatched8: widget.isMatched8,
                                isMatched9: widget.isMatched9,
                                isMatched10: widget.isMatched10,
                                isMatched11: widget.isMatched11,
                                isMatched12: widget.isMatched12,
                                isMatched13: widget.isMatched13,
                                isMatched14: widget.isMatched14,
                                isMatched15: widget.isMatched15,
                                isMatched16: widget.isMatched16,
                                isMatched17: widget.isMatched17,
                                isMatched18: widget.isMatched18,
                                isMatched19: widget.isMatched19,
                                isMatched20: widget.isMatched20,
                              );
                            },
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => BandG2(
                      //       childID: widget.childID,
                      //       currentAvatar: widget.currentAvatar,
                      //       currentName: widget.currentName,
                      //     ),
                      //   ),
                      //   (Route<dynamic> route) => false,
                      // );
                    },
                    child: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 28,
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: currentHeight / 28,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BandG7(
                            childID: widget.childID,
                            currentAvatar: widget.currentAvatar,
                            currentName: widget.currentName,
                          ),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 28,
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: currentHeight / 28,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: currentHeight / 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_speechRecognitionAvailable && !_isListening) {
                        start();
                      }
                      null;
                    },
                    child: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 16,
                      child: Icon(
                        _isListening ? Icons.mic : Icons.mic_off,
                        color: Colors.white,
                        size: currentHeight / 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Home(
                              childID: widget.childID,
                              currentAvatar: widget.currentAvatar,
                              currentName: widget.currentName,
                            ),
                          ),
                          (Route<dynamic> route) => false);
                    },
                    child: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 16,
                      child: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: currentHeight / 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(
                        () {
                          print('tapped');
                          // if (play == true) {
                          //   play = false;
                          // } else {
                          //   if (play == false) {
                          //     play = true;
                          //   }
                          // }
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: currentHeight / 16,
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      child: Icon(
                        Icons.volume_up,
                        color: Colors.white,
                        size: currentHeight / 14,
                      ),
                    ),
                  ),
                ],
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('Statistics')
                    .doc(_auth.currentUser!.email)
                    .collection('children')
                    .doc(widget.currentName)
                    .collection('words_of_story ')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator(); //If no data return this
                  }

                  final information = snapshot.data!
                      .docs; //information: stores gets the data from firebase documents

                  for (var item in information) {
                    final getCS =
                        item.data().toString().contains('correct_WordsStory')
                            ? item.get('correct_WordsStory')
                            : 0;
                    final getWS =
                        item.data().toString().contains('wrong_WordsStory')
                            ? item.get('wrong_WordsStory')
                            : 0;

                    Counter.correctStoryCounter = getCS;
                    Counter.wrongStoryCounter = getWS;
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_BandGState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_BandGState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_BandGState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
    dynamic my_words = text.toString().split(" ");

    if (my_words[0] == 'استيقظ') {
      widget.isMatched = true;
      widget.correct = true;
    }
    if (my_words[0] != 'استيقظ') {
      widget.isMatched = false;
      widget.wrong = true;
    }
    if (my_words[1] == 'الارنب') {
      widget.isMatched1 = true;
      widget.correct1 = true;
    }
    if (my_words[1] != 'الارنب') {
      widget.isMatched1 = false;
      widget.wrong1 = true;
    }
    if (my_words[2] == 'من') {
      widget.isMatched2 = true;
      widget.correct2 = true;
    }
    if (my_words[2] != 'من') {
      widget.isMatched2 = false;
      widget.wrong2 = true;
    }
    if (my_words[3] == 'نومه') {
      widget.isMatched3 = true;
      widget.correct3 = true;
    }
    if (my_words[3] != 'نومه') {
      widget.isMatched3 = false;
      widget.wrong3 = true;
    }
    if (my_words[4] == 'متاخرا') {
      widget.isMatched4 = true;
      widget.correct4 = true;
    }
    if (my_words[4] != 'متاخرا') {
      widget.isMatched4 = false;
      widget.wrong4 = true;
    }
    if (my_words[5] == 'وراح') {
      widget.isMatched5 = true;
      widget.correct5 = true;
    }
    if (my_words[5] != 'وراح') {
      widget.isMatched5 = false;
      widget.wrong5 = true;
    }
    if (my_words[6] == 'يجري') {
      widget.isMatched6 = true;
      widget.correct6 = true;
    }
    if (my_words[6] != 'يجري') {
      widget.isMatched6 = false;
      widget.wrong6 = true;
    }
    if (my_words[7] == 'ويقفز') {
      widget.isMatched7 = true;
      widget.correct7 = true;
    }
    if (my_words[7] != 'ويقفز') {
      widget.isMatched7 = false;
      widget.wrong7 = true;
    }
    if (my_words[8] == 'بسرعه') {
      widget.isMatched8 = true;
      widget.correct8 = true;
    }
    if (my_words[8] != 'بسرعه') {
      widget.isMatched8 = false;
      widget.wrong8 = true;
    }
    if (my_words[9] == 'لكي') {
      widget.isMatched9 = true;
      widget.correct9 = true;
    }
    if (my_words[9] != 'لكي') {
      widget.isMatched9 = false;
      widget.wrong9 = true;
    }
    if (my_words[10] == 'يصل') {
      widget.isMatched10 = true;
      widget.correct10 = true;
    }
    if (my_words[10] != 'يصل') {
      widget.isMatched10 = false;
      widget.wrong10 = true;
    }
    if (my_words[11] == 'الى') {
      widget.isMatched11 = true;
      widget.correct11 = true;
    }
    if (my_words[11] != 'الى') {
      widget.isMatched11 = false;
      widget.wrong11 = true;
    }
    if (my_words[12] == 'نهايه') {
      widget.isMatched12 = true;
      widget.correct12 = true;
    }
    if (my_words[12] != 'نهايه') {
      widget.isMatched12 = false;
      widget.wrong12 = true;
    }
    if (my_words[13] == 'السباق') {
      widget.isMatched13 = true;
      widget.correct13 = true;
    }
    if (my_words[13] != 'السباق') {
      widget.isMatched13 = false;
      widget.wrong13 = true;
    }
    if (my_words[14] == 'ولكنه') {
      widget.isMatched14 = true;
      widget.correct14 = true;
    }
    if (my_words[14] != 'ولكنه') {
      widget.isMatched14 = false;
      widget.wrong14 = true;
    }
    if (my_words[15] == 'وجد') {
      widget.isMatched15 = true;
      widget.correct15 = true;
    }
    if (my_words[15] != 'وجد') {
      widget.isMatched15 = false;
      widget.wrong15 = true;
    }
    if (my_words[16] == 'السلحفاه') {
      widget.isMatched16 = true;
      widget.correct16 = true;
    }
    if (my_words[16] != 'السلحفاه') {
      widget.isMatched16 = false;
      widget.wrong16 = true;
    }
    if (my_words[17] == 'النشيطه') {
      widget.isMatched17 = true;
      widget.correct17 = true;
    }
    if (my_words[17] != 'النشيطه') {
      widget.isMatched17 = false;
      widget.wrong17 = true;
    }
    if (my_words[18] == 'قد') {
      widget.isMatched18 = true;
      widget.correct18 = true;
    }
    if (my_words[18] != 'قد') {
      widget.isMatched18 = false;
      widget.wrong18 = true;
    }
    if (my_words[19] == 'فازت') {
      widget.isMatched19 = true;
      widget.correct19 = true;
    }
    if (my_words[19] != 'فازت') {
      widget.isMatched19 = false;
      widget.wrong19 = true;
    }
    if (my_words[20] == 'بالسباق') {
      widget.isMatched20 = true;
      widget.correct20 = true;
      _Next();
    }
    if (my_words[20] != 'بالسباق') {
      widget.isMatched20 = false;
      widget.wrong20 = true;
      _Next();
    } else {
      print('Finished');
    }
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
  }

  void errorHandler() => activateSpeechRecognizer();

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Congrats(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class Content_8 extends StatelessWidget {
  String text1;
  bool? correct;
  bool? correct1;
  bool? correct2;
  bool? correct3;
  bool? correct4;
  bool? correct5;
  bool? correct6;
  bool? correct7;
  bool? correct8;
  bool? correct9;
  bool? correct10;
  bool? correct11;
  bool? correct12;
  bool? correct13;
  bool? correct14;
  bool? correct15;
  bool? correct16;
  bool? correct17;
  bool? correct18;
  bool? correct19;
  bool? correct20;

  bool? wrong;
  bool? wrong1;
  bool? wrong2;
  bool? wrong3;
  bool? wrong4;
  bool? wrong5;
  bool? wrong6;
  bool? wrong7;
  bool? wrong8;
  bool? wrong9;
  bool? wrong10;
  bool? wrong11;
  bool? wrong12;
  bool? wrong13;
  bool? wrong14;
  bool? wrong15;
  bool? wrong16;
  bool? wrong17;
  bool? wrong18;
  bool? wrong19;
  bool? wrong20;

  bool? isMatched;
  bool? isMatched1;
  bool? isMatched2;
  bool? isMatched3;
  bool? isMatched4;
  bool? isMatched5;
  bool? isMatched6;
  bool? isMatched7;
  bool? isMatched8;
  bool? isMatched9;
  bool? isMatched10;
  bool? isMatched11;
  bool? isMatched12;
  bool? isMatched13;
  bool? isMatched14;
  bool? isMatched15;
  bool? isMatched16;
  bool? isMatched17;
  bool? isMatched18;
  bool? isMatched19;
  bool? isMatched20;

  Content_8({
    Key? key,
    required this.text1,
    required this.correct,
    required this.correct1,
    required this.correct2,
    required this.correct3,
    required this.correct4,
    required this.correct5,
    required this.correct6,
    required this.correct7,
    required this.correct8,
    required this.correct9,
    required this.correct10,
    required this.correct11,
    required this.correct12,
    required this.correct13,
    required this.correct14,
    required this.correct15,
    required this.correct16,
    required this.correct17,
    required this.correct18,
    required this.correct19,
    required this.correct20,
    required this.wrong,
    required this.wrong1,
    required this.wrong2,
    required this.wrong3,
    required this.wrong4,
    required this.wrong5,
    required this.wrong6,
    required this.wrong7,
    required this.wrong8,
    required this.wrong9,
    required this.wrong10,
    required this.wrong11,
    required this.wrong12,
    required this.wrong13,
    required this.wrong14,
    required this.wrong15,
    required this.wrong16,
    required this.wrong17,
    required this.wrong18,
    required this.wrong19,
    required this.wrong20,
    required this.isMatched,
    required this.isMatched1,
    required this.isMatched2,
    required this.isMatched3,
    required this.isMatched4,
    required this.isMatched5,
    required this.isMatched6,
    required this.isMatched7,
    required this.isMatched8,
    required this.isMatched9,
    required this.isMatched10,
    required this.isMatched11,
    required this.isMatched12,
    required this.isMatched13,
    required this.isMatched14,
    required this.isMatched15,
    required this.isMatched16,
    required this.isMatched17,
    required this.isMatched18,
    required this.isMatched19,
    required this.isMatched20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    var colored_text = text1.toString().split(" ");

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(
          left: 5,
        ),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      colored_text[0],
                      style: TextStyle(
                          color: isMatched == true
                              ? Colors.green
                              : isMatched == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[1],
                      style: TextStyle(
                          color: isMatched1 == true
                              ? Colors.green
                              : isMatched1 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[2],
                      style: TextStyle(
                          color: isMatched2 == true
                              ? Colors.green
                              : isMatched2 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[3],
                      style: TextStyle(
                          color: isMatched3 == true
                              ? Colors.green
                              : isMatched3 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[4],
                      style: TextStyle(
                          color: isMatched4 == true
                              ? Colors.green
                              : isMatched4 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[5],
                      style: TextStyle(
                          color: isMatched5 == true
                              ? Colors.green
                              : isMatched5 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      colored_text[6],
                      style: TextStyle(
                          color: isMatched6 == true
                              ? Colors.green
                              : isMatched6 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[7],
                      style: TextStyle(
                          color: isMatched7 == true
                              ? Colors.green
                              : isMatched7 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[8],
                      style: TextStyle(
                          color: isMatched8 == true
                              ? Colors.green
                              : isMatched8 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[9],
                      style: TextStyle(
                          color: isMatched9 == true
                              ? Colors.green
                              : isMatched9 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[10],
                      style: TextStyle(
                          color: isMatched10 == true
                              ? Colors.green
                              : isMatched10 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[11],
                      style: TextStyle(
                          color: isMatched11 == true
                              ? Colors.green
                              : isMatched11 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      colored_text[12],
                      style: TextStyle(
                          color: isMatched12 == true
                              ? Colors.green
                              : isMatched12 == false
                                  ? Colors.red
                                  : Colors.black,
                          fontSize: currentHeight / 22),
                    ),
                  ],
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  SizedBox(
                    width: currentHeight / 44,
                  ),
                  Text(
                    colored_text[13],
                    style: TextStyle(
                        color: isMatched13 == true
                            ? Colors.green
                            : isMatched13 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    colored_text[14],
                    style: TextStyle(
                        color: isMatched14 == true
                            ? Colors.green
                            : isMatched14 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    colored_text[15],
                    style: TextStyle(
                        color: isMatched15 == true
                            ? Colors.green
                            : isMatched15 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                  Text(
                    colored_text[16],
                    style: TextStyle(
                        color: isMatched16 == true
                            ? Colors.green
                            : isMatched16 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    colored_text[17],
                    style: TextStyle(
                        color: isMatched17 == true
                            ? Colors.green
                            : isMatched17 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    colored_text[18],
                    style: TextStyle(
                        color: isMatched18 == true
                            ? Colors.green
                            : isMatched18 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                ],
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                textDirection: TextDirection.rtl,
                children: [
                  SizedBox(
                    width: currentHeight / 5,
                  ),
                  Text(
                    colored_text[19],
                    style: TextStyle(
                        color: isMatched19 == true
                            ? Colors.green
                            : isMatched19 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    colored_text[20],
                    style: TextStyle(
                        color: isMatched20 == true
                            ? Colors.green
                            : isMatched14 == false
                                ? Colors.red
                                : Colors.black,
                        fontSize: currentHeight / 22),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
