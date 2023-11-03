import 'package:contactmanger/models/binary_search_tree/Operations.dart';
import 'package:contactmanger/screens/homescreens/temp_screen.dart';
import 'package:contactmanger/screens/splash_sreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart' ;
import 'package:provider/provider.dart';
import 'firebase_options.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _intializeFirebase();
  runApp(MultiProvider(providers: [ChangeNotifierProvider(create: (context)=>Operations())], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TempScreen(),
    );
  }
}



_intializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
