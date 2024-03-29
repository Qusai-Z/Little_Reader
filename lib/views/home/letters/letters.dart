import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:little_reader/services/counter.dart';
import 'package:little_reader/services/database.dart';
import 'package:little_reader/views/home/home.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:little_reader/views/registeration/inf_entry/child_statistics.dart';

const languages = [
  Language('Azerbaijani', 'az'),
];

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class LettersPage extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage> createState() => _LettersPageState();
}

class _LettersPageState extends State<LettersPage> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage2(
                              childID: widget.childID,
                              currentAvatar: widget.currentAvatar,
                              currentName: widget.currentName,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                        //
                      },
                      child: AudioWidget.assets(
                        path: 'audios/Oh-Oh.mp3',
                        play: wrong,
                        child: CircleAvatar(
                          backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                          radius: currentHeight / 20,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: currentHeight / 22,
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        color: Colors.brown,
                        height: currentHeight / 1.2,
                        width: currentWidht / 0.8,
                        margin: const EdgeInsets.all(30),
                        child: Container(
                          color: Colors.white,
                          margin: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                height: currentHeight / 4,
                                margin:
                                    EdgeInsets.only(bottom: currentHeight / 4),
                                child: Text(
                                  'أ',
                                  style: TextStyle(
                                      fontSize: currentHeight / 6,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MaterialButton(
                                    onPressed: () {
                                      if (_speechRecognitionAvailable &&
                                          !_isListening) {
                                        start();
                                      }
                                      null;
                                    },
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(60),
                                    ),
                                    splashColor: Colors.amber,
                                    child: CircleAvatar(
                                      backgroundColor:
                                          const Color.fromRGBO(245, 171, 0, 1),
                                      radius: currentHeight / 16,
                                      child: Icon(
                                        _isListening
                                            ? Icons.mic
                                            : Icons.mic_off,
                                        color: Colors.white,
                                        size: currentHeight / 14,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: currentWidht / 8,
                                  ),
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Home(
                                                    childID: widget.childID,
                                                    currentAvatar:
                                                        widget.currentAvatar,
                                                    currentName:
                                                        widget.currentName,
                                                  )),
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
                                  SizedBox(
                                    width: currentWidht / 8,
                                  ),
                                  AudioWidget.assets(
                                    path: 'audios/ALEF.mp3',
                                    play: play,
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
                                        backgroundColor: const Color.fromRGBO(
                                            245, 171, 0, 1),
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
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 22,
                        ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('Statistics')
                          .doc(_auth.currentUser!.email)
                          .collection('children')
                          .doc(widget.currentName)
                          .collection('letters')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator(); //If no data return this
                        }

                        final information = snapshot.data!
                            .docs; //information: stores gets the data from firebase documents

                        for (var item in information) {
                          final getCL =
                              item.data().toString().contains('correct_letters')
                                  ? item.get('correct_letters')
                                  : 0;
                          final getWL =
                              item.data().toString().contains('wrong_letters')
                                  ? item.get('wrong_letters')
                                  : 0;

                          Counter.correctLetterCounter = getCL;
                          Counter.wrongLetterCounter = getWL;
                        }
                        return Container();
                      },
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);

    if (text == 'əlif') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'əlif' && text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
    }
  }

  void errorHandler() => activateSpeechRecognizer();

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LettersPage2(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage2 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page2';

  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage2(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage2> createState() => _LettersPageState2();
}

class _LettersPageState2 extends State<LettersPage2> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage3(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          AudioWidget.assets(
                            path: 'audios/Oh-Oh.mp3',
                            play: wrong,
                            child: Container(
                              color: Colors.brown,
                              height: currentHeight / 1.2,
                              width: currentWidht / 0.8,
                              margin: const EdgeInsets.all(30),
                              child: Container(
                                color: Colors.white,
                                margin: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: currentHeight / 4,
                                      margin: EdgeInsets.only(
                                          bottom: currentHeight / 4),
                                      child: Text(
                                        'ب',
                                        style: TextStyle(
                                            fontSize: currentHeight / 6,
                                            color: isMatched == true
                                                ? colorGreen
                                                : isMatched == false
                                                    ? colorRed
                                                    : Colors.black),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            if (_speechRecognitionAvailable &&
                                                !_isListening) {
                                              start();
                                            }
                                            null;
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
                                            radius: currentHeight / 16,
                                            child: Icon(
                                              _isListening
                                                  ? Icons.mic
                                                  : Icons.mic_off,
                                              color: Colors.white,
                                              size: currentHeight / 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Home(
                                                    childID: widget.childID,
                                                    currentAvatar:
                                                        widget.currentAvatar,
                                                    currentName:
                                                        widget.currentName,
                                                  ),
                                                ),
                                                (Route<dynamic> route) =>
                                                    false);
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
                                            radius: currentHeight / 16,
                                            child: Icon(
                                              Icons.home,
                                              color: Colors.white,
                                              size: currentHeight / 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                        AudioWidget.assets(
                                          path: 'audios/BA2.mp3',
                                          play: play,
                                          child: MaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                if (play == false) {
                                                  play = true;
                                                } else {
                                                  if (play == true) {
                                                    play = false;
                                                  }
                                                }
                                              });
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                            splashColor: Colors.amber,
                                            child: CircleAvatar(
                                              radius: currentHeight / 16,
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      245, 171, 0, 1),
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
                                    StreamBuilder<QuerySnapshot>(
                                      stream: _firestore
                                          .collection('Statistics')
                                          .doc(_auth.currentUser!.email)
                                          .collection('children')
                                          .doc(widget.currentName)
                                          .collection('letters')
                                          .snapshots(),
                                      builder: (context, snapshot) {
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

                                          Counter.correctLetterCounter = getCL;
                                          Counter.wrongLetterCounter = getWL;
                                        }
                                        return Container();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'b' || text == 'və' || text == 'bəə') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'b' && text != 'və' && text != 'bəə' && text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage3(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage3 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage3(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage3> createState() => _LettersPageState3();
}

class _LettersPageState3 extends State<LettersPage3> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage4(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  AudioWidget.assets(
                                    path: 'audios/Oh-Oh.mp3',
                                    play: wrong,
                                    child: Container(
                                      height: currentHeight / 4,
                                      margin: EdgeInsets.only(
                                          bottom: currentHeight / 4),
                                      child: Text(
                                        'ت',
                                        style: TextStyle(
                                            fontSize: currentHeight / 6,
                                            color: isMatched == true
                                                ? colorGreen
                                                : isMatched == false
                                                    ? colorRed
                                                    : Colors.black),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            Counter.correctLetterCounter++;
                                            start();
                                          }

                                          null;
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/TA2.mp3',
                                        play: play,
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
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                                  StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('Statistics')
                                        .doc(_auth.currentUser!.email)
                                        .collection('children')
                                        .doc(widget.currentName)
                                        .collection('letters')
                                        .snapshots(),
                                    builder: (context, snapshot) {
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

                                        Counter.correctLetterCounter = getCL;
                                        Counter.wrongLetterCounter = getWL;
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage2(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'ə' ||
        text == 'tə' ||
        text == 't' ||
        text == 'tər' ||
        text == 'təs' ||
        text == 'tək' ||
        text == 'tr' ||
        text == 'tən' ||
        text == 'səh' ||
        text == 'text' ||
        text == 'teatr') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'ə' &&
        text != 'tə' &&
        text != 't' &&
        text != 'tər' &&
        text != 'təs' &&
        text != 'tək' &&
        text != 'tr' &&
        text != 'tən' &&
        text != 'səh' &&
        text != 'text' &&
        text != 'teatr' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage4(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage4 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page2';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage4(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage4> createState() => _LettersPageState4();
}

class _LettersPageState4 extends State<LettersPage4> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage5(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: currentHeight / 4,
                                    margin: EdgeInsets.only(
                                        bottom: currentHeight / 4),
                                    child: Text(
                                      'ث',
                                      style: TextStyle(
                                          fontSize: currentHeight / 6,
                                          color: isMatched == true
                                              ? colorGreen
                                              : isMatched == false
                                                  ? colorRed
                                                  : Colors.black),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: AudioWidget.assets(
                                          path: 'audios/Oh-Oh.mp3',
                                          play: wrong,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
                                            radius: currentHeight / 16,
                                            child: Icon(
                                              _isListening
                                                  ? Icons.mic
                                                  : Icons.mic_off,
                                              color: Colors.white,
                                              size: currentHeight / 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/THA2.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                                  StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('Statistics')
                                        .doc(_auth.currentUser!.email)
                                        .collection('children')
                                        .doc(widget.currentName)
                                        .collection('letters')
                                        .snapshots(),
                                    builder: (context, snapshot) {
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

                                        Counter.correctLetterCounter = getCL;
                                        Counter.wrongLetterCounter = getWL;
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage3(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {});
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'f' ||
        text == 'fə' ||
        text == 'şərh' ||
        text == 'səh' ||
        text == 'sən' ||
        text == 'sə') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'f' &&
        text != 'fə' &&
        text != 'şərh' &&
        text != 'səh' &&
        text != 'sən' &&
        text != 'sə' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage5(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage5 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage5(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage5> createState() => _LettersPageState5();
}

class _LettersPageState5 extends State<LettersPage5> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage6(
                              childID: widget.childID,
                              currentAvatar: widget.currentAvatar,
                              currentName: widget.currentName,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: AudioWidget.assets(
                        path: 'audios/Oh-Oh.mp3',
                        play: wrong,
                        child: CircleAvatar(
                          backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                          radius: currentHeight / 22,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: currentHeight / 24,
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: currentHeight / 4,
                                    margin: EdgeInsets.only(
                                        bottom: currentHeight / 4),
                                    child: Text(
                                      'ج',
                                      style: TextStyle(
                                          fontSize: currentHeight / 6,
                                          color: isMatched == true
                                              ? colorGreen
                                              : isMatched == false
                                                  ? colorRed
                                                  : Colors.black),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/GEEM.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                                  StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('Statistics')
                                        .doc(_auth.currentUser!.email)
                                        .collection('children')
                                        .doc(widget.currentName)
                                        .collection('letters')
                                        .snapshots(),
                                    builder: (context, snapshot) {
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

                                        Counter.correctLetterCounter = getCL;
                                        Counter.wrongLetterCounter = getWL;
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage4(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);

    if (text == 'g' ||
        text == 'jim' ||
        text == 'zim' ||
        text == 'zip' ||
        text == 'y' ||
        text == 'yetim' ||
        text == 'yeni' ||
        text == 'ym' ||
        text == 'zin' ||
        text == 'ziya' ||
        text == 'gmail') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'g' &&
        text != 'jim' &&
        text != 'zim' &&
        text != 'zip' &&
        text != 'y' &&
        text != 'gmail' &&
        text != 'yetim' &&
        text != 'yeni' &&
        text != 'ym' &&
        text != 'zin' &&
        text != 'ziya' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage6(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage6 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page2';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage6(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage6> createState() => _LettersPageState6();
}

class _LettersPageState6 extends State<LettersPage6> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage7(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: currentHeight / 4,
                                    margin: EdgeInsets.only(
                                        bottom: currentHeight / 4),
                                    child: Text(
                                      'ح',
                                      style: TextStyle(
                                          fontSize: currentHeight / 6,
                                          color: isMatched == true
                                              ? colorGreen
                                              : isMatched == false
                                                  ? colorRed
                                                  : Colors.black),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        splashColor: Colors.amber,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                        ),
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/Oh-Oh.mp3',
                                        play: wrong,
                                        child: SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/7A2.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage5(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'ə' || text == 'səhər' || text == 'hə' || text == 'şa') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'ə' &&
        text != 'səhər' &&
        text != 'hə' &&
        text != 'şa' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage7(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage7 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage7(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage7> createState() => _LettersPageState7();
}

class _LettersPageState7 extends State<LettersPage7> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage8(
                              childID: widget.childID,
                              currentAvatar: widget.currentAvatar,
                              currentName: widget.currentName,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: AudioWidget.assets(
                        path: 'audios/Oh-Oh.mp3',
                        play: wrong,
                        child: CircleAvatar(
                          backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                          radius: currentHeight / 22,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: currentHeight / 24,
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: currentHeight / 4,
                                    margin: EdgeInsets.only(
                                        bottom: currentHeight / 4),
                                    child: Text(
                                      'خ',
                                      style: TextStyle(
                                          fontSize: currentHeight / 6,
                                          color: isMatched == true
                                              ? colorGreen
                                              : isMatched == false
                                                  ? colorRed
                                                  : Colors.black),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/5A2.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
                                            child: Icon(
                                              Icons.volume_up,
                                              color: Colors.white,
                                              size: currentHeight / 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                        stream: _firestore
                                            .collection('Statistics')
                                            .doc(_auth.currentUser!.email)
                                            .collection('children')
                                            .doc(widget.currentName)
                                            .collection('letters')
                                            .snapshots(),
                                        builder: (context, snapshot) {
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

                                            Counter.correctLetterCounter =
                                                getCL;
                                            Counter.wrongLetterCounter = getWL;
                                          }
                                          return Container();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage6(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
            isMatched = true;
            correct = true;
            Counter.correctLetterCounter++;
            _Next();
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
  }

  void errorHandler() => activateSpeechRecognizer();

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });
  Future _Next() => Future.delayed(const Duration(seconds: 3), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LettersPage8(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage8 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage8(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage8> createState() => _LettersPageState8();
}

class _LettersPageState8 extends State<LettersPage8> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    AudioWidget.assets(
                      path: 'audios/Oh-Oh.mp3',
                      play: wrong,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LettersPage9(
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
                          radius: currentHeight / 22,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: currentHeight / 24,
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: currentHeight / 4,
                                    margin: EdgeInsets.only(
                                        bottom: currentHeight / 4),
                                    child: Text(
                                      'د',
                                      style: TextStyle(
                                          fontSize: currentHeight / 6,
                                          color: isMatched == true
                                              ? colorGreen
                                              : isMatched == false
                                                  ? colorRed
                                                  : Colors.black),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/DAL.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                                  StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('Statistics')
                                        .doc(_auth.currentUser!.email)
                                        .collection('children')
                                        .doc(widget.currentName)
                                        .collection('letters')
                                        .snapshots(),
                                    builder: (context, snapshot) {
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

                                        Counter.correctLetterCounter = getCL;
                                        Counter.wrongLetterCounter = getWL;
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage7(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'dərs' ||
        text == 'dən' ||
        text == 'bəli' ||
        text == 'vər' ||
        text == 'kəl' ||
        text == 'dəli') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'dərs' &&
        text != 'dən' &&
        text != 'bəli' &&
        text != 'vər' &&
        text != 'kəl' &&
        text != 'dəli' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage9(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage9 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage9(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage9> createState() => _LettersPageState9();
}

class _LettersPageState9 extends State<LettersPage9> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage10(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: currentHeight / 4,
                                    margin: EdgeInsets.only(
                                        bottom: currentHeight / 4),
                                    child: Text(
                                      'ذ',
                                      style: TextStyle(
                                          fontSize: currentHeight / 6,
                                          color: isMatched == true
                                              ? colorGreen
                                              : isMatched == false
                                                  ? colorRed
                                                  : Colors.black),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/Oh-Oh.mp3',
                                        play: wrong,
                                        child: SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/THAL.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage8(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'vəli' ||
        text == 'əd' ||
        text == 'əvvəl' ||
        text == 'vöen' ||
        text == 'kəl' ||
        text == 'mən' ||
        text == 'xəzər' ||
        text == 'əvəz') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'vəli' &&
        text != 'əd' &&
        text != 'əvvəl' &&
        text != 'vöen' &&
        text != 'kəl' &&
        text != 'mən' &&
        text != 'xəzər' &&
        text != 'əvəz' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage10(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage10 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage10(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage10> createState() => _LettersPageState10();
}

class _LettersPageState10 extends State<LettersPage10> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage11(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: currentHeight / 4,
                                    margin: EdgeInsets.only(
                                        bottom: currentHeight / 4),
                                    child: Text(
                                      'ر',
                                      style: TextStyle(
                                          fontSize: currentHeight / 6,
                                          color: isMatched == true
                                              ? colorGreen
                                              : isMatched == false
                                                  ? colorRed
                                                  : Colors.black),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/Oh-Oh.mp3',
                                        play: wrong,
                                        child: SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/RA2.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                                  StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('Statistics')
                                        .doc(_auth.currentUser!.email)
                                        .collection('children')
                                        .doc(widget.currentName)
                                        .collection('letters')
                                        .snapshots(),
                                    builder: (context, snapshot) {
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

                                        Counter.correctLetterCounter = getCL;
                                        Counter.wrongLetterCounter = getWL;
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage9(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'ra' ||
        text == 'love' ||
        text == 'vaxt' ||
        text == 'ifrat' ||
        text == 'va' ||
        text == 'raf' ||
        text == 'var' ||
        text == 'araz' ||
        text == 'wap') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'ra' &&
        text != 'love' &&
        text != 'vaxt' &&
        text != 'ifrat' &&
        text != 'va' &&
        text != 'raf' &&
        text != 'var' &&
        text != 'araz' &&
        text != 'wap' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage11(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage11 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage11(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage11> createState() => _LettersPageState11();
}

class _LettersPageState11 extends State<LettersPage11> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage12(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          AudioWidget.assets(
                            path: 'audios/Oh-Oh.mp3',
                            play: wrong,
                            child: Container(
                              color: Colors.brown,
                              height: currentHeight / 1.2,
                              width: currentWidht / 0.8,
                              margin: const EdgeInsets.all(30),
                              child: Container(
                                color: Colors.white,
                                margin: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: currentHeight / 4,
                                      margin: EdgeInsets.only(
                                          bottom: currentHeight / 4),
                                      child: Text(
                                        'ز',
                                        style: TextStyle(
                                            fontSize: currentHeight / 6,
                                            color: isMatched == true
                                                ? colorGreen
                                                : isMatched == false
                                                    ? colorRed
                                                    : Colors.black),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            if (_speechRecognitionAvailable &&
                                                !_isListening) {
                                              start();
                                            }
                                            null;
                                          },
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
                                            radius: currentHeight / 16,
                                            child: Icon(
                                              _isListening
                                                  ? Icons.mic
                                                  : Icons.mic_off,
                                              color: Colors.white,
                                              size: currentHeight / 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Home(
                                                    childID: widget.childID,
                                                    currentAvatar:
                                                        widget.currentAvatar,
                                                    currentName:
                                                        widget.currentName,
                                                  ),
                                                ),
                                                (Route<dynamic> route) =>
                                                    false);
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
                                            radius: currentHeight / 16,
                                            child: Icon(
                                              Icons.home,
                                              color: Colors.white,
                                              size: currentHeight / 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                        AudioWidget.assets(
                                          path: 'audios/ZAY.mp3',
                                          play: play,
                                          child: MaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                if (play == false) {
                                                  play = true;
                                                } else {
                                                  if (play == true) {
                                                    play = false;
                                                  }
                                                }
                                              });
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                            splashColor: Colors.amber,
                                            child: CircleAvatar(
                                              radius: currentHeight / 16,
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      245, 171, 0, 1),
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
                          StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('Statistics')
                                .doc(_auth.currentUser!.email)
                                .collection('children')
                                .doc(widget.currentName)
                                .collection('letters')
                                .snapshots(),
                            builder: (context, snapshot) {
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

                                Counter.correctLetterCounter = getCL;
                                Counter.wrongLetterCounter = getWL;
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage10(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'zəy' || text == 'səh' || text == 'zərf' || text == 'zəif') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'zəy' &&
        text != 'səh' &&
        text != 'zərf' &&
        text != 'zəif' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage12(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage12 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage12(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage12> createState() => _LettersPageState12();
}

class _LettersPageState12 extends State<LettersPage12> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage13(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  AudioWidget.assets(
                                    path: 'audios/Oh-Oh.mp3',
                                    play: wrong,
                                    child: Container(
                                      height: currentHeight / 4,
                                      margin: EdgeInsets.only(
                                          bottom: currentHeight / 4),
                                      child: Text(
                                        'س',
                                        style: TextStyle(
                                            fontSize: currentHeight / 6,
                                            color: isMatched == true
                                                ? colorGreen
                                                : isMatched == false
                                                    ? colorRed
                                                    : Colors.black),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/SEEN.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                          StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('Statistics')
                                .doc(_auth.currentUser!.email)
                                .collection('children')
                                .doc(widget.currentName)
                                .collection('letters')
                                .snapshots(),
                            builder: (context, snapshot) {
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

                                Counter.correctLetterCounter = getCL;
                                Counter.wrongLetterCounter = getWL;
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage11(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'seyid' || text == 'sen' || text == 'sin' || text == 'sil') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'seyid' &&
        text != 'sen' &&
        text != 'sin' &&
        text != 'sil' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage13(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage13 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage13(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage13> createState() => _LettersPageState13();
}

class _LettersPageState13 extends State<LettersPage13> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage14(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          AudioWidget.assets(
                            path: 'audios/Oh-Oh.mp3',
                            play: wrong,
                            child: Container(
                              color: Colors.brown,
                              height: currentHeight / 1.2,
                              width: currentWidht / 0.8,
                              margin: const EdgeInsets.all(30),
                              child: Container(
                                color: Colors.white,
                                margin: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: currentHeight / 4,
                                      margin: EdgeInsets.only(
                                          bottom: currentHeight / 4),
                                      child: Text(
                                        'ش',
                                        style: TextStyle(
                                            fontSize: currentHeight / 6,
                                            color: isMatched == true
                                                ? colorGreen
                                                : isMatched == false
                                                    ? colorRed
                                                    : Colors.black),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            if (_speechRecognitionAvailable &&
                                                !_isListening) {
                                              start();
                                            }
                                            null;
                                          },
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
                                            radius: currentHeight / 16,
                                            child: Icon(
                                              _isListening
                                                  ? Icons.mic
                                                  : Icons.mic_off,
                                              color: Colors.white,
                                              size: currentHeight / 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Home(
                                                    childID: widget.childID,
                                                    currentAvatar:
                                                        widget.currentAvatar,
                                                    currentName:
                                                        widget.currentName,
                                                  ),
                                                ),
                                                (Route<dynamic> route) =>
                                                    false);
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
                                            radius: currentHeight / 16,
                                            child: Icon(
                                              Icons.home,
                                              color: Colors.white,
                                              size: currentHeight / 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                        AudioWidget.assets(
                                          path: 'audios/SHEEN.mp3',
                                          play: play,
                                          child: MaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                if (play == false) {
                                                  play = true;
                                                } else {
                                                  if (play == true) {
                                                    play = false;
                                                  }
                                                }
                                              });
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                            splashColor: Colors.amber,
                                            child: CircleAvatar(
                                              radius: currentHeight / 16,
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      245, 171, 0, 1),
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
                          StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('Statistics')
                                .doc(_auth.currentUser!.email)
                                .collection('children')
                                .doc(widget.currentName)
                                .collection('letters')
                                .snapshots(),
                            builder: (context, snapshot) {
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

                                Counter.correctLetterCounter = getCL;
                                Counter.wrongLetterCounter = getWL;
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage12(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'şirin' || text == 'şeir') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'şirin' && text != 'şeir' && text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage14(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage14 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage14(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage14> createState() => _LettersPageState14();
}

class _LettersPageState14 extends State<LettersPage14> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage15(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: currentHeight / 4,
                                    margin: EdgeInsets.only(
                                        bottom: currentHeight / 4),
                                    child: Text(
                                      'ص',
                                      style: TextStyle(
                                          fontSize: currentHeight / 6,
                                          color: isMatched == true
                                              ? colorGreen
                                              : isMatched == false
                                                  ? colorRed
                                                  : Colors.black),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: AudioWidget.assets(
                                          path: 'audios/Oh-Oh.mp3',
                                          play: wrong,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
                                            radius: currentHeight / 16,
                                            child: Icon(
                                              _isListening
                                                  ? Icons.mic
                                                  : Icons.mic_off,
                                              color: Colors.white,
                                              size: currentHeight / 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/9AD.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                          StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('Statistics')
                                .doc(_auth.currentUser!.email)
                                .collection('children')
                                .doc(widget.currentName)
                                .collection('letters')
                                .snapshots(),
                            builder: (context, snapshot) {
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

                                Counter.correctLetterCounter = getCL;
                                Counter.wrongLetterCounter = getWL;
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage13(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'sayt' ||
        text == 'sadi' ||
        text == 'sade' ||
        text == 'zahid' ||
        text == 'sazz' ||
        text == 'sadə') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'sayt' &&
        text != 'sadi' &&
        text != 'sade' &&
        text != 'zahid' &&
        text != 'sadə' &&
        text != 'sazz' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage15(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage15 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage15(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage15> createState() => _LettersPageState15();
}

class _LettersPageState15 extends State<LettersPage15> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage16(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    AudioWidget.assets(
                      path: 'audios/Oh-Oh.mp3',
                      play: wrong,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              color: Colors.brown,
                              height: currentHeight / 1.2,
                              width: currentWidht / 0.8,
                              margin: const EdgeInsets.all(30),
                              child: Container(
                                color: Colors.white,
                                margin: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: currentHeight / 4,
                                      margin: EdgeInsets.only(
                                          bottom: currentHeight / 4),
                                      child: Text(
                                        'ض',
                                        style: TextStyle(
                                            fontSize: currentHeight / 6,
                                            color: isMatched == true
                                                ? colorGreen
                                                : isMatched == false
                                                    ? colorRed
                                                    : Colors.black),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            if (_speechRecognitionAvailable &&
                                                !_isListening) {
                                              start();
                                            }
                                            null;
                                          },
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
                                            radius: currentHeight / 16,
                                            child: Icon(
                                              _isListening
                                                  ? Icons.mic
                                                  : Icons.mic_off,
                                              color: Colors.white,
                                              size: currentHeight / 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Home(
                                                    childID: widget.childID,
                                                    currentAvatar:
                                                        widget.currentAvatar,
                                                    currentName:
                                                        widget.currentName,
                                                  ),
                                                ),
                                                (Route<dynamic> route) =>
                                                    false);
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
                                            radius: currentHeight / 16,
                                            child: Icon(
                                              Icons.home,
                                              color: Colors.white,
                                              size: currentHeight / 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                        AudioWidget.assets(
                                          path: 'audios/DAD.mp3',
                                          play: play,
                                          child: MaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                if (play == false) {
                                                  play = true;
                                                } else {
                                                  if (play == true) {
                                                    play = false;
                                                  }
                                                }
                                              });
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                            splashColor: Colors.amber,
                                            child: CircleAvatar(
                                              radius: currentHeight / 16,
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      245, 171, 0, 1),
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
                                    StreamBuilder<QuerySnapshot>(
                                      stream: _firestore
                                          .collection('Statistics')
                                          .doc(_auth.currentUser!.email)
                                          .collection('children')
                                          .doc(widget.currentName)
                                          .collection('letters')
                                          .snapshots(),
                                      builder: (context, snapshot) {
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

                                          Counter.correctLetterCounter = getCL;
                                          Counter.wrongLetterCounter = getWL;
                                        }
                                        return Container();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage14(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'y' ||
        text == 'mail' ||
        text == 'əvvəl' ||
        text == 'valide' ||
        text == 'mail' ||
        text == 'mən' ||
        text == 'bax' ||
        text == 'var' ||
        text == 'wap' ||
        text == 'bakı' ||
        text == 'mod' ||
        text == 'vaz') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'y' &&
        text != 'mail' &&
        text != 'valide' &&
        text != 'vöen' &&
        text != 'mail' &&
        text != 'mən' &&
        text != 'bax' &&
        text != 'var' &&
        text != 'vaz' &&
        text != 'wap' &&
        text != 'bakı' &&
        text != 'mod' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage16(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage16 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage16(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage16> createState() => _LettersPageState16();
}

class _LettersPageState16 extends State<LettersPage16> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage17(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    AudioWidget.assets(
                      path: 'audios/Oh-Oh.mp3',
                      play: wrong,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              color: Colors.brown,
                              height: currentHeight / 1.2,
                              width: currentWidht / 0.8,
                              margin: const EdgeInsets.all(30),
                              child: Container(
                                color: Colors.white,
                                margin: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: currentHeight / 4,
                                      margin: EdgeInsets.only(
                                          bottom: currentHeight / 4),
                                      child: Text(
                                        'ط',
                                        style: TextStyle(
                                            fontSize: currentHeight / 6,
                                            color: isMatched == true
                                                ? colorGreen
                                                : isMatched == false
                                                    ? colorRed
                                                    : Colors.black),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            if (_speechRecognitionAvailable &&
                                                !_isListening) {
                                              start();
                                            }
                                            null;
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(90),
                                          ),
                                          splashColor: const Color.fromRGBO(
                                              149, 22, 224, 1),
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
                                            radius: currentHeight / 16,
                                            child: Icon(
                                              _isListening
                                                  ? Icons.mic
                                                  : Icons.mic_off,
                                              color: Colors.white,
                                              size: currentHeight / 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: currentWidht / 10,
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Home(
                                                    childID: widget.childID,
                                                    currentAvatar:
                                                        widget.currentAvatar,
                                                    currentName:
                                                        widget.currentName,
                                                  ),
                                                ),
                                                (Route<dynamic> route) =>
                                                    false);
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(90),
                                          ),
                                          splashColor: const Color.fromRGBO(
                                              149, 22, 224, 1),
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
                                            radius: currentHeight / 16,
                                            child: Icon(
                                              Icons.home,
                                              color: Colors.white,
                                              size: currentHeight / 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: currentWidht / 10,
                                        ),
                                        AudioWidget.assets(
                                          path: 'audios/6A2.mp3',
                                          play: play,
                                          child: MaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                if (play == false) {
                                                  play = true;
                                                } else {
                                                  if (play == true) {
                                                    play = false;
                                                  }
                                                }
                                              });
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                            splashColor: Colors.amber,
                                            child: CircleAvatar(
                                              radius: currentHeight / 16,
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      245, 171, 0, 1),
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
                                    StreamBuilder<QuerySnapshot>(
                                      stream: _firestore
                                          .collection('Statistics')
                                          .doc(_auth.currentUser!.email)
                                          .collection('children')
                                          .doc(widget.currentName)
                                          .collection('letters')
                                          .snapshots(),
                                      builder: (context, snapshot) {
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

                                          Counter.correctLetterCounter = getCL;
                                          Counter.wrongLetterCounter = getWL;
                                        }
                                        return Container();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage15(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;

            print('MM:$isMatched');
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'a' ||
        text == 'da' ||
        text == 'o' ||
        text == 'pub' ||
        text == 'bağ') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'a' &&
        text != 'da' &&
        text != 'o' &&
        text != 'pub' &&
        text != 'bağ' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage17(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage17 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage17(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage17> createState() => _LettersPageState17();
}

class _LettersPageState17 extends State<LettersPage17> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage18(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  AudioWidget.assets(
                                    path: 'audios/Oh=Oh.mp3',
                                    play: wrong,
                                    child: Container(
                                      height: currentHeight / 4,
                                      margin: EdgeInsets.only(
                                          bottom: currentHeight / 4),
                                      child: Text(
                                        'ظ',
                                        style: TextStyle(
                                            fontSize: currentHeight / 6,
                                            color: isMatched == true
                                                ? colorGreen
                                                : isMatched == false
                                                    ? colorRed
                                                    : Colors.black),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/9HA2.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                                  StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('Statistics')
                                        .doc(_auth.currentUser!.email)
                                        .collection('children')
                                        .doc(widget.currentName)
                                        .collection('letters')
                                        .snapshots(),
                                    builder: (context, snapshot) {
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

                                        Counter.correctLetterCounter = getCL;
                                        Counter.wrongLetterCounter = getWL;
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage16(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'o' || text == 'var' || text == 'y' || text == 'wap') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'o' &&
        text != 'var' &&
        text != 'y' &&
        text != 'wap' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage18(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage18 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage18(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage18> createState() => _LettersPageState18();
}

class _LettersPageState18 extends State<LettersPage18> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage19(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: currentHeight / 4,
                                    margin: EdgeInsets.only(
                                        bottom: currentHeight / 4),
                                    child: Text(
                                      'ع',
                                      style: TextStyle(
                                          fontSize: currentHeight / 6,
                                          color: isMatched == true
                                              ? colorGreen
                                              : isMatched == false
                                                  ? colorRed
                                                  : Colors.black),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/Oh-Oh.mp3',
                                        play: wrong,
                                        child: SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/3YN.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                                  StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('Statistics')
                                        .doc(_auth.currentUser!.email)
                                        .collection('children')
                                        .doc(widget.currentName)
                                        .collection('letters')
                                        .snapshots(),
                                    builder: (context, snapshot) {
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

                                        Counter.correctLetterCounter = getCL;
                                        Counter.wrongLetterCounter = getWL;
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage17(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;

            print('MM:$isMatched');
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'əyin' || text == 'həyat' || text == 'təyin') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'əyin' && text != 'həyat' && text != 'təyin' && text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage19(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage19 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage19(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage19> createState() => _LettersPageState19();
}

class _LettersPageState19 extends State<LettersPage19> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage20(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: currentHeight / 4,
                                    margin: EdgeInsets.only(
                                        bottom: currentHeight / 4),
                                    child: Text(
                                      'غ',
                                      style: TextStyle(
                                          fontSize: currentHeight / 6,
                                          color: isMatched == true
                                              ? colorGreen
                                              : isMatched == false
                                                  ? colorRed
                                                  : Colors.black),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/Oh-Oh.mp3',
                                        play: wrong,
                                        child: SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/3YN2.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                                  StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('Statistics')
                                        .doc(_auth.currentUser!.email)
                                        .collection('children')
                                        .doc(widget.currentName)
                                        .collection('letters')
                                        .snapshots(),
                                    builder: (context, snapshot) {
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

                                        Counter.correctLetterCounter = getCL;
                                        Counter.wrongLetterCounter = getWL;
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage18(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;

            print('MM:$isMatched');
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'ağayev' ||
        text == 'mail' ||
        text == 'y' ||
        text == 'zeyin' ||
        text == 'zayn' ||
        text == 'zeyn' ||
        text == 'ok.ru' ||
        text == 'wayne' ||
        text == 'təyin') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'ağayev' &&
        text != 'mail' &&
        text != 'y' &&
        text != 'zeyin' &&
        text != 'zayn' &&
        text != 'zeyn' &&
        text != 'ok.ru' &&
        text != 'təyin' &&
        text != 'wayne' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage20(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage20 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage20(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage20> createState() => _LettersPageState20();
}

class _LettersPageState20 extends State<LettersPage20> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage21(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: currentHeight / 4,
                                    margin: EdgeInsets.only(
                                        bottom: currentHeight / 4),
                                    child: Text(
                                      'ف',
                                      style: TextStyle(
                                          fontSize: currentHeight / 6,
                                          color: isMatched == true
                                              ? colorGreen
                                              : isMatched == false
                                                  ? colorRed
                                                  : Colors.black),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/Oh-Oh.mp3',
                                        play: wrong,
                                        child: SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/FA2.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                                  StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('Statistics')
                                        .doc(_auth.currentUser!.email)
                                        .collection('children')
                                        .doc(widget.currentName)
                                        .collection('letters')
                                        .snapshots(),
                                    builder: (context, snapshot) {
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

                                        Counter.correctLetterCounter = getCL;
                                        Counter.wrongLetterCounter = getWL;
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage19(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;

            print('MM:$isMatched');
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'sifətə' || text == 'f' || text == 'fb') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'sifətə' && text != 'f' && text != 'fb' && text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage21(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage21 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage21(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage21> createState() => _LettersPageState21();
}

class _LettersPageState21 extends State<LettersPage21> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage22(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: currentHeight / 4,
                                    margin: EdgeInsets.only(
                                        bottom: currentHeight / 4),
                                    child: Text(
                                      'ق',
                                      style: TextStyle(
                                          fontSize: currentHeight / 6,
                                          color: isMatched == true
                                              ? colorGreen
                                              : isMatched == false
                                                  ? colorRed
                                                  : Colors.black),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/Oh-Oh.mp3',
                                        play: wrong,
                                        child: SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/QAF.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                                  StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('Statistics')
                                        .doc(_auth.currentUser!.email)
                                        .collection('children')
                                        .doc(widget.currentName)
                                        .collection('letters')
                                        .snapshots(),
                                    builder: (context, snapshot) {
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

                                        Counter.correctLetterCounter = getCL;
                                        Counter.wrongLetterCounter = getWL;
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage20(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;

            print('MM:$isMatched');
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'a' ||
        text == 'pap.az' ||
        text == 'aaaf' ||
        text == 'ağız' ||
        text == 'oxu.az' ||
        text == 'fal' ||
        text == 'ok' ||
        text == 'az') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'a' &&
        text != 'pap.az' &&
        text != 'aaaf' &&
        text != 'ağız' &&
        text != 'oxu.az' &&
        text != 'fal' &&
        text != 'az' &&
        text != 'ok' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage22(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

//t3al
class LettersPage22 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage22(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage22> createState() => _LettersPageState22();
}

class _LettersPageState22 extends State<LettersPage22> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage23(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: currentHeight / 4,
                                    margin: EdgeInsets.only(
                                        bottom: currentHeight / 4),
                                    child: Text(
                                      'ك',
                                      style: TextStyle(
                                          fontSize: currentHeight / 6,
                                          color: isMatched == true
                                              ? colorGreen
                                              : isMatched == false
                                                  ? colorRed
                                                  : Colors.black),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/Oh-Oh.mp3',
                                        play: wrong,
                                        child: SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/KAF.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                                  StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('Statistics')
                                        .doc(_auth.currentUser!.email)
                                        .collection('children')
                                        .doc(widget.currentName)
                                        .collection('letters')
                                        .snapshots(),
                                    builder: (context, snapshot) {
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

                                        Counter.correctLetterCounter = getCL;
                                        Counter.wrongLetterCounter = getWL;
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage21(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'f' ||
        text == 'kəf' ||
        text == 'qaf' ||
        text == 'qht' ||
        text == 'k') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'f' &&
        text != 'kəf' &&
        text != 'qaf' &&
        text != 'qht' &&
        text != 'k' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage23(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage23 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage23(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage23> createState() => _LettersPageState23();
}

class _LettersPageState23 extends State<LettersPage23> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage24(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  AudioWidget.assets(
                                    path: 'audios/Oh-Oh.mp3',
                                    play: wrong,
                                    child: Container(
                                      height: currentHeight / 4,
                                      margin: EdgeInsets.only(
                                          bottom: currentHeight / 4),
                                      child: Text(
                                        'ل',
                                        style: TextStyle(
                                            fontSize: currentHeight / 6,
                                            color: isMatched == true
                                                ? colorGreen
                                                : isMatched == false
                                                    ? colorRed
                                                    : Colors.black),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/LAM.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                          StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('Statistics')
                                .doc(_auth.currentUser!.email)
                                .collection('children')
                                .doc(widget.currentName)
                                .collection('letters')
                                .snapshots(),
                            builder: (context, snapshot) {
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

                                Counter.correctLetterCounter = getCL;
                                Counter.wrongLetterCounter = getWL;
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage22(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'ləm' ||
        text == 'leon' ||
        text == 'ləğv' ||
        text == 'lə' ||
        text == 'zər' ||
        text == 'illər') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'ləm' &&
        text != 'leon' &&
        text != 'ləğv' &&
        text != 'lə' &&
        text != 'illər' &&
        text != 'zər' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage24(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage24 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage24(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage24> createState() => _LettersPageState24();
}

class _LettersPageState24 extends State<LettersPage24> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage25(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    AudioWidget.assets(
                      path: 'audios/Oh-Oh.mp3',
                      play: wrong,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              color: Colors.brown,
                              height: currentHeight / 1.2,
                              width: currentWidht / 0.8,
                              margin: const EdgeInsets.all(30),
                              child: Container(
                                color: Colors.white,
                                margin: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: currentHeight / 4,
                                      margin: EdgeInsets.only(
                                          bottom: currentHeight / 4),
                                      child: Text(
                                        'م',
                                        style: TextStyle(
                                            fontSize: currentHeight / 6,
                                            color: isMatched == true
                                                ? colorGreen
                                                : isMatched == false
                                                    ? colorRed
                                                    : Colors.black),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            if (_speechRecognitionAvailable &&
                                                !_isListening) {
                                              start();
                                            }
                                            null;
                                          },
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
                                            radius: currentHeight / 16,
                                            child: Icon(
                                              _isListening
                                                  ? Icons.mic
                                                  : Icons.mic_off,
                                              color: Colors.white,
                                              size: currentHeight / 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Home(
                                                    childID: widget.childID,
                                                    currentAvatar:
                                                        widget.currentAvatar,
                                                    currentName:
                                                        widget.currentName,
                                                  ),
                                                ),
                                                (Route<dynamic> route) =>
                                                    false);
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
                                            radius: currentHeight / 16,
                                            child: Icon(
                                              Icons.home,
                                              color: Colors.white,
                                              size: currentHeight / 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                        AudioWidget.assets(
                                          path: 'audios/MEEM.mp3',
                                          play: play,
                                          child: MaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                if (play == false) {
                                                  play = true;
                                                } else {
                                                  if (play == true) {
                                                    play = false;
                                                  }
                                                }
                                              });
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                            splashColor: Colors.amber,
                                            child: CircleAvatar(
                                              radius: currentHeight / 16,
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      245, 171, 0, 1),
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
                            StreamBuilder<QuerySnapshot>(
                              stream: _firestore
                                  .collection('Statistics')
                                  .doc(_auth.currentUser!.email)
                                  .collection('children')
                                  .doc(widget.currentName)
                                  .collection('letters')
                                  .snapshots(),
                              builder: (context, snapshot) {
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

                                  Counter.correctLetterCounter = getCL;
                                  Counter.wrongLetterCounter = getWL;
                                }
                                return Container();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage23(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'meyim' ||
        text == 'min' ||
        text == 'gmail' ||
        text == 'weyim' ||
        text == 'meymun' ||
        text == 'game' ||
        text == 'a' ||
        text == 'miyim' ||
        text == 'mil' ||
        text == 'may' ||
        text == 'eyyub' ||
        text == 'mi') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'meyim' &&
        text != 'min' &&
        text != 'gmail' &&
        text != 'weyim' &&
        text != 'meymun' &&
        text != 'game' &&
        text != 'a' &&
        text != 'miyim' &&
        text != 'mi' &&
        text != 'mil' &&
        text != 'may' &&
        text != 'eyyub' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage25(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage25 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage25(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage25> createState() => _LettersPageState25();
}

class _LettersPageState25 extends State<LettersPage25> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage26(
                              childID: widget.childID,
                              currentAvatar: widget.currentAvatar,
                              currentName: widget.currentName,
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: AudioWidget.assets(
                        path: 'audios/Oh-Oh.mp3',
                        play: wrong,
                        child: CircleAvatar(
                          backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                          radius: currentHeight / 22,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: currentHeight / 24,
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: currentHeight / 4,
                                    margin: EdgeInsets.only(
                                        bottom: currentHeight / 4),
                                    child: Text(
                                      'ن',
                                      style: TextStyle(
                                          fontSize: currentHeight / 6,
                                          color: isMatched == true
                                              ? colorGreen
                                              : isMatched == false
                                                  ? colorRed
                                                  : Colors.black),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/NOON.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                          StreamBuilder<QuerySnapshot>(
                            stream: _firestore
                                .collection('Statistics')
                                .doc(_auth.currentUser!.email)
                                .collection('children')
                                .doc(widget.currentName)
                                .collection('letters')
                                .snapshots(),
                            builder: (context, snapshot) {
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

                                Counter.correctLetterCounter = getCL;
                                Counter.wrongLetterCounter = getWL;
                              }
                              return Container();
                            },
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage24(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'nuri' ||
        text == 'lunin' ||
        text == 'nur' ||
        text == 'ok.ru' ||
        text == 'uni' ||
        text == 'nurinin' ||
        text == 'nuni' ||
        text == 'nani') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'nuri' &&
        text != 'lunin' &&
        text != 'nur' &&
        text != 'ok.ru' &&
        text != 'uni' &&
        text != 'nurinin' &&
        text != 'nuni' &&
        text != 'nani' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage26(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage26 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage26(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage26> createState() => _LettersPageState26();
}

class _LettersPageState26 extends State<LettersPage26> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    AudioWidget.assets(
                      path: 'audios/Oh-Oh.mp3',
                      play: wrong,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LettersPage27(
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
                          radius: currentHeight / 22,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: currentHeight / 24,
                          ),
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: currentHeight / 4,
                                    margin: EdgeInsets.only(
                                        bottom: currentHeight / 4),
                                    child: Text(
                                      'ه',
                                      style: TextStyle(
                                          fontSize: currentHeight / 6,
                                          color: isMatched == true
                                              ? colorGreen
                                              : isMatched == false
                                                  ? colorRed
                                                  : Colors.black),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/HA2.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                                  StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('Statistics')
                                        .doc(_auth.currentUser!.email)
                                        .collection('children')
                                        .doc(widget.currentName)
                                        .collection('letters')
                                        .snapshots(),
                                    builder: (context, snapshot) {
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

                                        Counter.correctLetterCounter = getCL;
                                        Counter.wrongLetterCounter = getWL;
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage25(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'hə' || text == 'h') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'hə' && text != 'h' && text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage27(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage27 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage27(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage27> createState() => _LettersPageState27();
}

class _LettersPageState27 extends State<LettersPage27> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage28(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    AudioWidget.assets(
                      path: 'audios/Oh-Oh.mp3',
                      play: wrong,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              color: Colors.brown,
                              height: currentHeight / 1.2,
                              width: currentWidht / 0.8,
                              margin: const EdgeInsets.all(30),
                              child: Container(
                                color: Colors.white,
                                margin: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      height: currentHeight / 4,
                                      margin: EdgeInsets.only(
                                          bottom: currentHeight / 4),
                                      child: Text(
                                        'و',
                                        style: TextStyle(
                                            fontSize: currentHeight / 6,
                                            color: isMatched == true
                                                ? colorGreen
                                                : isMatched == false
                                                    ? colorRed
                                                    : Colors.black),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        MaterialButton(
                                          onPressed: () {
                                            if (_speechRecognitionAvailable &&
                                                !_isListening) {
                                              start();
                                            }
                                            null;
                                          },
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
                                            radius: currentHeight / 16,
                                            child: Icon(
                                              _isListening
                                                  ? Icons.mic
                                                  : Icons.mic_off,
                                              color: Colors.white,
                                              size: currentHeight / 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                        MaterialButton(
                                          onPressed: () {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Home(
                                                    childID: widget.childID,
                                                    currentAvatar:
                                                        widget.currentAvatar,
                                                    currentName:
                                                        widget.currentName,
                                                  ),
                                                ),
                                                (Route<dynamic> route) =>
                                                    false);
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
                                            radius: currentHeight / 16,
                                            child: Icon(
                                              Icons.home,
                                              color: Colors.white,
                                              size: currentHeight / 14,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                        AudioWidget.assets(
                                          path: 'audios/WAW.mp3',
                                          play: play,
                                          child: MaterialButton(
                                            onPressed: () {
                                              setState(() {
                                                if (play == false) {
                                                  play = true;
                                                } else {
                                                  if (play == true) {
                                                    play = false;
                                                  }
                                                }
                                              });
                                            },
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(60),
                                            ),
                                            splashColor: Colors.amber,
                                            child: CircleAvatar(
                                              radius: currentHeight / 16,
                                              backgroundColor:
                                                  const Color.fromRGBO(
                                                      245, 171, 0, 1),
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
                            StreamBuilder<QuerySnapshot>(
                              stream: _firestore
                                  .collection('Statistics')
                                  .doc(_auth.currentUser!.email)
                                  .collection('children')
                                  .doc(widget.currentName)
                                  .collection('letters')
                                  .snapshots(),
                              builder: (context, snapshot) {
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

                                  Counter.correctLetterCounter = getCL;
                                  Counter.wrongLetterCounter = getWL;
                                }
                                return Container();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage26(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'valyuta' ||
        text == 'val' ||
        text == 'wow' ||
        text == 'love' ||
        text == 'wap') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'valyuta' &&
        text != 'val' &&
        text != 'wow' &&
        text != 'love' &&
        text != 'wap' &&
        text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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
            builder: (context) => LettersPage28(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPage28 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPage28(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPage28> createState() => _LettersPageState28();
}

class _LettersPageState28 extends State<LettersPage28> {
  bool play = false;
  bool correct = false;
  bool wrong = false;
  bool? isMatched;
  Color colorGreen = Colors.green;
  Color colorRed = Colors.red;

  late SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  var transcription = '';

  // String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void activateSpeechRecognizer() {
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);

    _speech.activate('az').then((res) {
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

    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          path: 'audios/CORRECT.mp3',
          play: correct,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/guarden.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            color: Colors.brown,
                            height: currentHeight / 1.2,
                            width: currentWidht / 0.8,
                            margin: const EdgeInsets.all(30),
                            child: Container(
                              color: Colors.white,
                              margin: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    height: currentHeight / 4,
                                    margin: EdgeInsets.only(
                                        bottom: currentHeight / 4),
                                    child: Text(
                                      'ي',
                                      style: TextStyle(
                                          fontSize: currentHeight / 6,
                                          color: isMatched == true
                                              ? colorGreen
                                              : isMatched == false
                                                  ? colorRed
                                                  : Colors.black),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      MaterialButton(
                                        onPressed: () {
                                          if (_speechRecognitionAvailable &&
                                              !_isListening) {
                                            start();
                                          }
                                          null;
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            _isListening
                                                ? Icons.mic
                                                : Icons.mic_off,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/Oh-Oh.mp3',
                                        play: wrong,
                                        child: SizedBox(
                                          width: currentWidht / 8,
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Home(
                                                  childID: widget.childID,
                                                  currentAvatar:
                                                      widget.currentAvatar,
                                                  currentName:
                                                      widget.currentName,
                                                ),
                                              ),
                                              (Route<dynamic> route) => false);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        splashColor: Colors.amber,
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromRGBO(
                                              245, 171, 0, 1),
                                          radius: currentHeight / 16,
                                          child: Icon(
                                            Icons.home,
                                            color: Colors.white,
                                            size: currentHeight / 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: currentWidht / 8,
                                      ),
                                      AudioWidget.assets(
                                        path: 'audios/YA2.mp3',
                                        play: play,
                                        child: MaterialButton(
                                          onPressed: () {
                                            setState(() {
                                              if (play == false) {
                                                play = true;
                                              } else {
                                                if (play == true) {
                                                  play = false;
                                                }
                                              }
                                            });
                                          },
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          splashColor: Colors.amber,
                                          child: CircleAvatar(
                                            radius: currentHeight / 16,
                                            backgroundColor:
                                                const Color.fromRGBO(
                                                    245, 171, 0, 1),
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
                                  StreamBuilder<QuerySnapshot>(
                                    stream: _firestore
                                        .collection('Statistics')
                                        .doc(_auth.currentUser!.email)
                                        .collection('children')
                                        .doc(widget.currentName)
                                        .collection('letters')
                                        .snapshots(),
                                    builder: (context, snapshot) {
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

                                        Counter.correctLetterCounter = getCL;
                                        Counter.wrongLetterCounter = getWL;
                                      }
                                      return Container();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPage27(
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
                        radius: currentHeight / 22,
                        child: Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: currentHeight / 24,
                        ),
                      ),
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
          print('_TestSpeechState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void onCurrentLocale(String locale) {
    print('_TestSpeechState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });
  }

  void onRecognitionComplete(String text) {
    print('_TestSpeechState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
    if (text == 'y' || text == 'niyə') {
      isMatched = true;
      correct = true;
      Counter.correctLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
      _Next();
    }
    if (text != 'y' && text != 'niyə' && text != '') {
      isMatched = false;
      wrong = true;
      Counter.wrongLetterCounter++;
      _firestore
          .collection('Statistics')
          .doc("${_auth.currentUser!.email}")
          .collection('children')
          .doc(widget.currentName)
          .collection('letters')
          .doc('letters')
          .update({
        "correct_letters": Counter.correctLetterCounter,
        "wrong_letters": Counter.wrongLetterCounter,
      });
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

class Congrats extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const Congrats({Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<Congrats> createState() => _Congrats();
}

class _Congrats extends State<Congrats> {
  bool _play = false;

  @override
  initState() {
    setState(() {
      _play = true;
    });
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    final double currentHeight = MediaQuery.of(context).size.height;
    final double currentWidht = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: AudioWidget.assets(
          loopMode: LoopMode.none,
          path: "audios/Cong.mp3",
          play: _play,
          volume: 0.5,
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('imgs/Cong.jpeg'),
                fit: BoxFit.fill,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(height: currentHeight / 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'أحسنت',
                          style: TextStyle(
                              fontSize: currentHeight / 4, color: Colors.green),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          onPressed: () {
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          splashColor: Colors.amber,
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
                        MaterialButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => childStatistics(
                                    id_st: widget.childID,
                                    avatar_url_st: widget.currentAvatar,
                                    name_st: widget.currentName,
                                  ),
                                ),
                                (Route<dynamic> route) => false);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          splashColor: Colors.amber,
                          child: CircleAvatar(
                            backgroundColor:
                                const Color.fromRGBO(245, 171, 0, 1),
                            radius: currentHeight / 16,
                            child: Icon(
                              Icons.add_chart_sharp,
                              color: Colors.white,
                              size: currentHeight / 14,
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
