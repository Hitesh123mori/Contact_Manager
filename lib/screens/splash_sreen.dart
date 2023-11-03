import 'package:contactmanger/screens/auth/sign_in.dart';
import 'package:contactmanger/screens/homescreens/home_screen.dart';
import 'package:contactmanger/screens/load_data_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../effects/transition4.dart';
import '../models/api/api.dart';
import '../models/binary_search_tree/Operations.dart';
import '../theme/colors.dart';

late Size mq;

class SplashScreen extends StatefulWidget {
  final Operations value ;

  const SplashScreen({super.key, required this.value});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2500), () {
      // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ));

      if (Api.auth.currentUser != null) {
        // The user is logged in, navigate to the home page.
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoadScreen(value: widget.value)));
      } else {
        // The user is not logged in, navigate to the login screen.
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen(value:widget.value,)));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: AppColors.theme['splashScreenColor'],
          body: Center(
            child: Image.asset("assets/images/contact.png",width: 200,height: 200,),
          )
      ),
    );
  }
}
