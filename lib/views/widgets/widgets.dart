import 'package:flutter/material.dart';

class ProfileAvatars extends StatefulWidget {
  const ProfileAvatars({Key? key}) : super(key: key);

  @override
  State<ProfileAvatars> createState() => _ProfileAvatarsState();
}

class _ProfileAvatarsState extends State<ProfileAvatars> {
  var index = 0;
  String? avatarUrl2;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      index = 0;
                      avatarUrl2 =
                          'https://pbs.twimg.com/media/Ff60Jb9WAAQ-0PD?format=png&name=small';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: index == 0 ? Colors.grey[300] : Colors.white,
                    ),
                    child: const CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://pbs.twimg.com/media/Ff60Jb9WAAQ-0PD?format=png&name=small'),
                      backgroundColor: Color.fromARGB(255, 255, 178, 71),
                      radius: 60,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      index = 1;
                      avatarUrl2 =
                          'https://pbs.twimg.com/media/Ff60L0aXwAkKQXN?format=png&name=small';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: index == 1 ? Colors.grey[300] : Colors.white,
                    ),
                    child: const CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://pbs.twimg.com/media/Ff60L0aXwAkKQXN?format=png&name=small'),
                      backgroundColor: Color.fromARGB(255, 255, 178, 71),
                      radius: 60,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      index = 2;
                      avatarUrl2 =
                          'https://pbs.twimg.com/media/Ff60L0aXwAkKQXN?format=png&name=small';
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: index == 2 ? Colors.grey[300] : Colors.white,
                    ),
                    child: const CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://pbs.twimg.com/media/Ff60L0aXwAkKQXN?format=png&name=small'),
                      backgroundColor: Color.fromARGB(255, 255, 178, 71),
                      radius: 60,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
