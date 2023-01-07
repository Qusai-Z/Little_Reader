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
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                maxRadius: 120,
                minRadius: 120,
                child: Image.network(
                  '$avatar_url_st',
                ),
              ),
              Text(
                '$name_st',
                style: const TextStyle(fontFamily: 'Lalezar', fontSize: 30),
              ),
              Expanded(
                child: Container(
                  margin:
                      const EdgeInsets.only(left: 50, right: 50, bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.orange,
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
