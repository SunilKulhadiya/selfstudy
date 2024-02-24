import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Center(
            child: Text('Home',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),),
          ),
        ),
      ],
    );
  }
}