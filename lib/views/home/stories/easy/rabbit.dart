// import 'dart:convert';
// import 'dart:ui';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;

// class WordsPage extends StatefulWidget {
//   static const String ScreenRoute = 'words_page';
//   WordsPage({Key? key}) : super(key: key);

//   @override
//   _WordsPageState createState() => _WordsPageState();
// }

// class _WordsPageState extends State<WordsPage> {
//   var recorder = FlutterSoundRecorder();

//   var reciever;
//   String resultText = "";

//   bool isReady = false;

//   Future stop() async {
//     if (!isReady) return;

//     await recorder.stopRecorder();

//     final url = Uri.parse('https://littlereader.azurewebsites.net/AI_System');

//     final response =
//         await http.post(url, body: json.encode({'Speech_AI': reciever}));
//     print('path :   $recorder}');
//     print('response: $response');
//   }

//   Future record() async {
//     if (!isReady) return;
//     await recorder.startRecorder(toFile: 'audio');

//     setState(() {
//       reciever = recorder;
//     });
//   }

//   Future RecieveAction() async {
//     final url = Uri.parse('https://littlereader.azurewebsites.net/AI_System');

//     final response = await http.get(url);

//     if (response.body.isNotEmpty) {
//       final decoded = json.decode(response.body);

//       setState(() {
//         reciever = decoded['AI_System'];
//         print('AI_RESPONSE: $reciever');
//       });
//     }
//   }

//   Future initRecorder() async {
//     final status = await Permission.microphone.request();

//     if (status != PermissionStatus.granted) {
//       throw 'المايكروفون غير مفعل';
//     }

//     await recorder.openRecorder();

//     isReady = true;

//     recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
//   }

//   @override
//   void initState() {
//     super.initState();

//     initRecorder();
//   }

//   @override
//   void dispose() {
//     recorder.closeRecorder();

//     super.dispose();
//   }

//   /// This has to happen only once per app

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Speech Demo'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               resultText,
//               style: const TextStyle(fontSize: 20, color: Colors.black),
//             ),
//             StreamBuilder<RecordingDisposition>(
//               stream: recorder.onProgress,
//               builder: (context, snapshot) {
//                 final duration =
//                     snapshot.hasData ? snapshot.data!.duration : Duration.zero;

//                 return Text('${duration.inSeconds} s');
//               },
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 if (recorder.isRecording) {
//                   await stop();
//                 } else {
//                   await record();
//                 }
//                 RecieveAction();

//                 setState(() {});
//               },
//               child: Icon(recorder.isRecording ? Icons.stop : Icons.mic),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 RecieveAction();
//               },
//               child: const Text('GET'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ignore_for_file: unrelated_type_equality_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';

List<String> list = [];

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(TestSpeech());
}

const languages = const [
  const Language('Arabic', 'ar-Ar'),
];

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class TestSpeech extends StatefulWidget {
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
  @override
  _TestSpeechState createState() => _TestSpeechState();
}

class _TestSpeechState extends State<TestSpeech> {
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
    print('_TestSpeechState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
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
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    height: currentHeight / 2.5,
                    width: currentWidht / 1.4,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('Stories')
                          .where('ID', isEqualTo: 'Sy_Tortoise_And_Hare')
                          .snapshots(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                    radius: currentHeight / 28,
                    child: IconButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   PageTransition(
                        //       child: const LettersPage2(),
                        //       duration: const Duration(milliseconds: 120),
                        //       type: PageTransitionType.leftToRight),
                        // );
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: currentHeight / 28,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                    radius: currentHeight / 28,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: currentHeight / 28,
                      ),
                    ),
                  ),
                ],
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
                    onTap: _isListening ? () => stop() : null,
                    child: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(245, 171, 0, 1),
                      radius: currentHeight / 16,
                      child: Icon(
                        Icons.square,
                        color: Colors.white,
                        size: currentHeight / 14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  GestureDetector(
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
            ],
          ),
        ),
      ),
    );
  }

  void cancel() =>
      _speech.cancel().then((_) => setState(() => _isListening = false));

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

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionComplete(String text) {
    print('_MyAppState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
  }

  void onRecognitionResult(String text) async {
    print('_TestSpeechState.onRecognitionResult... $text');

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
      widget.correct16 = true;
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
    }
    if (my_words[16] != 'والقفز') {
      widget.isMatched16 = false;
      widget.wrong16 = true;
    } else {
      print('Finished');
    }
  }

  void errorHandler() => activateSpeechRecognizer();

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
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
