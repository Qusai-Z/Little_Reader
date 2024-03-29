import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:little_reader/views/home/stories/easy/Three_Bears_And_Girl.dart';
import 'package:little_reader/views/home/stories/easy/Tortoise_And_Hare.dart';
import 'package:little_reader/views/home/stories/easy/Totoise_And_Hare_NotSignedIn.dart';

class StoriesPage extends StatefulWidget {
  final String? childID;
  final String? currentAvatar;
  final String? currentName;

  const StoriesPage(
      {Key? key, this.currentAvatar, this.childID, this.currentName})
      : super(key: key);

  @override
  State<StoriesPage> createState() => _StoriesPageState();
}

class _StoriesPageState extends State<StoriesPage> {
  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;
    WidgetsFlutterBinding.ensureInitialized();

    //these lines of code to make the screen in horizontal state
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: currentHeight / 11,
        leadingWidth: 430,
        backgroundColor: Colors.white,
        actions: [
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
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Color.fromRGBO(7, 205, 219, 1),
              ),
              iconSize: currentHeight / 16,
            ),
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: const Color.fromARGB(255, 255, 236, 192),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  // Expanded(
                  //   child: Stack(
                  //     alignment: Alignment.topRight,
                  //     children: [
                  //       MaterialButton(
                  //         shape: const RoundedRectangleBorder(),
                  //         elevation: 30,
                  //         splashColor: const Color.fromRGBO(149, 22, 224, 1),
                  //         onPressed: () {
                  //           Navigator.pushAndRemoveUntil(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) => TandH(
                  //                       childID: widget.childID,
                  //                       currentAvatar: widget.currentAvatar,
                  //                       currentName: widget.currentName)),
                  //               (Route<dynamic> route) => false);
                  //         },
                  //         child: Container(
                  //           margin: const EdgeInsets.all(10),
                  //           height: currentHeight / 3,
                  //           decoration: BoxDecoration(
                  //             image: const DecorationImage(
                  //               image: AssetImage('imgs/white.png'),
                  //               fit: BoxFit.cover,
                  //             ),
                  //             borderRadius: BorderRadius.circular(10),
                  //           ),
                  //         ),
                  //       ),
                  //       Container(
                  //         margin: const EdgeInsets.only(right: 25, top: 10),
                  //         decoration: const BoxDecoration(
                  //           borderRadius: BorderRadius.only(
                  //             bottomLeft: Radius.circular(20),
                  //             bottomRight: Radius.circular(5),
                  //             topLeft: Radius.circular(5),
                  //             topRight: Radius.circular(5),
                  //           ),
                  //           color: Colors.green,
                  //         ),
                  //         height: currentHeight / 18,
                  //         width: currentWidth / 18,
                  //         child: const Center(
                  //           child: Text(
                  //             'سهل',
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               shadows: <Shadow>[
                  //                 Shadow(
                  //                   offset: Offset(2.0, 2.0),
                  //                   blurRadius: 3.0,
                  //                   color: Color.fromARGB(255, 0, 0, 0),
                  //                 ),
                  //                 Shadow(
                  //                   offset: Offset(6.0, 6.0),
                  //                   blurRadius: 8.0,
                  //                   color: Color.fromARGB(124, 0, 0, 0),
                  //                 ),
                  //               ],
                  //             ),
                  //             maxLines: 1,
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        MaterialButton(
                          shape: const RoundedRectangleBorder(),
                          elevation: 30,
                          splashColor: const Color.fromRGBO(149, 22, 224, 1),
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const storyTest(),
                            //   ),
                            // );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            height: currentHeight / 3,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage('imgs/story_3.jpg'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: currentWidth / 4.8,
                              top: currentHeight / 40),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(5),
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                            color: Colors.green,
                          ),
                          height: currentHeight / 18,
                          width: currentWidth / 18,
                          child: const Center(
                            child: Text(
                              'سهل',
                              style: TextStyle(
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  Shadow(
                                    offset: Offset(6.0, 6.0),
                                    blurRadius: 8.0,
                                    color: Color.fromARGB(124, 0, 0, 0),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Container(
                          width: currentHeight / 3,
                          height: currentHeight / 14,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.brown,
                          ),
                          margin: EdgeInsets.only(
                              right: currentWidth / 10,
                              top: currentHeight / 42),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(2),
                            child: Text(
                              'الماعز والثعلب',
                              style: TextStyle(
                                  fontSize: currentWidth / 66,
                                  fontFamily: 'Lalezar'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        MaterialButton(
                          shape: const RoundedRectangleBorder(),
                          elevation: 30,
                          splashColor: const Color.fromRGBO(149, 22, 224, 1),
                          onPressed: () {
                            // Navigator.pushAndRemoveUntil(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => BandG(
                            //             childID: widget.childID,
                            //             currentAvatar: widget.currentAvatar,
                            //             currentName: widget.currentName)),
                            //     (Route<dynamic> route) => false);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            height: currentHeight / 3,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage('imgs/story_2.jpg'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: currentWidth / 4.8,
                              top: currentHeight / 40),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(5),
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                            color: Colors.green,
                          ),
                          height: currentHeight / 18,
                          width: currentWidth / 18,
                          child: const Center(
                            child: Text(
                              'سهل',
                              style: TextStyle(
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  Shadow(
                                    offset: Offset(6.0, 6.0),
                                    blurRadius: 8.0,
                                    color: Color.fromARGB(124, 0, 0, 0),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Container(
                          width: currentHeight / 3,
                          height: currentHeight / 14,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.brown,
                          ),
                          margin: EdgeInsets.only(
                              right: currentWidth / 10,
                              top: currentHeight / 42),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(2),
                            child: Text(
                              'الفتاة والدببة',
                              style: TextStyle(
                                  fontSize: currentWidth / 66,
                                  fontFamily: 'Lalezar'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        MaterialButton(
                          shape: const RoundedRectangleBorder(),
                          elevation: 30,
                          splashColor: const Color.fromRGBO(149, 22, 224, 1),
                          onPressed: () {
                            if (widget.childID!.isNotEmpty) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TandH(
                                          childID: widget.childID,
                                          currentAvatar: widget.currentAvatar,
                                          currentName: widget.currentName)),
                                  (Route<dynamic> route) => false);
                            } else {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TandHNotSignedIn(
                                          childID: '',
                                          currentAvatar: '',
                                          currentName: '')),
                                  (Route<dynamic> route) => false);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            height: currentHeight / 3,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: AssetImage('imgs/story_1.jpeg'),
                                fit: BoxFit.cover,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: currentWidth / 4.8,
                              top: currentHeight / 40),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(5),
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                            ),
                            color: Colors.green,
                          ),
                          height: currentHeight / 18,
                          width: currentWidth / 18,
                          child: const Center(
                            child: Text(
                              'سهل',
                              style: TextStyle(
                                color: Colors.white,
                                shadows: <Shadow>[
                                  Shadow(
                                    offset: Offset(2.0, 2.0),
                                    blurRadius: 3.0,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  Shadow(
                                    offset: Offset(6.0, 6.0),
                                    blurRadius: 8.0,
                                    color: Color.fromARGB(124, 0, 0, 0),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Container(
                          width: currentHeight / 3,
                          height: currentHeight / 14,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.brown,
                          ),
                          margin: EdgeInsets.only(
                              right: currentWidth / 10,
                              top: currentHeight / 42),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(2),
                            child: Text(
                              'الأرنب والسلحفاة',
                              style: TextStyle(
                                  fontSize: currentWidth / 66,
                                  fontFamily: 'Lalezar'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Stack(
              //         alignment: Alignment.topRight,
              //         children: [
              //           MaterialButton(
              //             shape: const RoundedRectangleBorder(),
              //             elevation: 30,
              //             splashColor: const Color.fromRGBO(149, 22, 224, 1),
              //             onPressed: () {
              //               // Navigator.push(
              //               //   context,
              //               //   MaterialPageRoute(
              //               //     builder: (context) => const storyTest(),
              //               //   ),
              //               // );
              //             },
              //             child: Container(
              //               margin: const EdgeInsets.all(10),
              //               height: currentHeight / 3,
              //               decoration: BoxDecoration(
              //                 image: const DecorationImage(
              //                   image: AssetImage('imgs/white.png'),
              //                   fit: BoxFit.cover,
              //                 ),
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //             ),
              //           ),
              //           Container(
              //             margin: const EdgeInsets.only(right: 25, top: 10),
              //             decoration: const BoxDecoration(
              //               borderRadius: BorderRadius.only(
              //                 bottomLeft: Radius.circular(20),
              //                 bottomRight: Radius.circular(5),
              //                 topLeft: Radius.circular(5),
              //                 topRight: Radius.circular(5),
              //               ),
              //               color: Colors.orange,
              //             ),
              //             height: currentHeight / 18,
              //             width: currentWidth / 18,
              //             child: Center(
              //               child: Text(
              //                 'متوسط',
              //                 style: TextStyle(
              //                   color: Colors.white,
              //                   fontSize: currentHeight / 38,
              //                   shadows: const <Shadow>[
              //                     Shadow(
              //                       offset: Offset(2.0, 2.0),
              //                       blurRadius: 3.0,
              //                       color: Color.fromARGB(255, 0, 0, 0),
              //                     ),
              //                     Shadow(
              //                       offset: Offset(6.0, 6.0),
              //                       blurRadius: 8.0,
              //                       color: Color.fromARGB(124, 0, 0, 0),
              //                     ),
              //                   ],
              //                 ),
              //                 maxLines: 1,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     Expanded(
              //       child: Stack(
              //         alignment: Alignment.topRight,
              //         children: [
              //           MaterialButton(
              //             shape: const RoundedRectangleBorder(),
              //             elevation: 30,
              //             splashColor: const Color.fromRGBO(149, 22, 224, 1),
              //             onPressed: () {
              //               // Navigator.push(
              //               //   context,
              //               //   MaterialPageRoute(
              //               //     builder: (context) => const storyTest(),
              //               //   ),
              //               // );
              //             },
              //             child: Container(
              //               margin: const EdgeInsets.all(10),
              //               height: currentHeight / 3,
              //               decoration: BoxDecoration(
              //                 image: const DecorationImage(
              //                   image: AssetImage('imgs/white.png'),
              //                   fit: BoxFit.cover,
              //                 ),
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //             ),
              //           ),
              //           Container(
              //             margin: const EdgeInsets.only(right: 25, top: 10),
              //             decoration: const BoxDecoration(
              //               borderRadius: BorderRadius.only(
              //                 bottomLeft: Radius.circular(20),
              //                 bottomRight: Radius.circular(5),
              //                 topLeft: Radius.circular(5),
              //                 topRight: Radius.circular(5),
              //               ),
              //               color: Colors.orange,
              //             ),
              //             height: currentHeight / 18,
              //             width: currentWidth / 18,
              //             child: Center(
              //               child: Text(
              //                 'متوسط',
              //                 style: TextStyle(
              //                   color: Colors.white,
              //                   fontSize: currentHeight / 38,
              //                   shadows: const <Shadow>[
              //                     Shadow(
              //                       offset: Offset(2.0, 2.0),
              //                       blurRadius: 3.0,
              //                       color: Color.fromARGB(255, 0, 0, 0),
              //                     ),
              //                     Shadow(
              //                       offset: Offset(6.0, 6.0),
              //                       blurRadius: 8.0,
              //                       color: Color.fromARGB(124, 0, 0, 0),
              //                     ),
              //                   ],
              //                 ),
              //                 maxLines: 1,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     Expanded(
              //       child: Stack(
              //         alignment: Alignment.topRight,
              //         children: [
              //           MaterialButton(
              //             shape: const RoundedRectangleBorder(),
              //             elevation: 30,
              //             splashColor: const Color.fromRGBO(149, 22, 224, 1),
              //             onPressed: () {
              //               // Navigator.push(
              //               //   context,
              //               //   MaterialPageRoute(
              //               //     builder: (context) => const storyTest(),
              //               //   ),
              //               // );
              //             },
              //             child: Container(
              //               margin: const EdgeInsets.all(10),
              //               height: currentHeight / 3,
              //               decoration: BoxDecoration(
              //                 image: const DecorationImage(
              //                   image: AssetImage('imgs/white.png'),
              //                   fit: BoxFit.cover,
              //                 ),
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //             ),
              //           ),
              //           Container(
              //             margin: const EdgeInsets.only(right: 25, top: 10),
              //             decoration: const BoxDecoration(
              //               borderRadius: BorderRadius.only(
              //                 bottomLeft: Radius.circular(20),
              //                 bottomRight: Radius.circular(5),
              //                 topLeft: Radius.circular(5),
              //                 topRight: Radius.circular(5),
              //               ),
              //               color: Colors.orange,
              //             ),
              //             height: currentHeight / 18,
              //             width: currentWidth / 18,
              //             child: Center(
              //               child: Text(
              //                 'متوسط',
              //                 style: TextStyle(
              //                   color: Colors.white,
              //                   fontSize: currentHeight / 38,
              //                   shadows: const <Shadow>[
              //                     Shadow(
              //                       offset: Offset(2.0, 2.0),
              //                       blurRadius: 3.0,
              //                       color: Color.fromARGB(255, 0, 0, 0),
              //                     ),
              //                     Shadow(
              //                       offset: Offset(6.0, 6.0),
              //                       blurRadius: 8.0,
              //                       color: Color.fromARGB(124, 0, 0, 0),
              //                     ),
              //                   ],
              //                 ),
              //                 maxLines: 1,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     Expanded(
              //       child: Stack(
              //         alignment: Alignment.topRight,
              //         children: [
              //           MaterialButton(
              //             shape: const RoundedRectangleBorder(),
              //             elevation: 30,
              //             splashColor: const Color.fromRGBO(149, 22, 224, 1),
              //             onPressed: () {
              //               // Navigator.push(
              //               //   context,
              //               //   MaterialPageRoute(
              //               //     builder: (context) => const storyTest(),
              //               //   ),
              //               // );
              //             },
              //             child: Container(
              //               margin: const EdgeInsets.all(10),
              //               height: currentHeight / 3,
              //               decoration: BoxDecoration(
              //                 image: const DecorationImage(
              //                   image: AssetImage('imgs/white.png'),
              //                   fit: BoxFit.cover,
              //                 ),
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //             ),
              //           ),
              //           Container(
              //             margin: const EdgeInsets.only(right: 25, top: 10),
              //             decoration: const BoxDecoration(
              //               borderRadius: BorderRadius.only(
              //                 bottomLeft: Radius.circular(20),
              //                 bottomRight: Radius.circular(5),
              //                 topLeft: Radius.circular(5),
              //                 topRight: Radius.circular(5),
              //               ),
              //               color: Colors.orange,
              //             ),
              //             height: currentHeight / 18,
              //             width: currentWidth / 18,
              //             child: Center(
              //               child: Text(
              //                 'متوسط',
              //                 style: TextStyle(
              //                   color: Colors.white,
              //                   fontSize: currentHeight / 38,
              //                   shadows: const <Shadow>[
              //                     Shadow(
              //                       offset: Offset(2.0, 2.0),
              //                       blurRadius: 3.0,
              //                       color: Color.fromARGB(255, 0, 0, 0),
              //                     ),
              //                     Shadow(
              //                       offset: Offset(6.0, 6.0),
              //                       blurRadius: 8.0,
              //                       color: Color.fromARGB(124, 0, 0, 0),
              //                     ),
              //                   ],
              //                 ),
              //                 maxLines: 1,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       child: Stack(
              //         alignment: Alignment.topRight,
              //         children: [
              //           MaterialButton(
              //             shape: const RoundedRectangleBorder(),
              //             elevation: 30,
              //             splashColor: const Color.fromRGBO(149, 22, 224, 1),
              //             onPressed: () {
              //               // Navigator.push(
              //               //   context,
              //               //   MaterialPageRoute(
              //               //     builder: (context) => const storyTest(),
              //               //   ),
              //               // );
              //             },
              //             child: Container(
              //               margin: const EdgeInsets.all(10),
              //               height: currentHeight / 3,
              //               decoration: BoxDecoration(
              //                 image: const DecorationImage(
              //                   image: AssetImage('imgs/white.png'),
              //                   fit: BoxFit.cover,
              //                 ),
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //             ),
              //           ),
              //           Container(
              //             margin: const EdgeInsets.only(right: 25, top: 10),
              //             decoration: const BoxDecoration(
              //               borderRadius: BorderRadius.only(
              //                 bottomLeft: Radius.circular(20),
              //                 bottomRight: Radius.circular(5),
              //                 topLeft: Radius.circular(5),
              //                 topRight: Radius.circular(5),
              //               ),
              //               color: Colors.red,
              //             ),
              //             height: currentHeight / 18,
              //             width: currentWidth / 18,
              //             child: const Center(
              //               child: Text(
              //                 'صعب',
              //                 style: TextStyle(
              //                   color: Colors.white,
              //                   shadows: <Shadow>[
              //                     Shadow(
              //                       offset: Offset(2.0, 2.0),
              //                       blurRadius: 3.0,
              //                       color: Color.fromARGB(255, 0, 0, 0),
              //                     ),
              //                     Shadow(
              //                       offset: Offset(6.0, 6.0),
              //                       blurRadius: 8.0,
              //                       color: Color.fromARGB(124, 0, 0, 0),
              //                     ),
              //                   ],
              //                 ),
              //                 maxLines: 1,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     Expanded(
              //       child: Stack(
              //         alignment: Alignment.topRight,
              //         children: [
              //           MaterialButton(
              //             shape: const RoundedRectangleBorder(),
              //             elevation: 30,
              //             splashColor: const Color.fromRGBO(149, 22, 224, 1),
              //             onPressed: () {
              //               // Navigator.push(
              //               //   context,
              //               //   MaterialPageRoute(
              //               //     builder: (context) => const storyTest(),
              //               //   ),
              //               // );
              //             },
              //             child: Container(
              //               margin: const EdgeInsets.all(10),
              //               height: currentHeight / 3,
              //               decoration: BoxDecoration(
              //                 image: const DecorationImage(
              //                   image: AssetImage('imgs/white.png'),
              //                   fit: BoxFit.cover,
              //                 ),
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //             ),
              //           ),
              //           Container(
              //             margin: const EdgeInsets.only(right: 25, top: 10),
              //             decoration: const BoxDecoration(
              //               borderRadius: BorderRadius.only(
              //                 bottomLeft: Radius.circular(20),
              //                 bottomRight: Radius.circular(5),
              //                 topLeft: Radius.circular(5),
              //                 topRight: Radius.circular(5),
              //               ),
              //               color: Colors.red,
              //             ),
              //             height: currentHeight / 18,
              //             width: currentWidth / 18,
              //             child: const Center(
              //               child: Text(
              //                 'صعب',
              //                 style: TextStyle(
              //                   color: Colors.white,
              //                   shadows: <Shadow>[
              //                     Shadow(
              //                       offset: Offset(2.0, 2.0),
              //                       blurRadius: 3.0,
              //                       color: Color.fromARGB(255, 0, 0, 0),
              //                     ),
              //                     Shadow(
              //                       offset: Offset(6.0, 6.0),
              //                       blurRadius: 8.0,
              //                       color: Color.fromARGB(124, 0, 0, 0),
              //                     ),
              //                   ],
              //                 ),
              //                 maxLines: 1,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     Expanded(
              //       child: Stack(
              //         alignment: Alignment.topRight,
              //         children: [
              //           MaterialButton(
              //             shape: const RoundedRectangleBorder(),
              //             elevation: 30,
              //             splashColor: const Color.fromRGBO(149, 22, 224, 1),
              //             onPressed: () {
              //               // Navigator.push(
              //               //   context,
              //               //   MaterialPageRoute(
              //               //     builder: (context) => const storyTest(),
              //               //   ),
              //               // );
              //             },
              //             child: Container(
              //               margin: const EdgeInsets.all(10),
              //               height: currentHeight / 3,
              //               decoration: BoxDecoration(
              //                 image: const DecorationImage(
              //                   image: AssetImage('imgs/white.png'),
              //                   fit: BoxFit.cover,
              //                 ),
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //             ),
              //           ),
              //           Container(
              //             margin: const EdgeInsets.only(right: 25, top: 10),
              //             decoration: const BoxDecoration(
              //               borderRadius: BorderRadius.only(
              //                 bottomLeft: Radius.circular(20),
              //                 bottomRight: Radius.circular(5),
              //                 topLeft: Radius.circular(5),
              //                 topRight: Radius.circular(5),
              //               ),
              //               color: Colors.red,
              //             ),
              //             height: currentHeight / 18,
              //             width: currentWidth / 18,
              //             child: const Center(
              //               child: Text(
              //                 'صعب',
              //                 style: TextStyle(
              //                   color: Colors.white,
              //                   shadows: <Shadow>[
              //                     Shadow(
              //                       offset: Offset(2.0, 2.0),
              //                       blurRadius: 3.0,
              //                       color: Color.fromARGB(255, 0, 0, 0),
              //                     ),
              //                     Shadow(
              //                       offset: Offset(6.0, 6.0),
              //                       blurRadius: 8.0,
              //                       color: Color.fromARGB(124, 0, 0, 0),
              //                     ),
              //                   ],
              //                 ),
              //                 maxLines: 1,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     Expanded(
              //       child: Stack(
              //         alignment: Alignment.topRight,
              //         children: [
              //           MaterialButton(
              //             shape: const RoundedRectangleBorder(),
              //             elevation: 30,
              //             splashColor: const Color.fromRGBO(149, 22, 224, 1),
              //             onPressed: () {
              //               // Navigator.push(
              //               //   context,
              //               //   MaterialPageRoute(
              //               //     builder: (context) => const storyTest(),
              //               //   ),
              //               // );
              //             },
              //             child: Container(
              //               margin: const EdgeInsets.all(10),
              //               height: currentHeight / 3,
              //               decoration: BoxDecoration(
              //                 image: const DecorationImage(
              //                   image: AssetImage('imgs/white.png'),
              //                   fit: BoxFit.cover,
              //                 ),
              //                 borderRadius: BorderRadius.circular(10),
              //               ),
              //             ),
              //           ),
              //           Container(
              //             margin: const EdgeInsets.only(right: 25, top: 10),
              //             decoration: const BoxDecoration(
              //               borderRadius: BorderRadius.only(
              //                 bottomLeft: Radius.circular(20),
              //                 bottomRight: Radius.circular(5),
              //                 topLeft: Radius.circular(5),
              //                 topRight: Radius.circular(5),
              //               ),
              //               color: Colors.red,
              //             ),
              //             height: currentHeight / 18,
              //             width: currentWidth / 18,
              //             child: const Center(
              //               child: Text(
              //                 'صعب',
              //                 style: TextStyle(
              //                   color: Colors.white,
              //                   shadows: <Shadow>[
              //                     Shadow(
              //                       offset: Offset(2.0, 2.0),
              //                       blurRadius: 3.0,
              //                       color: Color.fromARGB(255, 0, 0, 0),
              //                     ),
              //                     Shadow(
              //                       offset: Offset(6.0, 6.0),
              //                       blurRadius: 8.0,
              //                       color: Color.fromARGB(124, 0, 0, 0),
              //                     ),
              //                   ],
              //                 ),
              //                 maxLines: 1,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
