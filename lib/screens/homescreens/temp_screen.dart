import 'package:contactmanger/models/binary_search_tree/Operations.dart';
import 'package:contactmanger/screens/splash_sreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TempScreen extends StatefulWidget {
  const TempScreen({super.key});

  @override
  State<TempScreen> createState() => _TempScreenState();
}

class _TempScreenState extends State<TempScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Operations>(
        builder: (context,value,child){
          return SplashScreen(value: value,) ;

        }
    ) ;
  }
}
