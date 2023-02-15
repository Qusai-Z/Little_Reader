import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class TEEEST extends StatelessWidget {
  TEEEST({super.key});

  int number = 4;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('$number'),
    );
  }
}
