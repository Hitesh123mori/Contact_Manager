import 'package:contactmanger/effects/transition5.dart';
import 'package:contactmanger/models/binary_search_tree/Operations.dart';
import 'package:contactmanger/screens/homescreens/content_screens/recycleBIn.dart';
import 'package:contactmanger/screens/homescreens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/api/api.dart';
import '../models/binary_search_tree/contact.dart';
import '../screens/splash_sreen.dart';
import '../theme/colors.dart';


class RecycleBinWidget extends StatefulWidget {

  final Contact contact ;


  const RecycleBinWidget({super.key, required this.contact,});

  @override
  State<RecycleBinWidget> createState() => _RecycleBinWidgetState();
}

class _RecycleBinWidgetState extends State<RecycleBinWidget> {

  String? contactId;




  void initState() {
    super.initState();
    fetchContactId();
  }


  void fetchContactId() async {
    contactId = await Api.findBinContactDocumentIdByAttribute(widget.contact.email);
    print("Delete Contact ID==============> $contactId");
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size ;

    return Consumer<Operations>(
        builder: (context,value,child){
          return Dismissible(
            direction: DismissDirection.horizontal,
              onDismissed: (direction)async{

                if(direction==DismissDirection.startToEnd){


                  value.insert(
                      value.binaryTree, widget.contact);

                  await  Api.addContact(widget.contact).then((value)async {

                    await Api.deleteRecycleContact("${contactId}");
                    if (mounted) {

                      setState(() {

                      });
                    }


                  }) ;

                }
                else{
                  await Api.deleteRecycleContact("${contactId}").then((value) {

                    if (mounted) {

                      setState(() {

                      });
                    }
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));


                  }) ;

                }
              },
            background: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10, right: 300),
                child: Icon(Icons.restore),
              ),
              decoration: BoxDecoration(
                color:AppColors.theme['appbarColor'],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            secondaryBackground: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 300),
                child: Icon(Icons.delete),
              ),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
              key: UniqueKey(),
              child:  Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.theme['backgroundColor'],
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0,),
                      child: CircleAvatar(
                        backgroundColor: AppColors.theme['appbarColor'],
                        radius: 25,
                        child: Center(
                          child: Text(
                            widget.contact.name[0].toUpperCase(),
                            style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 28.0, top: 25, bottom: 25),
                          child: Text(
                            widget.contact.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),


              ) ;
        }
    ) ;
  }
}
