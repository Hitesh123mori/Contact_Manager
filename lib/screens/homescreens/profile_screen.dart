import 'dart:convert';
import 'dart:math';

import 'package:contactmanger/effects/transition4.dart';
import 'package:contactmanger/models/binary_search_tree/Operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../custom_widgets/contact_detail_card.dart';
import '../../custom_widgets/custom_button.dart';
import '../../effects/transition5.dart';
import '../../models/api/api.dart';
import '../../models/binary_search_tree/contact.dart';
import '../../theme/colors.dart';
import '../splash_sreen.dart';
import 'contact_update_screen.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? documentId;

  const ProfileScreen({Key? key, required this.documentId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Contact? contact;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    fetchContactData();
  }

  Future<void> fetchContactData() async {
    final fetchedContact = await Api.getContactData('${widget.documentId}');
    setState(() {
      contact = fetchedContact;
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Consumer<Operations>(
        builder: (context,value,child){
          return Form(
            key: _formKey,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                backgroundColor: AppColors.theme['backgroundColor'],
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        SizeTransition5(HomePage()),
                      );
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_left_outlined,
                      size: 34,
                      color: Colors.black,
                    ),
                  ),
                  title: Text("Profile Screen", style: TextStyle(color: Colors.black)),
                  centerTitle: true,
                  backgroundColor: AppColors.theme['appbarColor'],
                  elevation: 2,
                ),
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: mq.width * 0.29, vertical: mq.height * 0.03),
                          child: Material(
                            elevation: 3,
                            color: AppColors.theme['backgroundColor'],
                            child: Container(
                              width: mq.width * 0.4,
                              height: mq.height * 0.2,
                              child:  QrImageView(
                                data: jsonEncode(contact),
                                version: QrVersions.auto,
                                size: 180.0,
                              ),
                            ),
                          ),
                        ),
                        CustomContactDetailCard(text: '${contact?.name}', headingtext: 'Name'),
                        CustomContactDetailCard(text: '${contact?.email}', headingtext: 'Email'),
                        CustomContactDetailCard(text: '${contact?.about}', headingtext: 'About'),
                        CustomContactDetailCard(text: '${contact?.number}', headingtext: 'Contact'),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 18),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Material(
                                elevation: 3,
                                color: AppColors.theme['backgroundColor'],
                                borderRadius: BorderRadius.circular(12),
                                child: Button(
                                  onPressed:(){
                                    Navigator.pushReplacement(context, SizeTransition4(UpdateScreen(contact:contact!, docId: widget.documentId!,)));
                                  },
                                  text: "Edit",
                                  textColor: Colors.black,
                                  buttonColor: AppColors.theme['appbarColor'],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Material(
                                elevation: 3,
                                color: AppColors.theme['backgroundColor'],
                                borderRadius: BorderRadius.circular(12),
                                child: Button(
                                    onPressed:(){
                                      value.delete(value.binaryTree, contact!);
                                      Api.deleteContact('${widget.documentId}') ;
                                      Api.recycleBin(contact!);
                                      Navigator.pushReplacement(context, SizeTransition5(HomePage()));

                                      print("================================> deleted") ;

                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text('Contact Deleted Successfully'),
                                      ));
                                    },
                                    text: "Delete",
                                    textColor: Colors.black,
                                    buttonColor: Colors.red.shade700),
                              )
                            ],
                          ),
                        ),


                      ]
                  ),
                ),
              ),
            ),
          );
        }
    ) ;
  }
}
