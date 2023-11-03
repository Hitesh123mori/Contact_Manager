import 'package:flutter/material.dart' ;

import '../theme/colors.dart';

class CustomCard extends StatelessWidget {

  final String title ;
  final Icon icon ;
  final VoidCallback Onpressed;

  const CustomCard({super.key, required this.title, required this.icon, required this.Onpressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: Onpressed,
      child: Card(
        elevation: 0,
        color: AppColors.theme['drawerColor'],
        child: ListTile(
          leading: icon,
          title: Text(title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),),
        ),
      ),
    ) ;
  }
}
