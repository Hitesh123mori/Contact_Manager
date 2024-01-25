import 'dart:convert';

import 'package:contactmanger/effects/transition4.dart';
import 'package:contactmanger/models/binary_search_tree/contact.dart';
import 'package:contactmanger/screens/homescreens/drawer_screen.dart';
import 'package:contactmanger/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../models/api/api.dart';
import '../../models/binary_search_tree/Operations.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import '../splash_sreen.dart';
import 'add_contact_screen.dart';
import 'content_screens/all_contacts.dart';
import 'content_screens/recycleBIn.dart';
import 'content_screens/starred_contacts.dart';



bool isSeaching = false;



class ContentScreen extends StatefulWidget {

 final Operations value ;


  const ContentScreen({super.key, required this.value,});

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  bool isDrawerOpen = false;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  List<Contact> resultContact = [] ;




  Future<void> QrCodeScanner(final value)async{
    var cameraStatus = await Permission.camera.status ;
    if(cameraStatus.isGranted){
      String? qrData = await scanner.scan() ;
      print("#Data: ${qrData}") ;

      Contact newContact  = Contact.fromJson(jsonDecode(qrData!)) ;

      print("#NM: ${newContact.name}  ${newContact.number}");

      value.insert(
          value.binaryTree, newContact);

      await Api.addContact(newContact);


    }else{
      var isgrant  = await Permission.camera.request();
      if(isgrant.isGranted)
      QrCodeScanner(value);
    }

  }

  void closeDrawer() {
    setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFactor = 1;
      isDrawerOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Consumer<Operations>(
      builder: (context, value, child){
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor)
              ..rotateY(isDrawerOpen ? -0.5 : 0),
            duration: Duration(milliseconds: 250),
            curve: Curves.linearToEaseOut,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isDrawerOpen ? 20 : 0.0),
            ),
            child: Center(
              child: Scaffold(
                backgroundColor: AppColors.theme['backgroundColor'],
                appBar: AppBar(
                  actions: [
                    IconButton(
                      onPressed: () {
                        QrCodeScanner(value);
                      },
                      icon: Icon(
                        Icons.document_scanner_outlined,
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                   SizedBox(width: 8,),
                   recyclebin ? Container() : Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: isSeaching ? IconButton(
                        onPressed: () {
                          setState(() {
                            isSeaching = !isSeaching ;
                          });
                        },
                        icon: Icon(Icons.cancel_outlined, color: Colors.black),

                      ):IconButton(
                        onPressed: () {

                          setState(() {
                            isSeaching = !isSeaching ;
                          });

                        },
                        icon: Icon(Icons.search, color: Colors.black),
                      ),
                    )
                  ],
                  title: !isSeaching ? Text("Contact Manager",style: TextStyle(color: Colors.black),):  Center(
                    child: Container(
                      // width: 300,
                      height: 40,
                      child: TextField(
                        onChanged: (val){
                          resultContact.clear();
                          for (var i in value.inorderTraversal(value.binaryTree)){
                            if(i.name.toLowerCase().contains(val.toLowerCase())||i.email.toLowerCase().contains(val.toLowerCase())){
                              resultContact.add(i) ;
                            }
                            setState(() {
                              ;
                            });
                          }


                        },
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.black), // Unfocused border color
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.black), // Focused border color
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Colors.red), // Error border color
                          ),
                          hintText: "Search Contact Here",
                          prefixIcon: Icon(Icons.search),
                          prefixIconColor: Colors.black,
                          hintStyle: TextStyle(color :Colors.black),
                          alignLabelWithHint: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20),// Set text alignment to center
                        ),
                        autocorrect: true,
                        autofocus: true,
                      ),
                    ),
                  ),
                  centerTitle: true,
                  backgroundColor: AppColors.theme['appbarColor'],
                  elevation: 2,
                  leading: isDrawerOpen
                      ? IconButton(
                    icon: Center(child: Icon(Icons.keyboard_arrow_left, color: Colors.black, size: 45)),
                    onPressed: () {
                      setState(() {
                        closeDrawer();
                      });
                    },
                  )
                      : IconButton(
                      icon: Icon(Icons.menu, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          xOffset = 230;
                          yOffset = 150;
                          scaleFactor = 0.62;
                          isDrawerOpen = true;
                        });
                      }),
                ),
                floatingActionButton:FloatingActionButton(
                  onPressed: (){
                    Navigator.pushReplacement(context, SizeTransition4(AddContact()));
                  },
                  child: Icon(Icons.add,size: 25,color: Colors.black,),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (recyclebin == true)
                        Column(
                          children: [
                            RecycleBin()
                          ],
                        )
                      else if (starrednotes == true)
                        Column(
                          children: [
                            StarredContacts()
                          ],
                        )
                      else
                        Column(
                          children: [
                            value.inorderTraversal(value.binaryTree).length == 1
                                ? Center(child: Padding(
                                  padding:  EdgeInsets.symmetric(vertical: mq.height*0.4),
                                  child: Text("No Saved Contact",style: TextStyle(color : Colors.grey,fontSize: 34),),
                                ))
                                :AllContacts(result: resultContact!,), // Pass the contact tree
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
