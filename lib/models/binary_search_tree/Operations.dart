import 'package:flutter/cupertino.dart';

import 'binary_tree.dart';
import 'contact.dart';

class Operations extends ChangeNotifier {
  BinaryTree binaryTree = BinaryTree(Contact(name: "nullvaluenirajharshmorichaudary", email: "email", number: "0123456789", about: "about"));
  String normalizeName(String name) {
    return name.toLowerCase();
  }

  BinaryTree? insert(BinaryTree? node, Contact contact) {
    contact.name = normalizeName(contact.name!);
    notifyListeners();
    return _addContact(node, contact);
  }

  BinaryTree? _addContact(BinaryTree? node, Contact contact) {


    print("added------------------------------------------------");
    if (node == null) {
      return BinaryTree(contact);
    }

    if (contact.name.compareTo(normalizeName(node.contact!.name)) < 0) {
      node.left = _addContact(node.left, contact);
    } else {
      node.right = _addContact(node.right, contact);
    }

    return node;
  }

  List<Contact> inorderTraversal(BinaryTree? node) {
    List<Contact> result =  [];
    print("printed---------------------------------") ;

    if (node != null) {
      result.addAll(inorderTraversal(node.left));
    result.add(node.contact!);
    result.addAll(inorderTraversal(node.right));

      // inorderTraversal(node.left);
      // result.add(node.contact!);
      // inorderTraversal(node.right);
    }
    print("#CN ${node?.contact?.name}");
    result.sort((a, b) => a.name!.compareTo(b.name!));

    return result;
  }


  void updateContact(BinaryTree? node, Contact oldContact, Contact newContact) {
    delete(node, oldContact);
    insert(node, newContact);
  }


  // List<Contact> search(BinaryTree? node, String name) {
  //   name = normalizeName(name);
  //   List<Contact> foundContacts = [];
  //   _searching(node, name, foundContacts);
  //   return foundContacts;
  // }
  //
  // void _searching(BinaryTree? node, String name, List<Contact> foundContacts) {
  //   if (node == null) {
  //     return;
  //   }
  //
  //   if (name.compareTo(normalizeName(node.contact!.name)) < 0) {
  //     _searching(node.left, name, foundContacts);
  //   } else {
  //     if (name == normalizeName(node.contact!.name)) {
  //       foundContacts.add(node.contact!);
  //     }
  //     _searching(node.right, name, foundContacts);
  //   }
  // }
  //
  BinaryTree? findMinNode(BinaryTree? node) {
    if (node == null) {
      return null;
    }
    if (node.left == null) {
      return node;
    }
    return findMinNode(node.left);
  }

  BinaryTree? delete(BinaryTree? node, Contact contact) {
    if (node == null) {
      return node;
    }

    if (contact.name.compareTo(normalizeName(node.contact!.name)) < 0) {
      node.left = delete(node.left, contact);
    } else if (contact.name.compareTo(normalizeName(node.contact!.name)) > 0) {
      node.right = delete(node.right, contact);
    } else {
      if (node.contact!.name != contact.name) {
        return node;
      } else {
        if (node.left == null) {
          return node.right;
        } else if (node.right == null) {
          return node.left;
        }
        BinaryTree? temp = findMinNode(node.right);
        node.contact = temp!.contact;
        node.right = delete(node.right, temp.contact!);
      }
    }
    return node;
  }
}