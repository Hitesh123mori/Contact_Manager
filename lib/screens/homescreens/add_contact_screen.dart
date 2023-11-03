import 'package:contactmanger/custom_widgets/custom_button.dart';
import 'package:contactmanger/custom_widgets/cutsom_btn.fdart.dart';
import 'package:contactmanger/custom_widgets/text_field.dart';
import 'package:contactmanger/effects/transition5.dart';
import 'package:contactmanger/models/binary_search_tree/contact.dart';
import 'package:contactmanger/models/binary_search_tree/Operations.dart';
import 'package:contactmanger/models/binary_search_tree/binary_tree.dart';
import 'package:contactmanger/screens/homescreens/home_screen.dart';
import 'package:contactmanger/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/api/api.dart';
import '../splash_sreen.dart';

class AddContact extends StatefulWidget {
  AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {
  TextEditingController contactNameController = TextEditingController();
  TextEditingController contactEmailController = TextEditingController();
  TextEditingController contactContactController = TextEditingController();
  TextEditingController contactAboutController = TextEditingController();

  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    // Add listeners to text controllers
    contactNameController.addListener(updateButtonState);
    contactEmailController.addListener(updateButtonState);
    contactAboutController.addListener(updateButtonState);
    contactContactController.addListener(updateButtonState);
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled = contactNameController.text.isNotEmpty &&
          contactContactController.text.isNotEmpty &&
          contactAboutController.text.isNotEmpty &&
          contactEmailController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    contactEmailController.removeListener(updateButtonState);
    contactContactController.removeListener(updateButtonState);
    contactNameController.removeListener(updateButtonState);
    contactAboutController.removeListener(updateButtonState);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Consumer<Operations>(
      builder: (context, value, child) {
        return MaterialApp(
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
                  "Add New Contact",
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: AppColors.theme['appbarColor'],
              ),
              body: Form(
                key: _formKey3,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: mq.width * 0.05, vertical: mq.height * 0.1),
                    child: Column(
                      children: [
                        CustomTextField(
                          hinttext: "Enter Contact Name",
                          labeltext: "Contact Name",
                          prefixicon: Icon(Icons.person),
                          controller: contactNameController,
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
                        CustomTextField(
                          hinttext: "Enter Email",
                          labeltext: "Email",
                          prefixicon: Icon(Icons.email),
                          controller: contactEmailController,
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
                        CustomTextField(
                          hinttext: "Enter About",
                          labeltext: "About",
                          prefixicon: Icon(Icons.info_outline_rounded),
                          controller: contactAboutController,
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
                        CustomTextField(
                          hinttext: "Contact Number",
                          labeltext: "Contact Number",
                          prefixicon: Icon(Icons.call),
                          controller: contactContactController,
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
                                onPressed: isButtonEnabled
                                    ? () async {
                                        if (_formKey3.currentState!
                                            .validate()) {
                                          Contact newContact = Contact(
                                              name: contactNameController.text,
                                              email: contactEmailController.text,
                                              number: contactContactController.text,
                                              about: contactAboutController.text);

                                          value.insert(
                                              value.binaryTree, newContact);

                                          await Api.addContact(newContact);
                                          Navigator.pushReplacement(context,
                                              SizeTransition5(HomePage()));
                                        }
                                      }
                                    : () {},
                                text: "Save",
                                textColor: isButtonEnabled
                                    ? Colors.white
                                    : Colors.grey.shade700,
                                buttonColor: isButtonEnabled
                                    ? AppColors.theme['splashScreenColor']
                                    : Colors.grey,
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
    );
  }
}
