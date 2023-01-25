import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:little_reader/views/home/letters/letters.dart';
import 'package:little_reader/views/home/words/words.dart';
import 'package:little_reader/views/registeration/inf_entry/accounts.dart';
import '../registeration/inf_entry/first_page.dart';
import 'stories/stories.dart';

class Home extends StatefulWidget {
  // ignore: constant_identifier_names
  static const String ScreenRoute = 'home';

  final String? childID;
  final String? currentAvatar;
  final String? currentName;

  const Home({
    Key? key,
    this.childID,
    this.currentAvatar,
    this.currentName,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _play = false;

  final _key = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;

//initState is run when the app runs
  @override
  void initState() {
    setState(() {
      _play = !_play;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentwidth = MediaQuery.of(context).size.width;
    WidgetsFlutterBinding.ensureInitialized();

    //these lines of code to make the screen in horizontal state
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: currentHeight / 11,
          leadingWidth: 430,
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          actions: [
            CircleAvatar(
              backgroundImage: const NetworkImage(
                  'https://pbs.twimg.com/media/FjnKOl2XkAAqSKD?format=jpg&name=360x360'),
              radius: currentHeight / 26,
            ),
            const SizedBox(
              width: 15,
            ),
            Container(
              color: Colors.white,
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.currentAvatar!),
                radius: currentHeight / 16,
              ),
            ),
          ],
          leading: Row(
            children: [
              IconButton(
                onPressed: () {
                  if (widget.childID!.isNotEmpty) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Accounts(
                          childID: widget.childID,
                          currentAvatar: widget.currentAvatar,
                          currentName: widget.currentName,
                        ),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FirstPage()),
                        (Route<dynamic> route) => false);
                  }
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Color.fromRGBO(7, 205, 219, 1),
                ),
                iconSize: currentHeight / 16,
              ),
              const SizedBox(
                width: 50,
              ),
              AudioWidget.assets(
                loopMode: LoopMode.playlist,
                path: "audios/ONSHOODA.mp3",
                volume: 0.7,
                play: _play,
                child: IconButton(
                  onPressed: () {
                    setState(
                      () {
                        if (_play == true) {
                          _play = false;
                        } else {
                          if (_play == false) {
                            _play = true;
                          }
                        }
                      },
                    );
                  },
                  icon: Icon(
                    _play == true ? Icons.music_note : Icons.music_off,
                    color: const Color.fromRGBO(7, 205, 219, 1),
                  ),
                  iconSize: currentHeight / 16,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('imgs/guarden.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // ignore: sized_box_for_whitespace
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: currentHeight / 4,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 30,
                            color: const Color.fromRGBO(255, 166, 0, 1),
                            splashColor: const Color.fromRGBO(149, 22, 224, 1),
                            onPressed: () {
                              setState(() {
                                _play = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WordsPage(
                                    currentAvatar: widget.currentAvatar,
                                    childID: widget.childID,
                                    currentName: widget.currentName,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'كلمات',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Lalezar',
                                  fontStyle: FontStyle.italic,
                                  fontSize: currentwidth / 18),
                            ),
                          ),
                        ),
                      ),
                      // ignore: sized_box_for_whitespace
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: currentHeight / 3,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 30,
                            color: const Color.fromRGBO(255, 166, 0, 1),
                            splashColor: const Color.fromRGBO(149, 22, 224, 1),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoriesPage(
                                    currentAvatar: widget.currentAvatar,
                                    childID: widget.childID,
                                    currentName: widget.currentName,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'قصص',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Lalezar',
                                  fontStyle: FontStyle.italic,
                                  fontSize: currentwidth / 18),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          height: currentHeight / 4,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 30,
                            color: const Color.fromRGBO(255, 166, 0, 1),
                            splashColor: const Color.fromRGBO(149, 22, 224, 1),
                            onPressed: () {
                              setState(() {
                                _play = false;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LettersPage(
                                    currentAvatar: widget.currentAvatar,
                                    childID: widget.childID,
                                    currentName: widget.currentName,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'حروف',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Lalezar',
                                  fontStyle: FontStyle.italic,
                                  fontSize: currentwidth / 18),
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
}

class Level1 extends StatelessWidget {
  final String level1;
  String? id;

  Level1({Key? key, required this.level1, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return CircleAvatar(
      backgroundImage: NetworkImage(level1),
      radius: currentHeight / 32,
    );
  }
}
