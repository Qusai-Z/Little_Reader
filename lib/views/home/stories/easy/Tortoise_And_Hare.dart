// ignore_for_file: non_constant_identifier_names

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:little_reader/views/home/letters/letters.dart';

import '../../home.dart';

List<String> list = [];

const languages = [
  Language('Arabic', 'ar-Ar'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class TandH extends StatefulWidget {
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

  TandH(
      {Key? key,
      required this.childID,
      required this.currentAvatar,
      required this.currentName})
      : super(key: key);
  @override
  _TandHState createState() => _TandHState();
}

class _TandHState extends State<TandH> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  bool play = false;
  bool play_button = false;
  bool play_bird_sound = true;
  var transcription = '';

  String _currentLocale = 'ar_Ar';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();

    setState(() {
      play = true;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TandHState.activateSpeechRecognizer... ');
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
          body: AudioWidget.assets(
            path: 'audios/audio0.mp3',
            play: play,
            volume: 2,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/little-reader-efa14.appspot.com/o/Stories%2FSy_Tortoise_And_Hare%2FImages%2F1.jpeg?alt=media'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AudioWidget.assets(
                        path: 'audios/birds.mp3',
                        play: play_bird_sound,
                        volume: 0.1,
                        loopMode: LoopMode.playlist,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.7),
                          ),
                          height: currentHeight / 2.5,
                          width: currentWidht / 1.4,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('Stories')
                                .where('ID', isEqualTo: 'Sy_Tortoise_And_Hare')
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
                              builder: (context) => TandH2(
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
                      AudioWidget.assets(
                        path: 'audios/audio0.mp3',
                        play: play_button,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              if (play == true) {
                                play = false;
                              } else {
                                if (play == false) {
                                  play = true;
                                }
                              }
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          splashColor: Colors.amber,
                          child: CircleAvatar(
                            radius: currentHeight / 16,
                            backgroundColor:
                                const Color.fromRGBO(245, 171, 0, 1),
                            child: Icon(
                              Icons.volume_up,
                              color: Colors.white,
                              size: currentHeight / 14,
                            ),
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

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_TandHState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TandHState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TandHState.onRecognitionResult... $text');

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
    if (my_words[1] == 'الغابه') {
      widget.isMatched1 = true;
      widget.correct1 = true;
    }
    if (my_words[1] != 'الغابه') {
      widget.isMatched1 = false;
      widget.wrong1 = true;
    }
    if (my_words[2] == 'راى') {
      widget.isMatched2 = true;
      widget.correct2 = true;
    }
    if (my_words[2] != 'راى') {
      widget.isMatched2 = false;
      widget.wrong2 = true;
    }
    if (my_words[3] == 'الارنب') {
      widget.isMatched3 = true;
      widget.correct3 = true;
    }
    if (my_words[3] != 'الارنب') {
      widget.isMatched3 = false;
      widget.wrong3 = true;
    }
    if (my_words[4] == 'المغرور') {
      widget.isMatched4 = true;
      widget.correct4 = true;
    }
    if (my_words[4] != 'المغرور') {
      widget.isMatched4 = false;
      widget.wrong4 = true;
    }
    if (my_words[5] == 'السلحفاه') {
      widget.isMatched5 = true;
      widget.correct5 = true;
    }
    if (my_words[5] != 'السلحفاه') {
      widget.isMatched5 = false;
      widget.wrong5 = true;
    }
    if (my_words[6] == 'فتعجب') {
      widget.isMatched6 = true;
      widget.correct6 = true;
    }
    if (my_words[6] != 'فتعجب') {
      widget.isMatched6 = false;
      widget.wrong6 = true;
    }
    if (my_words[7] == 'من') {
      widget.isMatched7 = true;
      widget.correct7 = true;
    }
    if (my_words[7] != 'من') {
      widget.isMatched7 = false;
      widget.wrong7 = true;
    }
    if (my_words[8] == 'مشيها') {
      widget.isMatched8 = true;
      widget.correct8 = true;
    }
    if (my_words[8] != 'مشيها') {
      widget.isMatched8 = false;
      widget.wrong8 = true;
    }
    if (my_words[9] == 'البطيء') {
      widget.isMatched9 = true;
      widget.correct9 = true;
    }
    if (my_words[9] != 'البطيء') {
      widget.isMatched9 = false;
      widget.wrong9 = true;
    }
    if (my_words[10] == 'فهو') {
      widget.isMatched10 = true;
      widget.correct10 = true;
    }
    if (my_words[10] != 'فهو') {
      widget.isMatched10 = false;
      widget.wrong10 = true;
    }
    if (my_words[11] == 'كما') {
      widget.isMatched11 = true;
      widget.correct11 = true;
    }
    if (my_words[11] != 'كما') {
      widget.isMatched11 = false;
      widget.wrong11 = true;
    }
    if (my_words[12] == 'نعرف') {
      widget.isMatched12 = true;
      widget.correct12 = true;
    }
    if (my_words[12] != 'نعرف') {
      widget.isMatched12 = false;
      widget.wrong12 = true;
    }
    if (my_words[13] == 'سريع') {
      widget.isMatched13 = true;
      widget.correct13 = true;
    }
    if (my_words[13] != 'سريع') {
      widget.isMatched13 = false;
      widget.wrong13 = true;
    }
    if (my_words[14] == 'الحركه') {
      widget.isMatched14 = true;
      widget.correct14 = true;
    }
    if (my_words[14] != 'الحركه') {
      widget.isMatched14 = false;
      widget.wrong14 = true;
    }
    if (my_words[15] == 'والجري') {
      widget.isMatched15 = true;
      widget.correct15 = true;
    }
    if (my_words[15] != 'والجري') {
      widget.isMatched15 = false;
      widget.wrong15 = true;
    }
    if (my_words[16] == 'والقفز') {
      widget.isMatched16 = true;
      widget.correct16 = true;
      _Next();
    }
    if (my_words[16] != 'والقفز') {
      widget.isMatched16 = false;
      widget.wrong16 = true;
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
            builder: (context) => TandH2(
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
                  textDirection: TextDirection.rtl,
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
                textDirection: TextDirection.rtl,
                children: [
                  SizedBox(
                    width: currentHeight / 9,
                  ),
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
        ),
      ),
    );
  }
}

class TandH2 extends StatefulWidget {
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

  TandH2(
      {Key? key,
      required this.childID,
      required this.currentAvatar,
      required this.currentName})
      : super(key: key);
  @override
  _TandH2State createState() => _TandH2State();
}

class _TandH2State extends State<TandH2> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  bool play = false;
  bool play_button = false;
  bool play_birds_sound = true;
  var transcription = '';

  String _currentLocale = 'ar_Ar';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();

    setState(() {
      play = true;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TandH2State.activateSpeechRecognizer... ');
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
      home: AudioWidget.assets(
        path: 'audios/audio1.mp3',
        play: play,
        volume: 2,
        child: SafeArea(
          child: Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/little-reader-efa14.appspot.com/o/Stories%2FSy_Tortoise_And_Hare%2FImages%2F2.jpeg?alt=media'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AudioWidget.assets(
                        path: 'audios/birds.mp3',
                        volume: 0.1,
                        play: play_birds_sound,
                        loopMode: LoopMode.playlist,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.7),
                          ),
                          height: currentHeight / 2.5,
                          width: currentWidht / 1.4,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('Stories')
                                .where('ID', isEqualTo: 'Sy_Tortoise_And_Hare')
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
                              builder: (context) => TandH3(
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
                              builder: (context) => TandH(
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
                      AudioWidget.assets(
                        path: 'audios/audio0.mp3',
                        play: play_button,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              if (play == true) {
                                play = false;
                              } else {
                                if (play == false) {
                                  play = true;
                                }
                              }
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          splashColor: Colors.amber,
                          child: CircleAvatar(
                            radius: currentHeight / 16,
                            backgroundColor:
                                const Color.fromRGBO(245, 171, 0, 1),
                            child: Icon(
                              Icons.volume_up,
                              color: Colors.white,
                              size: currentHeight / 14,
                            ),
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

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_TandH2State.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TandH2State.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TandH2State.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
    dynamic my_words = text.toString().split(" ");

    if (my_words[0] == 'قالت') {
      widget.isMatched = true;
      widget.correct = true;
    }
    if (my_words[0] != 'قالت') {
      widget.isMatched = false;
      widget.wrong = true;
    }
    if (my_words[1] == 'السلحفاه') {
      widget.isMatched1 = true;
      widget.correct1 = true;
    }
    if (my_words[1] != 'السلحفاه') {
      widget.isMatched1 = false;
      widget.wrong1 = true;
    }
    if (my_words[2] == 'للارنب') {
      widget.isMatched2 = true;
      widget.correct2 = true;
    }
    if (my_words[2] != 'للارنب') {
      widget.isMatched2 = false;
      widget.wrong2 = true;
    }
    if (my_words[3] == 'المغرور') {
      widget.isMatched3 = true;
      widget.correct3 = true;
    }
    if (my_words[3] != 'المغرور') {
      widget.isMatched3 = false;
      widget.wrong3 = true;
    }
    if (my_words[4] == 'انا') {
      widget.isMatched4 = true;
      widget.correct4 = true;
    }
    if (my_words[4] != 'انا') {
      widget.isMatched4 = false;
      widget.wrong4 = true;
    }
    if (my_words[5] == 'بطيئه') {
      widget.isMatched5 = true;
      widget.correct5 = true;
    }
    if (my_words[5] != 'بطيئه') {
      widget.isMatched5 = false;
      widget.wrong5 = true;
    }
    if (my_words[6] == 'المشي') {
      widget.isMatched6 = true;
      widget.correct6 = true;
    }
    if (my_words[6] != 'المشي') {
      widget.isMatched6 = false;
      widget.wrong6 = true;
    }
    if (my_words[7] == 'ولكني') {
      widget.isMatched7 = true;
      widget.correct7 = true;
    }
    if (my_words[7] != 'ولكني') {
      widget.isMatched7 = false;
      widget.wrong7 = true;
    }
    if (my_words[8] == 'نشيطه') {
      widget.isMatched8 = true;
      widget.correct8 = true;
    }
    if (my_words[8] != 'نشيطه') {
      widget.isMatched8 = false;
      widget.wrong8 = true;
    }
    if (my_words[9] == 'واستطيع') {
      widget.isMatched9 = true;
      widget.correct9 = true;
    }
    if (my_words[9] != 'واستطيع') {
      widget.isMatched9 = false;
      widget.wrong9 = true;
    }
    if (my_words[10] == 'انهاء') {
      widget.isMatched10 = true;
      widget.correct10 = true;
    }
    if (my_words[10] != 'انهاء') {
      widget.isMatched10 = false;
      widget.wrong10 = true;
    }
    if (my_words[11] == 'كل') {
      widget.isMatched11 = true;
      widget.correct11 = true;
    }
    if (my_words[11] != 'كل') {
      widget.isMatched11 = false;
      widget.wrong11 = true;
    }
    if (my_words[12] == 'اعمالي') {
      widget.isMatched12 = true;
      widget.correct12 = true;
    }
    if (my_words[12] != 'اعمالي') {
      widget.isMatched12 = false;
      widget.wrong12 = true;
    }
    if (my_words[13] == 'بجد') {
      widget.isMatched13 = true;
      widget.correct13 = true;
    }
    if (my_words[13] != 'بجد') {
      widget.isMatched13 = false;
      widget.wrong13 = true;
    }
    if (my_words[14] == 'ونشاط') {
      widget.isMatched14 = true;
      widget.correct14 = true;
    }
    if (my_words[14] != 'ونشاط') {
      widget.isMatched14 = false;
      widget.wrong14 = true;
    }
    if (my_words[15] == 'فضحك') {
      widget.isMatched15 = true;
      widget.correct15 = true;
    }
    if (my_words[15] != 'فضحك') {
      widget.isMatched15 = false;
      widget.wrong15 = true;
    }
    if (my_words[16] == 'الارنب') {
      widget.isMatched16 = true;
      widget.correct16 = true;
    }
    if (my_words[16] != 'الارنب') {
      widget.isMatched16 = false;
      widget.wrong16 = true;
    }
    if (my_words[17] == 'من') {
      widget.isMatched17 = true;
      widget.correct17 = true;
    }
    if (my_words[17] != 'من') {
      widget.isMatched17 = false;
      widget.wrong17 = true;
    }
    if (my_words[18] == 'كلامها') {
      widget.isMatched18 = true;
      widget.correct18 = true;
      _Next();
    }
    if (my_words[18] != 'كلامها') {
      widget.isMatched18 = false;
      widget.wrong18 = true;
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
            builder: (context) => TandH3(
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
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  SizedBox(width: currentHeight / 4),
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
          ],
        ),
      ),
    );
  }
}

class TandH3 extends StatefulWidget {
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

  TandH3(
      {Key? key,
      required this.childID,
      required this.currentAvatar,
      required this.currentName})
      : super(key: key);
  @override
  _TandH3State createState() => _TandH3State();
}

class _TandH3State extends State<TandH3> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  bool play = false;
  bool play_button = false;
  bool play_birds_sound = true;
  var transcription = '';

  String _currentLocale = 'ar_Ar';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();

    setState(() {
      play = true;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TandH2State.activateSpeechRecognizer... ');
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
        child: AudioWidget.assets(
          path: '/audios/audio2.mp3',
          volume: 2.0,
          play: play,
          child: Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/little-reader-efa14.appspot.com/o/Stories%2FSy_Tortoise_And_Hare%2FImages%2F3.jpeg?alt=media'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AudioWidget.assets(
                    path: 'audios/birds.mp3',
                    play: play_birds_sound,
                    volume: 0.1,
                    loopMode: LoopMode.playlist,
                    child: Row(
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
                                .where('ID', isEqualTo: 'Sy_Tortoise_And_Hare')
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TandH4(
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
                              builder: (context) => TandH2(
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
                      AudioWidget.assets(
                        path: 'audios/audio2.mp3', //t33
                        play: play_button,
                        volume: 2.0,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              if (play == true) {
                                play = false;
                              } else {
                                if (play == false) {
                                  play = true;
                                }
                              }
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          splashColor: Colors.amber,
                          child: CircleAvatar(
                            radius: currentHeight / 16,
                            backgroundColor:
                                const Color.fromRGBO(245, 171, 0, 1),
                            child: Icon(
                              Icons.volume_up,
                              color: Colors.white,
                              size: currentHeight / 14,
                            ),
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

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_TandH2State.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TandH2State.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TandH2State.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
    dynamic my_words = text.toString().split(" ");

    if (my_words[0] == 'فكر') {
      widget.isMatched = true;
      widget.correct = true;
    }
    if (my_words[0] != 'فكر') {
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
    if (my_words[2] == 'قليلا') {
      widget.isMatched2 = true;
      widget.correct2 = true;
    }
    if (my_words[2] != 'قليلا') {
      widget.isMatched2 = false;
      widget.wrong2 = true;
    }
    if (my_words[3] == 'ثم') {
      widget.isMatched3 = true;
      widget.correct3 = true;
    }
    if (my_words[3] != 'ثم') {
      widget.isMatched3 = false;
      widget.wrong3 = true;
    }
    if (my_words[4] == 'قال') {
      widget.isMatched4 = true;
      widget.correct4 = true;
    }
    if (my_words[4] != 'قال') {
      widget.isMatched4 = false;
      widget.wrong4 = true;
    }
    if (my_words[5] == 'للسلحفاه') {
      widget.isMatched5 = true;
      widget.correct5 = true;
    }
    if (my_words[5] != 'للسلحفاه') {
      widget.isMatched5 = false;
      widget.wrong5 = true;
    }
    if (my_words[6] == 'هيا') {
      widget.isMatched6 = true;
      widget.correct6 = true;
    }
    if (my_words[6] != 'هيا') {
      widget.isMatched6 = false;
      widget.wrong6 = true;
    }
    if (my_words[7] == 'نقوم') {
      widget.isMatched7 = true;
      widget.correct7 = true;
    }
    if (my_words[7] != 'نقوم') {
      widget.isMatched7 = false;
      widget.wrong7 = true;
    }
    if (my_words[8] == 'بمسابقه') {
      widget.isMatched8 = true;
      widget.correct8 = true;
    }
    if (my_words[8] != 'بمسابقه') {
      widget.isMatched8 = false;
      widget.wrong8 = true;
    }
    if (my_words[9] == 'في') {
      widget.isMatched9 = true;
      widget.correct9 = true;
    }
    if (my_words[9] != 'في') {
      widget.isMatched9 = false;
      widget.wrong9 = true;
    }
    if (my_words[10] == 'الجري') {
      widget.isMatched10 = true;
      widget.correct10 = true;
    }
    if (my_words[10] != 'الجري') {
      widget.isMatched10 = false;
      widget.wrong10 = true;
    }
    if (my_words[11] == 'حتى') {
      widget.isMatched11 = true;
      widget.correct11 = true;
    }
    if (my_words[11] != 'حتى') {
      widget.isMatched11 = false;
      widget.wrong11 = true;
    }
    if (my_words[12] == 'تعرف') {
      widget.isMatched12 = true;
      widget.correct12 = true;
    }
    if (my_words[12] != 'تعرف') {
      widget.isMatched12 = false;
      widget.wrong12 = true;
    }
    if (my_words[13] == 'جميع') {
      widget.isMatched13 = true;
      widget.correct13 = true;
    }
    if (my_words[13] != 'جميع') {
      widget.isMatched13 = false;
      widget.wrong13 = true;
    }
    if (my_words[14] == 'حيوانات') {
      widget.isMatched14 = true;
      widget.correct14 = true;
    }
    if (my_words[14] != 'حيوانات') {
      widget.isMatched14 = false;
      widget.wrong14 = true;
    }
    if (my_words[15] == 'الغابه') {
      widget.isMatched15 = true;
      widget.correct15 = true;
    }
    if (my_words[15] != 'الغابه') {
      widget.isMatched15 = false;
      widget.wrong15 = true;
    }
    if (my_words[16] == 'من') {
      widget.isMatched16 = true;
      widget.correct16 = true;
    }
    if (my_words[16] != 'من') {
      widget.isMatched16 = false;
      widget.wrong16 = true;
    }
    if (my_words[17] == 'من') {
      widget.isMatched17 = true;
      widget.correct17 = true;
    }
    if (my_words[17] != 'من') {
      widget.isMatched17 = false;
      widget.wrong17 = true;
    }
    if (my_words[18] == 'الاسرع') {
      widget.isMatched18 = true;
      widget.correct18 = true;
    }
    if (my_words[18] != 'الاسرع') {
      widget.isMatched18 = false;
      widget.wrong18 = true;
    }
    if (my_words[19] == 'والانشط') {
      widget.isMatched19 = true;
      widget.correct19 = true;
    }
    if (my_words[19] != 'والانشط') {
      widget.isMatched19 = false;
      widget.wrong19 = true;
    }
    if (my_words[20] == 'فوافقت') {
      widget.isMatched20 = true;
      widget.correct20 = true;
    }
    if (my_words[20] != 'فوافقت') {
      widget.isMatched20 = false;
      widget.wrong20 = true;
    }
    if (my_words[21] == 'السلحفاه') {
      widget.isMatched21 = true;
      widget.correct21 = true;
      _Next();
    }
    if (my_words[21] != 'السلحفاه') {
      widget.isMatched21 = false;
      widget.wrong21 = true;
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
            builder: (context) => TandH4(
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
                    width: currentHeight / 16,
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
                  const SizedBox(
                    width: 3,
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
                ],
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                children: [
                  SizedBox(
                    width: currentHeight / 16,
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
                  const SizedBox(
                    width: 3,
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TandH4 extends StatefulWidget {
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

  TandH4(
      {Key? key,
      required this.childID,
      required this.currentAvatar,
      required this.currentName})
      : super(key: key);
  @override
  _TandH4State createState() => _TandH4State();
}

class _TandH4State extends State<TandH4> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  bool play = false;
  bool play_button = false;
  bool play_birds_sound = true;
  var transcription = '';

  String _currentLocale = 'ar_Ar';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();

    setState(() {
      play = true;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TandH4State.activateSpeechRecognizer... ');
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
        child: AudioWidget.assets(
          path: 'audios/audio3.mp3',
          volume: 2.0,
          play: play,
          child: Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/little-reader-efa14.appspot.com/o/Stories%2FSy_Tortoise_And_Hare%2FImages%2F4.jpeg?alt=media'),
                  fit: BoxFit.cover,
                ),
              ),
              child: AudioWidget.assets(
                path: 'audios/birds.mp3',
                volume: 0.1,
                loopMode: LoopMode.playlist,
                play: play_birds_sound,
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
                                .where('ID', isEqualTo: 'Sy_Tortoise_And_Hare')
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
                                builder: (context) => TandH5(
                                  childID: widget.childID,
                                  currentAvatar: widget.currentAvatar,
                                  currentName: widget.currentName,
                                ),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor:
                                const Color.fromRGBO(245, 171, 0, 1),
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
                                builder: (context) => TandH3(
                                  childID: widget.childID,
                                  currentAvatar: widget.currentAvatar,
                                  currentName: widget.currentName,
                                ),
                              ),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: CircleAvatar(
                            backgroundColor:
                                const Color.fromRGBO(245, 171, 0, 1),
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
                            backgroundColor:
                                const Color.fromRGBO(245, 171, 0, 1),
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
                            backgroundColor:
                                const Color.fromRGBO(245, 171, 0, 1),
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
                        AudioWidget.assets(
                          path: 'audios/audio3.mp3',
                          play: play_button,
                          volume: 2.0,
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                if (play == true) {
                                  play = false;
                                } else {
                                  if (play == false) {
                                    play = true;
                                  }
                                }
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(60),
                            ),
                            splashColor: Colors.amber,
                            child: CircleAvatar(
                              radius: currentHeight / 16,
                              backgroundColor:
                                  const Color.fromRGBO(245, 171, 0, 1),
                              child: Icon(
                                Icons.volume_up,
                                color: Colors.white,
                                size: currentHeight / 14,
                              ),
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

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_TandH4State.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TandH4State.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TandH4State.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
    dynamic my_words = text.toString().split(" ");

    if (my_words[0] == 'اجتمعت') {
      widget.isMatched = true;
      widget.correct = true;
    }
    if (my_words[0] != 'اجتمعت') {
      widget.isMatched = false;
      widget.wrong = true;
    }
    if (my_words[1] == 'كل') {
      widget.isMatched1 = true;
      widget.correct1 = true;
    }
    if (my_words[1] != 'كل') {
      widget.isMatched1 = false;
      widget.wrong1 = true;
    }
    if (my_words[2] == 'حيوانات') {
      widget.isMatched2 = true;
      widget.correct2 = true;
    }
    if (my_words[2] != 'حيوانات') {
      widget.isMatched2 = false;
      widget.wrong2 = true;
    }
    if (my_words[3] == 'الغابه') {
      widget.isMatched3 = true;
      widget.correct3 = true;
    }
    if (my_words[3] != 'الغابه') {
      widget.isMatched3 = false;
      widget.wrong3 = true;
    }
    if (my_words[4] == 'لترى') {
      widget.isMatched4 = true;
      widget.correct4 = true;
    }
    if (my_words[4] != 'لترى') {
      widget.isMatched4 = false;
      widget.wrong4 = true;
    }
    if (my_words[5] == 'السباق') {
      widget.isMatched5 = true;
      widget.correct5 = true;
    }
    if (my_words[5] != 'السباق') {
      widget.isMatched5 = false;
      widget.wrong5 = true;
    }
    if (my_words[6] == 'بين') {
      widget.isMatched6 = true;
      widget.correct6 = true;
    }
    if (my_words[6] != 'بين') {
      widget.isMatched6 = false;
      widget.wrong6 = true;
    }
    if (my_words[7] == 'الارنب') {
      widget.isMatched7 = true;
      widget.correct7 = true;
    }
    if (my_words[7] != 'الارنب') {
      widget.isMatched7 = false;
      widget.wrong7 = true;
    }
    if (my_words[8] == 'المغرور') {
      widget.isMatched8 = true;
      widget.correct8 = true;
    }
    if (my_words[8] != 'المغرور') {
      widget.isMatched8 = false;
      widget.wrong8 = true;
    }
    if (my_words[9] == 'والسلحفاه') {
      widget.isMatched9 = true;
      widget.correct9 = true;
    }
    if (my_words[9] != 'والسلحفاه') {
      widget.isMatched9 = false;
      widget.wrong9 = true;
    }
    if (my_words[10] == 'النشيطه') {
      widget.isMatched10 = true;
      widget.correct10 = true;
      _Next();
    }
    if (my_words[10] != 'النشيطه') {
      widget.isMatched10 = false;
      widget.wrong10 = true;
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
            builder: (context) => TandH5(
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
                    SizedBox(height: currentHeight / 6),
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
          ],
        ),
      ),
    );
  }
}

class TandH5 extends StatefulWidget {
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

  TandH5(
      {Key? key,
      required this.childID,
      required this.currentAvatar,
      required this.currentName})
      : super(key: key);
  @override
  _TandH5State createState() => _TandH5State();
}

class _TandH5State extends State<TandH5> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  bool play = false;
  bool play_button = false;
  bool play_birds_sound = true;
  var transcription = '';

  String _currentLocale = 'ar_Ar';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();

    setState(() {
      play = true;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TandH2State.activateSpeechRecognizer... ');
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
          body: AudioWidget.assets(
            path: 'audios/audio4.mp3',
            play: play,
            volume: 2.0,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/little-reader-efa14.appspot.com/o/Stories%2FSy_Tortoise_And_Hare%2FImages%2F5.jpeg?alt=media'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AudioWidget.assets(
                        path: 'audios/birds.mp3',
                        play: play_birds_sound,
                        volume: 0.1,
                        loopMode: LoopMode.playlist,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.7),
                          ),
                          height: currentHeight / 2.5,
                          width: currentWidht / 1.4,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('Stories')
                                .where('ID', isEqualTo: 'Sy_Tortoise_And_Hare')
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
                              builder: (context) => TandH6(
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
                              builder: (context) => TandH4(
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
                      AudioWidget.assets(
                        path: 'audios/audio4.mp3',
                        play: play_button,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              if (play == true) {
                                play = false;
                              } else {
                                if (play == false) {
                                  play = true;
                                }
                              }
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          splashColor: Colors.amber,
                          child: CircleAvatar(
                            radius: currentHeight / 16,
                            backgroundColor:
                                const Color.fromRGBO(245, 171, 0, 1),
                            child: Icon(
                              Icons.volume_up,
                              color: Colors.white,
                              size: currentHeight / 14,
                            ),
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

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_TandH2State.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TandH2State.onCurrentLocale... $locale');
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
    print('_TandH2State.onRecognitionResult... $text');

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
            builder: (context) => TandH6(
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
        ),
      ),
    );
  }
}

class TandH6 extends StatefulWidget {
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

  TandH6(
      {Key? key,
      required this.childID,
      required this.currentAvatar,
      required this.currentName})
      : super(key: key);
  @override
  _TandH6State createState() => _TandH6State();
}

class _TandH6State extends State<TandH6> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  bool play = false;
  bool play_button = false;
  bool play_birds_sound = true;
  var transcription = '';

  String _currentLocale = 'ar_Ar';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();

    setState(() {
      play = true;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TandH2State.activateSpeechRecognizer... ');
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
          body: AudioWidget.assets(
            path: 'audios/audio5.mp3',
            play: play,
            volume: 3,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/little-reader-efa14.appspot.com/o/Stories%2FSy_Tortoise_And_Hare%2FImages%2F6.jpeg?alt=media'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AudioWidget.assets(
                        path: 'audios/birds.mp3',
                        play: play_birds_sound,
                        volume: 0.1,
                        loopMode: LoopMode.playlist,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.7),
                          ),
                          height: currentHeight / 2.5,
                          width: currentWidht / 1.4,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('Stories')
                                .where('ID', isEqualTo: 'Sy_Tortoise_And_Hare')
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
                              builder: (context) => TandH7(
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
                              builder: (context) => TandH5(
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
                      AudioWidget.assets(
                        path: 'audios/audio5.mp3',
                        play: play_button,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              if (play == true) {
                                play = false;
                              } else {
                                if (play == false) {
                                  play = true;
                                }
                              }
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          splashColor: Colors.amber,
                          child: CircleAvatar(
                            radius: currentHeight / 16,
                            backgroundColor:
                                const Color.fromRGBO(245, 171, 0, 1),
                            child: Icon(
                              Icons.volume_up,
                              color: Colors.white,
                              size: currentHeight / 14,
                            ),
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

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_TandH2State.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TandH2State.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TandH2State.onRecognitionResult... $text');

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
            builder: (context) => TandH7(
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

class TandH7 extends StatefulWidget {
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

  TandH7(
      {Key? key,
      required this.childID,
      required this.currentAvatar,
      required this.currentName})
      : super(key: key);
  @override
  _TandH7State createState() => _TandH7State();
}

class _TandH7State extends State<TandH7> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  bool play = false;
  bool play_button = false;
  bool play_birds_sound = true;
  var transcription = '';

  String _currentLocale = 'ar_Ar';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();

    setState(() {
      play = true;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TandHState.activateSpeechRecognizer... ');
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
          body: AudioWidget.assets(
            path: 'audios/audio6.mp3',
            play: play,
            volume: 2.0,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/little-reader-efa14.appspot.com/o/Stories%2FSy_Tortoise_And_Hare%2FImages%2F7.jpeg?alt=media'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AudioWidget.assets(
                        path: 'audios/birds.mp3',
                        play: play_birds_sound,
                        volume: 0.1,
                        loopMode: LoopMode.playlist,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.7),
                          ),
                          height: currentHeight / 2.5,
                          width: currentWidht / 1.4,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('Stories')
                                .where('ID', isEqualTo: 'Sy_Tortoise_And_Hare')
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
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
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
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
                              builder: (context) => TandH8(
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
                              builder: (context) => TandH6(
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
                      AudioWidget.assets(
                        path: 'audios/audio6.mp3',
                        play: play_button,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              if (play == true) {
                                play = false;
                              } else {
                                if (play == false) {
                                  play = true;
                                }
                              }
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          splashColor: Colors.amber,
                          child: CircleAvatar(
                            radius: currentHeight / 16,
                            backgroundColor:
                                const Color.fromRGBO(245, 171, 0, 1),
                            child: Icon(
                              Icons.volume_up,
                              color: Colors.white,
                              size: currentHeight / 14,
                            ),
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

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_TandHState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TandHState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TandHState.onRecognitionResult... $text');

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
            builder: (context) => TandH8(
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

class TandH8 extends StatefulWidget {
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

  TandH8(
      {Key? key,
      required this.childID,
      required this.currentAvatar,
      required this.currentName})
      : super(key: key);
  @override
  _TandH8State createState() => _TandH8State();
}

class _TandH8State extends State<TandH8> {
  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  bool play = false;
  bool play_button = false;
  bool play_birds_sound = true;
  var transcription = '';

  String _currentLocale = 'ar_Ar';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();

    setState(() {
      play = true;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TandHState.activateSpeechRecognizer... ');
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
          body: AudioWidget.assets(
            path: 'audios/audio7.mp3',
            play: play,
            volume: 2,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/little-reader-efa14.appspot.com/o/Stories%2FSy_Tortoise_And_Hare%2FImages%2F8.jpeg?alt=media'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AudioWidget.assets(
                        path: 'audios/birds.mp3',
                        play: play_birds_sound,
                        volume: 0.1,
                        loopMode: LoopMode.playlist,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white.withOpacity(0.7),
                          ),
                          height: currentHeight / 2.5,
                          width: currentWidht / 1.4,
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('Stories')
                                .where('ID', isEqualTo: 'Sy_Tortoise_And_Hare')
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
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
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
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
                          //     builder: (context) => TandH2(
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
                              builder: (context) => TandH7(
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
                      AudioWidget.assets(
                        path: 'audios/audio7.mp3',
                        play: play_button,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              if (play == true) {
                                play = false;
                              } else {
                                if (play == false) {
                                  play = true;
                                }
                              }
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60),
                          ),
                          splashColor: Colors.amber,
                          child: CircleAvatar(
                            radius: currentHeight / 16,
                            backgroundColor:
                                const Color.fromRGBO(245, 171, 0, 1),
                            child: Icon(
                              Icons.volume_up,
                              color: Colors.white,
                              size: currentHeight / 14,
                            ),
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

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_TandHState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TandHState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TandHState.onRecognitionResult... $text');

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
