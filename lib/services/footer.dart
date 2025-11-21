import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final Color textColor;

  const Footer({Key? key,
    this.textColor = Colors.black54
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          'Copyright 2025 XmkTech Inc. All rights Reserved',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: textColor, // Use the textColor parameter
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}