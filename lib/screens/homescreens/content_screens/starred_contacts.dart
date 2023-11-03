import 'package:flutter/material.dart' ;

import '../../../custom_widgets/stared_contacts_contact_field.dart';
import '../../../models/api/api.dart';
import '../../../models/binary_search_tree/contact.dart';
import '../../splash_sreen.dart';

class StarredContacts extends StatefulWidget {
  const StarredContacts({super.key});

  @override
  State<StarredContacts> createState() => _StarredContactsState();
}

class _StarredContactsState extends State<StarredContacts> {

  List<Contact> list = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: 18.0, bottom: 12, right: mq.width * 0.45),
          child: Text(
            "Star Contacts",
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          child: StreamBuilder(
              stream: Api.getStarredContactsData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    list =
                        data?.map((e) => Contact.fromJson(e.data())).toList() ??
                            [];
                    print("#star length :  ${list.length}");
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.0),
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: list.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return CustomStarContainer(
                              contact: list[index],
                            );
                          }),
                    );
                }
              }),
        ),
      ],
    );
  }
}
