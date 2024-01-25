import 'package:contactmanger/models/binary_search_tree/binary_tree.dart';
import 'package:contactmanger/models/binary_search_tree/Operations.dart';
import 'package:contactmanger/screens/homescreens/content_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../custom_widgets/contact_card.dart';
import '../../../theme/colors.dart';
import '../../splash_sreen.dart';

class AllContacts extends StatefulWidget {

  final List result ;

  AllContacts({Key? key, required this.result})
      : super(key: key);

  @override
  State<AllContacts> createState() => _AllContactsState();
}

class _AllContactsState extends State<AllContacts> {
  @override






  Widget build(BuildContext context) {
    mq  = MediaQuery.of(context).size;
    print("#allC");
    return Consumer<Operations>(builder: (context, value, child) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: isSeaching ? Container(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding:  EdgeInsets.only(top: 18.0,bottom: 12,right:mq.width*0.45),
                  child: Text("Search Results",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                ),
                Column(
                  children: [
                    if(widget.result.isNotEmpty)
                      for (final contact in widget.result)
                        (contact.name == 'nullvaluenirajharshmorichaudary')
                            ? Container()
                            :CustomContactCard(
                            contact: contact,


                        )
                    else
                      Container(
                        child: Padding(
                          padding:  EdgeInsets.symmetric(horizontal: mq.width*0.2,vertical: mq.height*0.35),
                          child: Text("Search not found",style: TextStyle(color : Colors.grey,fontSize: 25),),
                        ),
                      ),
                  ],
                )


              ],
            ),
          ),




        ): Column(
          children: [
            Padding(
              padding:  EdgeInsets.only(top: 18.0,bottom: 12,right:mq.width*0.6),
              child: Text("All Contacts",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
            ),
            for (final contact
                in value.inorderTraversal(value.binaryTree))
              (contact.name == 'nullvaluenirajharshmorichaudary')
                  ? Container()
                  :CustomContactCard(
                   contact: contact,

              )

              // Card(
              //   child: ListTile(
              //     title: Text(contact.name),
              //     subtitle: Text(
              //       'Email: ${contact.email}, Phone: ${contact.number}, About: ${contact.about}',
              //     ),
              //   ),
              // ),
          ],
        ),
      );
    }
    );
  }
}
