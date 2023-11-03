import 'package:flutter/material.dart';

hexStringToColors(String hexColor){
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }

  return Color(int.parse(hexColor, radix: 16));
}


class AppColors {
  static Map theme = themes["theme1"];

  static Map themes = {
    "theme1": {
      "appbarColor": hexStringToColors("#aab7d5"),
      "backgroundColor" : hexStringToColors("#f8f4ff"),
      "drawerColor" :hexStringToColors("#aab7c5"),
      "ringColor" :hexStringToColors("#aab7c5"),
      "splashScreenColor":hexStringToColors("101D25"),
    },

  };


}