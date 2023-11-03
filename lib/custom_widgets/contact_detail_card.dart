import 'package:flutter/material.dart' ;

import '../screens/splash_sreen.dart';
import '../theme/colors.dart';

class CustomContactDetailCard extends StatelessWidget {
  final String text ;
  final String headingtext ;

  const CustomContactDetailCard({super.key, required this.text, required this.headingtext});

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size ;
    return Padding(
      padding: EdgeInsets.only(top: 12.0),
      child: Material(
        elevation:3,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: mq.width*0.8,
          decoration: BoxDecoration(
            color: AppColors.theme['backgroundColor'],
            borderRadius: BorderRadius.circular(23),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 28.0,top:25,bottom: 25),
            child: Text("${headingtext} : ${text}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
          ),
        ),
      ),
    );
  }
}
