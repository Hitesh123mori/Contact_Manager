import 'package:flutter/material.dart';

class Button extends StatelessWidget {

  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final Color buttonColor;

  const Button({super.key, required this.onPressed, required this.text, required this.textColor, required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0.1,
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Adjust the radius as needed
          ),
          minimumSize: Size(double.infinity, 50), // Set the desired height
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: textColor, fontFamily: "LatoBold",fontSize: 18),
        ),
      ),
    );
  }
}
