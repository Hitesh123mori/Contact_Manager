import 'package:contactmanger/effects/transition5.dart';
import 'package:contactmanger/models/binary_search_tree/Operations.dart';
import 'package:contactmanger/theme/colors.dart';
import 'package:flutter/material.dart' ;
import 'package:flutter/services.dart';

import '../models/api/api.dart';
import '../models/binary_search_tree/contact.dart';
import 'auth/sign_in.dart';
import 'homescreens/home_screen.dart';


class LoadScreen extends StatefulWidget {

  final Operations  value;

  const LoadScreen({super.key, required this.value});

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {

  List<Contact> contactList = [];

  @override
  void initState() {
    super.initState();
    loadContacts().then((_){
      Navigator.pushReplacement(context, SizeTransition5(HomePage()));
    } );

  }


  Future<void> loadContacts() async {
    List<Contact> contacts = await Api.getAllContacts();
    setState(() {
      contactList = contacts;
      print("Length of List: ${contactList.length}");
    });

    for (Contact contact in contacts) {
      rebuildBinaryTree(contact);
    }
  }

  Future<void> rebuildBinaryTree(Contact contact) async {
    widget.value.insert(widget.value.binaryTree, contact);
  }
  Widget build(BuildContext context) {
    return HomePage() ;
  }
}
