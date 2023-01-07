import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:little_reader/views/home/home.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

const languages = const [
  const Language('Arabic', 'ar-Ar'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class WordsPage extends StatefulWidget {
  static const String ScreenRoute = 'letters_page';
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage> createState() => _WordsPageState();
}

class _WordsPageState extends State<WordsPage> {
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
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => LettersPage2(
                        //       childID: widget.childID,
                        //       currentAvatar: widget.currentAvatar,
                        //       currentName: widget.currentName,
                        //     ),
                        //   ),
                        //   (Route<dynamic> route) => false,
                        // );
                        //
                      },
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
                              Image.asset(
                                'imgs/Lion.jpg',
                                height: currentHeight / 2.3,
                                width: currentWidht / 1,
                              ),
                              Text(
                                'أسد',
                                style: TextStyle(
                                    fontSize: currentHeight / 10,
                                    color: isMatched == true
                                        ? colorGreen
                                        : isMatched == false
                                            ? colorRed
                                            : Colors.black),
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
    String? complete;
    print('_TestSpeechState.onRecognitionResult... $text');

    setState(() {
      transcription = text;
    });

    if (transcription == 'الف') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
    } else {
      isMatched = false;
      wrong = true;

      print('MM:$isMatched');
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
}
