import 'package:flutter/material.dart';

class LoadingAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 128,
        width: 128,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: Image.asset(
            "images/logo.png",
            width: MediaQuery.of(context).size.width * .33,
            height: MediaQuery.of(context).size.width * .33,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
