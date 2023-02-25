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

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class LettersPageNotSignedIn extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn> createState() => _LettersPageNotSignedInState();
}

class _LettersPageNotSignedInState extends State<LettersPageNotSignedIn> {
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
                            builder: (context) => LettersPageNotSignedIn2(
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

      _Next();
    }
    if (text != 'əlif' && text != '') {
      isMatched = false;
      wrong = true;
    }
  }

  void errorHandler() => activateSpeechRecognizer();

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LettersPageNotSignedIn2(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn2 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page2';

  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn2(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn2> createState() =>
      _LettersPageNotSignedInState2();
}

class _LettersPageNotSignedInState2 extends State<LettersPageNotSignedIn2> {
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
                            builder: (context) => LettersPageNotSignedIn3(
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
                            builder: (context) => LettersPageNotSignedIn(
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

      _Next();
    }
    if (text != 'b' && text != 'və' && text != 'bəə' && text != '') {
      isMatched = false;
      wrong = true;
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
            builder: (context) => LettersPageNotSignedIn3(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn3 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn3(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn3> createState() =>
      _LettersPageNotSignedInState3();
}

class _LettersPageNotSignedInState3 extends State<LettersPageNotSignedIn3> {
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
                            builder: (context) => LettersPageNotSignedIn4(
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
                            builder: (context) => LettersPageNotSignedIn2(
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
            builder: (context) => LettersPageNotSignedIn4(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn4 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page2';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn4(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn4> createState() =>
      _LettersPageNotSignedInState4();
}

class _LettersPageNotSignedInState4 extends State<LettersPageNotSignedIn4> {
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
                            builder: (context) => LettersPageNotSignedIn5(
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
                            builder: (context) => LettersPageNotSignedIn3(
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
            builder: (context) => LettersPageNotSignedIn5(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn5 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn5(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn5> createState() =>
      _LettersPageNotSignedInState5();
}

class _LettersPageNotSignedInState5 extends State<LettersPageNotSignedIn5> {
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
                            builder: (context) => LettersPageNotSignedIn6(
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
                            builder: (context) => LettersPageNotSignedIn4(
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
            builder: (context) => LettersPageNotSignedIn6(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn6 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page2';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn6(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn6> createState() =>
      _LettersPageNotSignedInState6();
}

class _LettersPageNotSignedInState6 extends State<LettersPageNotSignedIn6> {
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
                            builder: (context) => LettersPageNotSignedIn7(
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
                            builder: (context) => LettersPageNotSignedIn5(
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

      _Next();
    }
    if (text != 'ə' &&
        text != 'səhər' &&
        text != 'hə' &&
        text != 'şa' &&
        text != '') {
      isMatched = false;
      wrong = true;
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
            builder: (context) => LettersPageNotSignedIn7(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn7 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn7(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn7> createState() =>
      _LettersPageNotSignedInState7();
}

class _LettersPageNotSignedInState7 extends State<LettersPageNotSignedIn7> {
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
                            builder: (context) => LettersPageNotSignedIn8(
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
                            builder: (context) => LettersPageNotSignedIn6(
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
            builder: (context) => LettersPageNotSignedIn8(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn8 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn8(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn8> createState() =>
      _LettersPageNotSignedInState8();
}

class _LettersPageNotSignedInState8 extends State<LettersPageNotSignedIn8> {
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
                              builder: (context) => LettersPageNotSignedIn9(
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
                            builder: (context) => LettersPageNotSignedIn7(
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
            builder: (context) => LettersPageNotSignedIn9(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn9 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn9(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn9> createState() =>
      _LettersPageNotSignedInState9();
}

class _LettersPageNotSignedInState9 extends State<LettersPageNotSignedIn9> {
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
                            builder: (context) => LettersPageNotSignedIn10(
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
                            builder: (context) => LettersPageNotSignedIn8(
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
            builder: (context) => LettersPageNotSignedIn10(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn10 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn10(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn10> createState() =>
      _LettersPageNotSignedInState10();
}

class _LettersPageNotSignedInState10 extends State<LettersPageNotSignedIn10> {
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
                            builder: (context) => LettersPageNotSignedIn11(
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
                            builder: (context) => LettersPageNotSignedIn9(
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
            builder: (context) => LettersPageNotSignedIn11(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn11 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn11(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn11> createState() =>
      _LettersPageNotSignedInState11();
}

class _LettersPageNotSignedInState11 extends State<LettersPageNotSignedIn11> {
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
                            builder: (context) => LettersPageNotSignedIn12(
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
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPageNotSignedIn10(
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

      _Next();
    }
    if (text != 'zəy' &&
        text != 'səh' &&
        text != 'zərf' &&
        text != 'zəif' &&
        text != '') {
      isMatched = false;
      wrong = true;
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
            builder: (context) => LettersPageNotSignedIn12(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn12 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn12(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn12> createState() =>
      _LettersPageNotSignedInState12();
}

class _LettersPageNotSignedInState12 extends State<LettersPageNotSignedIn12> {
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
                            builder: (context) => LettersPageNotSignedIn13(
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
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPageNotSignedIn11(
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

      _Next();
    }
    if (text != 'seyid' &&
        text != 'sen' &&
        text != 'sin' &&
        text != 'sil' &&
        text != '') {
      isMatched = false;
      wrong = true;
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
            builder: (context) => LettersPageNotSignedIn13(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn13 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn13(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn13> createState() =>
      _LettersPageNotSignedInState13();
}

class _LettersPageNotSignedInState13 extends State<LettersPageNotSignedIn13> {
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
                            builder: (context) => LettersPageNotSignedIn14(
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
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPageNotSignedIn12(
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

      _Next();
    }
    if (text != 'şirin' && text != 'şeir' && text != '') {
      isMatched = false;
      wrong = true;
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
            builder: (context) => LettersPageNotSignedIn14(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn14 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn14(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn14> createState() =>
      _LettersPageNotSignedInState14();
}

class _LettersPageNotSignedInState14 extends State<LettersPageNotSignedIn14> {
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
                            builder: (context) => LettersPageNotSignedIn15(
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
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPageNotSignedIn13(
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
            builder: (context) => LettersPageNotSignedIn15(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn15 extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn15(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn15> createState() =>
      _LettersPageNotSignedInState15();
}

class _LettersPageNotSignedInState15 extends State<LettersPageNotSignedIn15> {
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
                            builder: (context) => LettersPageNotSignedIn16(
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
                            builder: (context) => LettersPageNotSignedIn14(
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
            builder: (context) => LettersPageNotSignedIn16(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn16 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn16(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn16> createState() =>
      _LettersPageNotSignedInState16();
}

class _LettersPageNotSignedInState16 extends State<LettersPageNotSignedIn16> {
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
                            builder: (context) => LettersPageNotSignedIn17(
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
                            builder: (context) => LettersPageNotSignedIn15(
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
            builder: (context) => LettersPageNotSignedIn17(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn17 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn17(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn17> createState() =>
      _LettersPageNotSignedInState17();
}

class _LettersPageNotSignedInState17 extends State<LettersPageNotSignedIn17> {
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
                            builder: (context) => LettersPageNotSignedIn18(
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
                            builder: (context) => LettersPageNotSignedIn16(
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

      _Next();
    }
    if (text != 'o' &&
        text != 'var' &&
        text != 'y' &&
        text != 'wap' &&
        text != '') {
      isMatched = false;
      wrong = true;
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
            builder: (context) => LettersPageNotSignedIn18(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn18 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn18(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn18> createState() =>
      _LettersPageNotSignedInState18();
}

class _LettersPageNotSignedInState18 extends State<LettersPageNotSignedIn18> {
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
                            builder: (context) => LettersPageNotSignedIn19(
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
                            builder: (context) => LettersPageNotSignedIn17(
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

      _Next();
    }
    if (text != 'əyin' && text != 'həyat' && text != 'təyin' && text != '') {
      isMatched = false;
      wrong = true;
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
            builder: (context) => LettersPageNotSignedIn19(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn19 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn19(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn19> createState() =>
      _LettersPageNotSignedInState19();
}

class _LettersPageNotSignedInState19 extends State<LettersPageNotSignedIn19> {
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
                            builder: (context) => LettersPageNotSignedIn20(
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
                            builder: (context) => LettersPageNotSignedIn18(
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
            builder: (context) => LettersPageNotSignedIn20(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn20 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn20(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn20> createState() =>
      _LettersPageNotSignedInState20();
}

class _LettersPageNotSignedInState20 extends State<LettersPageNotSignedIn20> {
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
                            builder: (context) => LettersPageNotSignedIn21(
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
                            builder: (context) => LettersPageNotSignedIn19(
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

      _Next();
    }
    if (text != 'sifətə' && text != 'f' && text != 'fb' && text != '') {
      isMatched = false;
      wrong = true;
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
            builder: (context) => LettersPageNotSignedIn21(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn21 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn21(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn21> createState() =>
      _LettersPageNotSignedInState21();
}

class _LettersPageNotSignedInState21 extends State<LettersPageNotSignedIn21> {
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
                            builder: (context) => LettersPageNotSignedIn22(
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
                            builder: (context) => LettersPageNotSignedIn20(
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
            builder: (context) => LettersPageNotSignedIn22(
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
class LettersPageNotSignedIn22 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn22(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn22> createState() =>
      _LettersPageNotSignedInState22();
}

class _LettersPageNotSignedInState22 extends State<LettersPageNotSignedIn22> {
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
                            builder: (context) => LettersPageNotSignedIn23(
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
                            builder: (context) => LettersPageNotSignedIn21(
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
            builder: (context) => LettersPageNotSignedIn23(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn23 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn23(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn23> createState() =>
      _LettersPageNotSignedInState23();
}

class _LettersPageNotSignedInState23 extends State<LettersPageNotSignedIn23> {
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
                            builder: (context) => LettersPageNotSignedIn24(
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
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPageNotSignedIn22(
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
            builder: (context) => LettersPageNotSignedIn24(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn24 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn24(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn24> createState() =>
      _LettersPageNotSignedInState24();
}

class _LettersPageNotSignedInState24 extends State<LettersPageNotSignedIn24> {
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
                            builder: (context) => LettersPageNotSignedIn25(
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
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPageNotSignedIn23(
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
            builder: (context) => LettersPageNotSignedIn25(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn25 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn25(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn25> createState() =>
      _LettersPageNotSignedInState25();
}

class _LettersPageNotSignedInState25 extends State<LettersPageNotSignedIn25> {
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
                            builder: (context) => LettersPageNotSignedIn26(
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
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPageNotSignedIn24(
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
            builder: (context) => LettersPageNotSignedIn26(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn26 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn26(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn26> createState() =>
      _LettersPageNotSignedInState26();
}

class _LettersPageNotSignedInState26 extends State<LettersPageNotSignedIn26> {
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
                              builder: (context) => LettersPageNotSignedIn27(
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
                            builder: (context) => LettersPageNotSignedIn25(
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

      _Next();
    }
    if (text != 'hə' && text != 'h' && text != '') {
      isMatched = false;
      wrong = true;
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
            builder: (context) => LettersPageNotSignedIn27(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn27 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn27(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn27> createState() =>
      _LettersPageNotSignedInState27();
}

class _LettersPageNotSignedInState27 extends State<LettersPageNotSignedIn27> {
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
                            builder: (context) => LettersPageNotSignedIn28(
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
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LettersPageNotSignedIn26(
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
            builder: (context) => LettersPageNotSignedIn28(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class LettersPageNotSignedIn28 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const LettersPageNotSignedIn28(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<LettersPageNotSignedIn28> createState() =>
      _LettersPageNotSignedInState28();
}

class _LettersPageNotSignedInState28 extends State<LettersPageNotSignedIn28> {
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
                            builder: (context) => LettersPageNotSignedIn27(
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

      _Next();
    }
    if (text != 'y' && text != 'niyə' && text != '') {
      isMatched = false;
      wrong = true;
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
            builder: (context) => CongratsNotSignedIn(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class CongratsNotSignedIn extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const CongratsNotSignedIn(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<CongratsNotSignedIn> createState() => _CongratsNotSignedIn();
}

class _CongratsNotSignedIn extends State<CongratsNotSignedIn> {
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
                                  builder: (context) => const Home(
                                    childID: '',
                                    currentAvatar: '',
                                    currentName: '',
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
