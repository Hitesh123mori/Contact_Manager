import 'package:contactmanger/models/binary_search_tree/contact.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_button.dart';
import '../../custom_widgets/custom_edit_contact_field.dart';
import '../../custom_widgets/text_field.dart';
import '../../effects/transition5.dart';
import '../../models/api/api.dart';
import '../../models/binary_search_tree/Operations.dart';
import '../../theme/colors.dart';
import '../splash_sreen.dart';
import 'home_screen.dart';



class UpdateScreen extends StatefulWidget {
  final Contact contact ;
  final String docId ;


  const UpdateScreen({super.key, required this.contact, required this.docId});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Contact ? oldContact;
  Contact ? newContact;
  String? contactId;



  @override
  void initState() {
    super.initState();
    oldContact = widget.contact;
    newContact = Contact(
      name: oldContact!.name,
      email: oldContact!.email,
      number: oldContact!.number,
      about: oldContact!.about,
    );
    fetchContactId() ;
  }

  void fetchContactId() async {
    contactId = await Api.findContactDocumentIdByAttribute(oldContact!.email);
    print("ID sdf==============> $contactId");
  }


  Widget build(BuildContext context) {
    oldContact = widget.contact ;

    mq = MediaQuery.of(context).size;
    return  Consumer<Operations>(
      builder: (context, value, child) {
        return Form(
          key: _formKey,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context, SizeTransition5(HomePage()));
                    },
                    icon: Icon(
                      Icons.keyboard_arrow_left_outlined,
                      size: 34,
                      color: Colors.black,
                    ),
                  ),
                  centerTitle: true,
                  title: Text(
                    "Update Details",
                    style: TextStyle(color: Colors.black),
                  ),
                  backgroundColor: AppColors.theme['appbarColor'],
                ),
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: mq.width * 0.05, vertical: mq.height * 0.1),
                    child: Column(
                      children: [
                        CutomEditField(
                          intialText: oldContact?.name,
                          onSaved: (val) {
                              newContact?.name = val ?? '' ;
                          },
                          hinttext: "Enter Contact Name",
                          labeltext: "Contact Name",
                          prefixicon: Icon(Icons.person),
                          isNumber: false,
                          isSecure: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        CutomEditField(
                          intialText: oldContact?.email,
                          onSaved: (val){
                            print("triggle");
                            print("Value=========================>${val}");
                            newContact?.email = val ?? '' ;
                            },
                          hinttext: "Enter Email",
                          labeltext: "Email",
                          prefixicon: Icon(Icons.email),
                          isNumber: false,
                          isSecure: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        CutomEditField(
                          intialText: oldContact?.about,
                          onSaved: (val)=> newContact?.about = val ?? '',
                          hinttext: "Enter About",
                          labeltext: "About",
                          prefixicon: Icon(Icons.info_outline_rounded),
                          isNumber: false,
                          isSecure: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter about';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: mq.height * 0.02,
                        ),
                        CutomEditField(
                          intialText: oldContact?.number,
                          onSaved: (val)=> newContact?.number = val ?? '',
                          hinttext: "Contact Number",
                          labeltext: "Contact Number",
                          prefixicon: Icon(Icons.call),
                          isNumber: true,
                          isSecure: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter contact number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: mq.height * 0.04,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Button(
                                onPressed:(){
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState?.save();
                                    print('trigger onsaved functions');
                                  }
                                  // Api.updateContact(oldContact!,"${widget.contact}");
                                  Api.deleteContact("${contactId}") ;
                                  Api.addContact(newContact!);
                                  print("oldcontact======>${oldContact?.name}") ;
                                  print("newcontact======>${newContact?.name}") ;
                                  value.updateContact(value.binaryTree,oldContact!,newContact!);
                                  Navigator.pushReplacement(context, SizeTransition5(HomePage())) ;
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text('Contact Updated'),
                                  ));

                                },
                                text: "Update",
                                textColor: Colors.black,
                                buttonColor: AppColors.theme['appbarColor'],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Button(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context, SizeTransition5(HomePage()));
                                  },
                                  text: "Discard",
                                  textColor: Colors.black,
                                  buttonColor: Colors.red.shade700)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );;
  }
}
