import 'package:contactmanger/custom_widgets/custom_card.dart';
import 'package:contactmanger/effects/transition4.dart';
import 'package:contactmanger/models/binary_search_tree/contact.dart';
import 'package:contactmanger/models/binary_search_tree/Operations.dart';
import 'package:contactmanger/models/binary_search_tree/binary_tree.dart';
import 'package:contactmanger/screens/auth/sign_in.dart';
import 'package:contactmanger/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../effects/transition5.dart';
import '../../models/api/api.dart';
import '../splash_sreen.dart';
import 'home_screen.dart';
import 'dart:convert';

bool allcontacts = false ;
bool starrednotes  = false ;
bool recyclebin = false;


class DrawerScreen extends StatefulWidget {

  const DrawerScreen({super.key,});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();

    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final userUID = Api.auth.currentUser?.uid;
    final data = await Api().fetchUserData(userUID!);
    setState(() {
      userData = data;
    });
  }



  @override
  Widget build(BuildContext context) {

    mq = MediaQuery.of(context).size;

    return Consumer<Operations>(builder: (context, valueOp, child){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
          color: AppColors.theme['drawerColor'],
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: mq.height * 0.14, left: mq.width * 0.07),
                  child: Container(
                    width: mq.width * 0.4,
                    height: mq.height * 0.2,
                    color: AppColors.theme['backgroundColor'],
                    child: QrImageView(
                      data: jsonEncode(userData),
                      version: QrVersions.auto,
                      size: 180.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Column(
                    children: [
                      CustomCard(
                        title: "All Contact",
                        icon: Icon(Icons.contacts,color: Colors.black,),
                        Onpressed: () {
                          allcontacts = true ;
                          starrednotes = false ;
                          recyclebin = false ;
                          Navigator.pushReplacement(context, SizeTransition5(HomePage())) ;
                        },
                      ),
                      CustomCard(
                          title: "Stared Contacts",
                          icon: Icon(Icons.star_border_purple500_sharp,color: Colors.black,),
                          Onpressed: () {
                            allcontacts = false ;
                            starrednotes = true ;
                            recyclebin = false ;
                            Navigator.pushReplacement(context, SizeTransition5(HomePage())) ;
                          }),
                      CustomCard(
                          title: "Recycle Bin",
                          icon: Icon(Icons.recycling,color: Colors.black,),
                          Onpressed: () {
                            allcontacts = false ;
                            starrednotes = false ;
                            recyclebin = true ;
                            Navigator.pushReplacement(context, SizeTransition5(HomePage())) ;
                          }),
                      CustomCard(
                        title: "LOGOUT",
                        icon: Icon(Icons.logout, color: Colors.black),
                        Onpressed: () { FirebaseAuth.instance.signOut().then((value) {

                          valueOp.binaryTree = new BinaryTree(Contact(name: 'nullvaluenirajharshmorichaudary', email: "", about: "", number: ""));
                          Navigator.pushReplacement(context, SizeTransition5(LoginScreen(value:valueOp,)));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logout successful')),
                          );
                        }); },
                      )

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
