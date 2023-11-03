import 'package:contactmanger/effects/transition4.dart';
import 'package:contactmanger/models/binary_search_tree/Operations.dart';
import 'package:contactmanger/screens/auth/sign_up.dart';
import 'package:contactmanger/screens/homescreens/home_screen.dart';
import 'package:contactmanger/screens/load_data_screen.dart';
import 'package:contactmanger/theme/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:contactmanger/custom_widgets/dialogs.dart';

import '../../custom_widgets/cutsom_btn.fdart.dart';
import '../../custom_widgets/text_field.dart';
import '../../models/api/api.dart';
import '../splash_sreen.dart';

class LoginScreen extends StatefulWidget {

  final Operations value ;

  const LoginScreen({super.key, required this.value});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool isButtonEnabled2 = false;

  @override
  void initState() {
    super.initState();

    // Add listeners to text controllers
    emailController.addListener(updateButtonState);
    passController.addListener(updateButtonState);
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled2 = emailController.text.isNotEmpty && passController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    emailController.removeListener(updateButtonState);
    passController.removeListener(updateButtonState);
    super.dispose();
  }
  Future<void> login() async {
    if (_formKey2.currentState!.validate()) {
      final api = Api();

      try {
        // Attempt to sign in
        await api.signIn(
          context,
          emailController.text,
          passController.text,
        );


        User? user = Api.auth.currentUser;
        if (user != null) {
          bool userExists = await api.userExists(user.uid);

          if (userExists) {
            Dialogs.showSnackbar(context, 'Login Successfully');
            Navigator.pushReplacement(context, SizeTransition4(LoadScreen(value: widget.value,)));
          } else {
            Dialogs.showSnackbar(context, 'User data does not exist');
          }
        } else {
          Dialogs.showSnackbar(context, 'User is not authenticated');
        }
      } on FirebaseAuthException catch (e) {
        Dialogs.showSnackbar(context, 'Login failed');
      } catch (error) {
        // Handle other errors (e.g., no internet connection)
        Dialogs.showSnackbar(context, 'Something went wrong. Please check your connection.');
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return  Scaffold(
        backgroundColor: Colors.grey[200],
        body: GestureDetector(
          // Wrap the entire Scaffold with GestureDetector to handle taps
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: _formKey2,
            child: SafeArea(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: mq.height * 0.13, right: mq.width * 0.13),
                        child: Text(
                          "Welcome back! Glad\nto see you, Again!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 27,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: mq.height * 0.04,
                      ),
                      CustomTextField(
                        hinttext: 'Enter Email',
                        labeltext: 'Email',
                        prefixicon: Icon(Icons.mail),
                        controller: emailController,
                        isNumber: false,
                        isSecure: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: mq.height * 0.02,
                      ),
                      CustomTextField(
                        hinttext: 'Enter Password',
                        labeltext: 'Password',
                        prefixicon: Icon(Icons.password),
                        controller: passController,
                        isNumber: false,
                        isSecure: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: mq.height * 0.02,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: mq.width * 0.5),
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            "Forget Password",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: mq.height * 0.02,
                      ),
                      customButton(
                        onPressed: isButtonEnabled2 ? login : () {},
                        text: 'Login',
                        textColor: isButtonEnabled2
                            ? Colors.white
                            : Colors.grey.shade700,
                        buttonColor: isButtonEnabled2
                            ? AppColors.theme['splashScreenColor']
                            : Colors.grey,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: mq.width * 0.15),
                            child: Text(
                              "Don't have an account ?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: mq.width * 0.01),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  SizeTransition4(RegisterScreen(value: widget.value,)),
                                );
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
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
        ),
      );
  }
}
