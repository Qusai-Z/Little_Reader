// ignore_for_file: non_constant_identifier_names, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:little_reader/services/database.dart';
import 'package:little_reader/views/home/home.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

const languages = const [
  const Language('Arabic', 'ar-Ar'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

enum TtsState { playing, stopped, paused, continued }

class WordsPage extends StatefulWidget {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1;
  double pitch = 0.4;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'أَسَدْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 0.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage2(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Lion.jpeg',
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
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
    DatabaseServices db = DatabaseServices();
    setState(() {
      transcription = text;
    });

    if (transcription == 'اسد') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      await _Next();
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
  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage2(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage2 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage2(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage2> createState() => _WordsPageState2();
}

class _WordsPageState2 extends State<WordsPage2> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  late double volume;
  late double pitch;
  late double rate;
  bool isCurrentLanguageInstalled = false;

  String? word = 'أَرْنَبْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    activateSpeechRecognizer();

    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage3(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Rabbit.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'أرنب',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'ارنب') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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
  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage3(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage3 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage3(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage3> createState() => _WordsPageState3();
}

class _WordsPageState3 extends State<WordsPage3> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'أَنَنَاسْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage4(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Pineapple.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 0.8,
                                ),
                                Text(
                                  'أناناس',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage2(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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
    DatabaseServices db = DatabaseServices();

    setState(() {
      transcription = text;
    });

    if (transcription == 'اناناس') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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
  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage4(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage4 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage4(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage4> createState() => _WordsPageState4();
}

class _WordsPageState4 extends State<WordsPage4> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'بَطّة';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage5(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Duck.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'بطة',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage3(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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
    DatabaseServices db = DatabaseServices();

    setState(() {
      transcription = text;
    });

    if (transcription == 'بطه') {
      isMatched = true;
      correct = true;
      _Next();
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
  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage5(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage5 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage5(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage5> createState() => _WordsPageState5();
}

class _WordsPageState5 extends State<WordsPage5> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'بَيْتْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage6(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/House.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'بيت',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage4(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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
    DatabaseServices db = DatabaseServices();

    setState(() {
      transcription = text;
    });

    if (transcription == 'بيت') {
      isMatched = true;
      correct = true;
      _Next();
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
  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage6(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage6 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage6(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage6> createState() => _WordsPageState6();
}

class _WordsPageState6 extends State<WordsPage6> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'بُومَه';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage7(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Owl.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'بومه',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage5(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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
    DatabaseServices db = DatabaseServices();

    setState(() {
      transcription = text;
    });

    if (transcription == 'بومه') {
      isMatched = true;
      correct = true;
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage7(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage7 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage7(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage7> createState() => _WordsPageState7();
}

class _WordsPageState7 extends State<WordsPage7> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'تُفّاحَه';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage8(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Apple.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'تفاحة',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage6(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'تفاحه') {
      isMatched = true;
      correct = true;
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage8(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage8 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage8(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage8> createState() => _WordsPageState8();
}

class _WordsPageState8 extends State<WordsPage8> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'تِمْسَاحْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage9(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Crocodile.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'تمساح',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage7(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'تمساح') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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
  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage9(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage9 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage9(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage9> createState() => _WordsPageState9();
}

class _WordsPageState9 extends State<WordsPage9> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'تاجْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage10(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Crown.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'تاج',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage8(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'تاج') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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
  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage10(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage10 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage10(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage10> createState() => _WordsPageState10();
}

class _WordsPageState10 extends State<WordsPage10> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'ثَعْلَبْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage11(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Fox.png',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'ثعلب',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage9(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'ثعلب') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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
  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage11(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage11 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage11(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage11> createState() => _WordsPageState11();
}

class _WordsPageState11 extends State<WordsPage11> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'ثُومْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1);
    await flutterTts.setSpeechRate(rate = 0.3);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage12(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Garlic.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'ثوم',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage10(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'ثوم') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage12(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage12 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage12(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage12> createState() => _WordsPageState12();
}

class _WordsPageState12 extends State<WordsPage12> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'ثَالْج';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.5);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage13(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Ice.png',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'ثلج',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage11(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'ثلج' ||
        transcription == 'هل' ||
        transcription == 'سالي') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage13(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage13 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage13(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage13> createState() => _WordsPageState13();
}

class _WordsPageState13 extends State<WordsPage13> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'جَمَلْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.5);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage14(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Camel.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'جمل',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage12(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'جمل') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage14(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage14 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage14(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage14> createState() => _WordsPageState14();
}

class _WordsPageState14 extends State<WordsPage14> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'جَزَرَه';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.5);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage15(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Carrot.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'جزرة',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage13(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'جزره') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage15(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage15 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage15(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage15> createState() => _WordsPageState15();
}

class _WordsPageState15 extends State<WordsPage15> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'جَرَسْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage16(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Bell.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'جرس',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage14(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'جرس') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage16(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage16 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage16(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage16> createState() => _WordsPageState16();
}

class _WordsPageState16 extends State<WordsPage16> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'حَمَامَه';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage17(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Pigeon.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'حمامة',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage15(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'حمامه') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage17(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage17 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage17(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage17> createState() => _WordsPageState17();
}

class _WordsPageState17 extends State<WordsPage17> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'حِصَانْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.5);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage18(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Horse.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'حصان',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage16(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'حصان') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage18(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage18 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage18(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage18> createState() => _WordsPageState18();
}

class _WordsPageState18 extends State<WordsPage18> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'حوتّ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage19(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Whale.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'حوت',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage17(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'حوت') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage19(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage19 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage19(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage19> createState() => _WordsPageState19();
}

class _WordsPageState19 extends State<WordsPage19> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'خَروفْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage20(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Sheep.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'خروف',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage18(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'خروف') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage20(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage20 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage20(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage20> createState() => _WordsPageState20();
}

class _WordsPageState20 extends State<WordsPage20> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'خُفّااشْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.3);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage21(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Bat.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'خفاش',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage19(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'خفاش') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage21(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage21 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage21(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage21> createState() => _WordsPageState21();
}

class _WordsPageState21 extends State<WordsPage21> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'خَيمَا';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage22(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Tent.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'خيمة',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage20(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'خيمه') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage22(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage22 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage22(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage22> createState() => _WordsPageState22();
}

class _WordsPageState22 extends State<WordsPage22> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'دَجَاجا';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage23(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Chicken.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'دجاجة',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage21(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'دجاجه') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage23(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage23 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage23(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage23> createState() => _WordsPageState23();
}

class _WordsPageState23 extends State<WordsPage23> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'دولْفيينْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage24(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Dolfyne.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'دولفين',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage22(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'دولفين') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage24(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage24 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage24(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage24> createState() => _WordsPageState24();
}

class _WordsPageState24 extends State<WordsPage24> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'دايْنَاصورْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage25(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Dinasour.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'ديناصور',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage23(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'ديناصور') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage25(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage25 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage25(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage25> createState() => _WordsPageState25();
}

class _WordsPageState25 extends State<WordsPage25> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'ذُرا';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage26(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Corn.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'ذره',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage24(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'ذره' || transcription == 'نوره') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage26(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage26 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage26(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage26> createState() => _WordsPageState26();
}

class _WordsPageState26 extends State<WordsPage26> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'ذَهَبْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage27(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Gold.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'ذهب',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage25(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'ذهب') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage27(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage27 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage27(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage27> createState() => _WordsPageState27();
}

class _WordsPageState27 extends State<WordsPage27> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'ذُباباه';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage28(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Fly.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'ذبابة',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage26(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'ذبابه' || transcription == 'لبابه') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage28(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage28 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage28(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage28> createState() => _WordsPageState28();
}

class _WordsPageState28 extends State<WordsPage28> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'رُمّانْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage29(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Pomegranate.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'رمان',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage27(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'رمان') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage29(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage29 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage29(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage29> createState() => _WordsPageState29();
}

class _WordsPageState29 extends State<WordsPage29> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'رِيشَهْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage30(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Feather.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'ريشة',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage28(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'ريشه') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage30(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage30 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage30(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage30> createState() => _WordsPageState30();
}

class _WordsPageState30 extends State<WordsPage30> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'رَجُلْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage31(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Man.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'رجل',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage29(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'رجل') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage31(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage31 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage31(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage31> createState() => _WordsPageState31();
}

class _WordsPageState31 extends State<WordsPage31> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'زَرافَهْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage32(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Giraffe.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'زرافة',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage30(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'زرافه') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage32(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage32 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage32(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage32> createState() => _WordsPageState32();
}

class _WordsPageState32 extends State<WordsPage32> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'زَنْجَبييلْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage33(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Ginger.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'زنجبيل',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage31(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'زنجبيل') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage33(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage33 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage33(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage33> createState() => _WordsPageState33();
}

class _WordsPageState33 extends State<WordsPage33> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'زجاجا';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage34(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Glass.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'زجاجة',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage32(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'زجاجه') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage34(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage34 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage34(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage34> createState() => _WordsPageState34();
}

class _WordsPageState34 extends State<WordsPage34> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'سَمَكَه';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage35(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Fish.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'سمكة',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage33(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'سمكه') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage35(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage35 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage35(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage35> createState() => _WordsPageState35();
}

class _WordsPageState35 extends State<WordsPage35> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'سِياراْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage36(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Car.png',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'سيارة',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage34(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'سياره') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage36(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage36 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage36(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage36> createState() => _WordsPageState36();
}

class _WordsPageState36 extends State<WordsPage36> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'سَريرْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage37(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Bed.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'سرير',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage35(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'سرير') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage37(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage37 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage37(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage37> createState() => _WordsPageState37();
}

class _WordsPageState37 extends State<WordsPage37> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'شَجَرا';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage38(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Tree.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'شجرة',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage36(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'شجره') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage38(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage38 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage38(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage38> createState() => _WordsPageState38();
}

class _WordsPageState38 extends State<WordsPage38> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'شَمْسْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage39(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Sun.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'شمس',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage37(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'شمس') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage39(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage39 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage39(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage39> createState() => _WordsPageState39();
}

class _WordsPageState39 extends State<WordsPage39> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'شَمْعَهْ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage40(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Candle.png',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'شمعة',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage33(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'شمعه') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage40(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage40 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage40(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage40> createState() => _WordsPageState40();
}

class _WordsPageState40 extends State<WordsPage40> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'صارُووخ';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage41(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Rocket.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'صاروخ',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage39(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'صاروخ') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage41(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage41 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage41(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage41> createState() => _WordsPageState41();
}

class _WordsPageState41 extends State<WordsPage41> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'صٌفّارَه';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                            builder: (context) => WordsPage42(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Whistle.png',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 3,
                                ),
                                Text(
                                  'صفارة',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage40(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'صفاره') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      _Next();
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

  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WordsPage42(
              childID: widget.childID,
              currentAvatar: widget.currentAvatar,
              currentName: widget.currentName,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      });
}

class WordsPage42 extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;
  const WordsPage42(
      {Key? key, this.childID, this.currentAvatar, this.currentName})
      : super(key: key);

  @override
  State<WordsPage42> createState() => _WordsPageState42();
}

class _WordsPageState42 extends State<WordsPage42> {
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

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 1.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  String? word = 'صقر';

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  @override
  initState() {
    setState(() {
      play = true;
    });
    activateSpeechRecognizer();
    initTts();
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

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultVoice();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    if (isAndroid) {
      flutterTts.setInitHandler(() {
        setState(() {
          print("TTS Initialized");
        });
      });
    }

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() async => await flutterTts.getLanguages;

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume = 1.5);
    await flutterTts.setSpeechRate(rate = 0.4);
    await flutterTts.setPitch(pitch = 1);
    await flutterTts.setLanguage('ar');

    if (word != null) {
      if (word!.isNotEmpty) {
        await flutterTts.speak(word!);
      }
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = 'name: ar-xa-x-arz-local, locale: ar';
      flutterTts.setLanguage('ar');
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
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
                        //     builder: (context) => WordsPage43(
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
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset(
                                  'imgs/Falcon.jpeg',
                                  height: currentHeight / 2.4,
                                  width: currentWidht / 1,
                                ),
                                Text(
                                  'صقر',
                                  style: TextStyle(
                                      fontSize: currentHeight / 11,
                                      color: isMatched == true
                                          ? colorGreen
                                          : isMatched == false
                                              ? colorRed
                                              : Colors.black),
                                ),
                                SizedBox(
                                  height: currentHeight / 20,
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
                                                    )),
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
                                    MaterialButton(
                                      onPressed: () => _speak(),
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
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 20,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WordsPage41(
                                childID: widget.childID,
                                currentAvatar: widget.currentAvatar,
                                currentName: widget.currentName,
                              ),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
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

    if (transcription == 'صقر') {
      isMatched = true;
      correct = true;
      print('MM:$isMatched');
      // _Next();
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

  //  Future _Next() => Future.delayed(const Duration(seconds: 1), () {
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => WordsPage43(
  //             childID: widget.childID,
  //             currentAvatar: widget.currentAvatar,
  //             currentName: widget.currentName,
  //           ),
  //         ),
  //         (Route<dynamic> route) => false,
  //       );
  //     });
}
