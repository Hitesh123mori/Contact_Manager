import 'package:contactmanger/models/api/api.dart';
import 'package:contactmanger/models/binary_search_tree/Operations.dart';
import 'package:flutter/material.dart' ;
import 'package:provider/provider.dart';
import '../../models/binary_search_tree/contact.dart';
import 'content_screen.dart';
import 'drawer_screen.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key,});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Future<void> getContacts(final value) async {
  //   final coll = await Api.firestore.collection("users/${Api.user.uid}/contacts").snapshots();
  //
  //   // finals contacts = coll.
  // }
  //



  @override
  Widget build(BuildContext context) {
    return Consumer<Operations>(
        builder: (context, value, child){
          return Scaffold(
            body: Stack(
              children: [
                DrawerScreen() ,
                ContentScreen(value: value,),
              ],
            ),
          );

        }
    ) ;
  }
}
