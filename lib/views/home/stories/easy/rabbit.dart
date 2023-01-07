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

import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'dart:io';

List<String> list = [];
List<String> match_list = [];

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

  void matchingWords() async {
    List<String> text_word = [].toString().split(' ');
    text_word.add(list.toString());
    final url = Uri.parse('https://littlereader.azurewebsites.net/AI_System');
    for (var i = 0; i < text_word.length; i++) {
      final response = await http.post(url,
          body: json.encode(
              {'Child_word': transcription, 'Text_word': text_word[i]}));

      print('response: $response');
    }
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
                                text1: content,
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
                    backgroundColor: Color.fromRGBO(245, 171, 0, 1),
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
                    backgroundColor: Color.fromRGBO(245, 171, 0, 1),
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
                    onTap: () {
                      if (_speechRecognitionAvailable && !_isListening) {
                        start();
                      }
                      null;
                    },
                    child: CircleAvatar(
                      backgroundColor: Color.fromRGBO(245, 171, 0, 1),
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
                    child: CircleAvatar(
                      backgroundColor: Color.fromRGBO(245, 171, 0, 1),
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
                      backgroundColor: Color.fromRGBO(245, 171, 0, 1),
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

    //matchingWords();
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

class Content_1 extends StatelessWidget {
  String text1;
  Content_1({Key? key, required this.text1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 35),
      child: Text(
        text1,
        style: TextStyle(color: Colors.black, fontSize: currentHeight / 19),
      ),
    );
  }
}
