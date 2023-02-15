import 'package:flutter/material.dart';

class childStatistics extends StatelessWidget {
  final String? avatar_url_st;
  final String? name_st;
  final String? id_st;
  const childStatistics(
      {Key? key, this.name_st, this.avatar_url_st, this.id_st})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentwidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                maxRadius: currentHeight / 12,
                minRadius: currentwidth / 12,
                child: Image.network(
                  '$avatar_url_st',
                ),
              ),
              Text(
                '$name_st',
                style: TextStyle(
                    fontFamily: 'Lalezar', fontSize: currentHeight / 22),
              ),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 50, right: 50, bottom: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'الحروف',
                          style: TextStyle(
                              fontSize: currentHeight / 28,
                              fontFamily: 'Lalezar',
                              color: Colors.red),
                        ),
                        SizedBox(height: currentHeight / 55),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '23',
                              style: TextStyle(
                                  fontSize: currentwidth / 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' حرف قرئ بشكل صحيح',
                              style: TextStyle(
                                  fontSize: currentwidth / 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '23',
                              style: TextStyle(
                                  fontSize: currentwidth / 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' حرف قرئ بشكل صحيح',
                              style: TextStyle(
                                  fontSize: currentwidth / 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 50, right: 50, bottom: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'الكلمات',
                          style: TextStyle(
                              fontSize: currentHeight / 28,
                              fontFamily: 'Lalezar',
                              color: Colors.red),
                        ),
                        SizedBox(height: currentHeight / 55),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '23',
                              style: TextStyle(
                                  fontSize: currentwidth / 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' حرف قرئ بشكل صحيح',
                              style: TextStyle(
                                  fontSize: currentwidth / 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '23',
                              style: TextStyle(
                                  fontSize: currentwidth / 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' حرف قرئ بشكل صحيح',
                              style: TextStyle(
                                  fontSize: currentwidth / 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    margin:
                        const EdgeInsets.only(left: 50, right: 50, bottom: 20),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'القصص',
                          style: TextStyle(
                              fontSize: currentHeight / 28,
                              fontFamily: 'Lalezar',
                              color: Colors.red),
                        ),
                        SizedBox(height: currentHeight / 55),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '23',
                              style: TextStyle(
                                  fontSize: currentwidth / 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' حرف قرئ بشكل صحيح',
                              style: TextStyle(
                                  fontSize: currentwidth / 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '23',
                              style: TextStyle(
                                  fontSize: currentwidth / 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' حرف قرئ بشكل صحيح',
                              style: TextStyle(
                                  fontSize: currentwidth / 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
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
      ),
    );
  }
}
