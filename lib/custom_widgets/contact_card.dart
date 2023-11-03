import 'package:contactmanger/custom_widgets/dialogs.dart';
import 'package:contactmanger/effects/transition4.dart';
import 'package:contactmanger/models/binary_search_tree/Operations.dart';
import 'package:contactmanger/screens/homescreens/content_screens/recycleBIn.dart';
import 'package:contactmanger/theme/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../effects/transition5.dart';
import '../models/api/api.dart';
import '../models/binary_search_tree/contact.dart';
import '../screens/homescreens/content_screens/starred_contacts.dart';
import '../screens/homescreens/home_screen.dart';
import '../screens/homescreens/profile_screen.dart';

class CustomContactCard extends StatefulWidget {
  final Contact contact ;


  const CustomContactCard({
    Key? key,
   required this.contact,
  }) : super(key: key);

  @override
  State<CustomContactCard> createState() => _CustomContactCardState();
}

class _CustomContactCardState extends State<CustomContactCard> {
  String? contactId;




  @override
  void initState() {
    super.initState();
    fetchContactId();
  }


  void fetchContactId() async {
    contactId = await Api.findContactDocumentIdByAttribute(widget.contact.email);
    print("contact ID==============> $contactId");
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<Operations>(builder: (context,value,child) {
      return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.horizontal,
        onDismissed: (direction)async{

          if(direction==DismissDirection.startToEnd){

            value.delete(value.binaryTree, widget.contact);
            await Api.deleteContact("${contactId}").then((value) async {
              await Api.recycleBin(widget.contact);
               Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
              Dialogs.showSnackbar(context, "Contact Deleted");
              if (mounted) {

                setState(() {

                });
              }





            }) ;



          }
          else{
            value.delete(value.binaryTree, widget.contact);
            await Api.starredContacts(widget.contact).then((value) async {

              await Api.deleteContact("${contactId}");

              if (mounted) {

                setState(() {

                });
              }

              Dialogs.showSnackbar(context, "Contact Starred");




            }) ;


          }

        },
        background: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10, right: 300),
            child: Icon(Icons.delete),
          ),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        secondaryBackground: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 300),
            child: Icon(Icons.star_border),
          ),
          decoration: BoxDecoration(
            color: AppColors.theme['appbarColor'],
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            fetchContactId();
            if (contactId != null) {
              Navigator.push(
                context,
                SizeTransition4(ProfileScreen(documentId: contactId)),
              );
            } else {
              print("Contact ID is null. Check the email or document retrieval.");
            }
          },
          child: Padding(
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
        ),
      );
    });
  }
}
