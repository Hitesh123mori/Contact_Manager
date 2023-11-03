
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../binary_search_tree/contact.dart';

class Api {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User get user => auth.currentUser!;



  // saving contacts

  static Future<void> addContact(Contact contact) async {
    await firestore.collection("users/${user.uid}/contacts").doc().set(contact.toJson());
  }

  // recyclebin
  static Future<void> recycleBin(Contact contact) async {
    await firestore.collection("users/${user.uid}/recyclebin").doc().set(contact.toJson());
  }


  //get all contancts

  static Future<List<Contact>> getAllContacts() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
        .collection('users/${user.uid}/contacts')
        .get();

    List<Contact> contactList = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      return Contact(
        name: data['name'], // Adjust the field names based on your Firestore structure
        email: data['email'],
        number: data['contact'],
        about: data['about'],
      );
    }).toList();

    return contactList;
  }




  // get data - recyclebin
  static Stream<QuerySnapshot<Map<String, dynamic>>> getRecycleBinData() {

    return firestore
        .collection('users/${user.uid}/recyclebin')
        .snapshots();
  }
  
  // signup method-------------------------------------------------------------------------------------------------------------------------------------
  Future<void> signUp(BuildContext context, String email, String password, String name, String contact, String about) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        },
      );
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'name': name,
        'contact': contact,
        'about': about,
        'email': email,
      });
      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? 'An error occurred during registration.'),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again later.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  //signin-----------------------------------------------------------------------------------------

  Future<void> signIn(BuildContext context, String email, String password) async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        },
      );

      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pop(context); // Close the loading indicator on success
    } on FirebaseAuthException catch (e) {
      // Close the loading indicator on error
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message ?? 'An error occurred during sign in.'),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      // Close the loading indicator on other errors
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again later.'),
        backgroundColor: Colors.red,
      ));
    }
  }


  // check user existance-----------------------------------------------------

  Future<bool> userExists(String userId) async {
    try {
      final DocumentSnapshot userDoc = await firestore.collection('users').doc(userId).get();
      return userDoc.exists;
    } catch (e) {
      return false;
    }
  }

  // fetch self data-------------------------------------------------------------------------------------

  Future<Map<String, dynamic>> fetchUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return <String, dynamic>{};
  }



//   fetch id of contact  of perticular user

  static Future<String?> findContactDocumentIdByAttribute(String userEmail) async {
    final QuerySnapshot querySnapshot = await firestore.collection("users/${user.uid}/contacts")
        .where("email", isEqualTo: userEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null;
    }
  }

  // id for recycle bin


  static Future<String?> findBinContactDocumentIdByAttribute(String userEmail) async {
    final QuerySnapshot querySnapshot = await firestore.collection("users/${user.uid}/recyclebin")
        .where("email", isEqualTo: userEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null;
    }
  }



  //   fetch data of user

  static Future<Contact?> getContactData(String documentId) async {
    DocumentSnapshot doc = await firestore.collection("users/${user.uid}/contacts").doc(documentId).get();

    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Contact.fromJson(data);
    } else {
      return null;
    }
  }


//   deletion



  static Future<void> deleteContact(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users/${user.uid}/contacts")
          .doc(documentId)
          .delete();
      print("===================> Contact deleted successfully");
    } catch (e) {
      print("Error deleting contact: $e");
    }
  }

  // delete from recyclebin

  static Future<void> deleteRecycleContact(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users/${user.uid}/recyclebin")
          .doc(documentId)
          .delete();
      print("===================> Contact deleted successfully");
    } catch (e) {
      print("Error deleting contact: $e");
    }
  }

//   starred Contacts;

  static Future<void> starredContacts(Contact contact) async {
    await firestore.collection("users/${user.uid}/staredContacts").doc().set(contact.toJson());
  }

//   unstar / delete from starred Contacts

  static Future<void> deleteStarredContacts(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection("users/${user.uid}/staredContacts")
          .doc(documentId)
          .delete();
      print("===================> Contact unstar successfully");
    } catch (e) {
      print("Error unstar contact: $e");
    }
  }


//   get data from starredContacts

  static Stream<QuerySnapshot<Map<String, dynamic>>> getStarredContactsData() {

    return firestore
        .collection('users/${user.uid}/staredContacts')
        .snapshots();
  }

  // id for star contacts ;
  static Future<String?> findStarContactDocumentIdByAttribute(String userEmail) async {
    final QuerySnapshot querySnapshot = await firestore.collection("users/${user.uid}/staredContacts")
        .where("email", isEqualTo: userEmail)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id;
    } else {
      return null;
    }
  }

//updation of contact
//
//   static Future<void> updateContact(Contact contact, String documentId) async {
//
//
//     print("update method called=====================================>") ;
//     try {
//       await firestore.collection("users/${user.uid}/contacts").doc(documentId).update({
//         'name': contact.name,
//         'about': contact.about,
//         'email': contact.email,
//         'contact': contact.number,
//       });
//       print("updated contact==================> ${contact.name}") ;
//       print("Contact updated successfully.");
//     } catch (e) {
//       print("Error updating contact: $e");
//     }
//   }




}



