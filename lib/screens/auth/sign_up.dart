import 'package:contactmanger/effects/transition5.dart';
import 'package:contactmanger/models/binary_search_tree/Operations.dart';
import 'package:contactmanger/screens/auth/sign_in.dart';
import 'package:contactmanger/screens/homescreens/home_screen.dart';
import 'package:contactmanger/screens/load_data_screen.dart';
import 'package:flutter/material.dart' ;
import '../../custom_widgets/cutsom_btn.fdart.dart';
import '../../custom_widgets/text_field.dart';
import '../../effects/transition4.dart';
import '../../models/api/api.dart';
import '../../theme/colors.dart';
import '../splash_sreen.dart';
import 'package:contactmanger/custom_widgets/dialogs.dart';



class RegisterScreen extends StatefulWidget {
  final Operations value ;

  const RegisterScreen({super.key, required this.value});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  TextEditingController email2Controller  = TextEditingController() ;
  TextEditingController pass2Controller  = TextEditingController() ;
  TextEditingController confirmController  = TextEditingController() ;
  TextEditingController nameController  = TextEditingController() ;
  TextEditingController contactController  = TextEditingController() ;
  TextEditingController aboutController  = TextEditingController() ;



  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isButtonEnabled = false;
  bool isRegistering = false;

  @override
  void initState() {
    super.initState();

    // Add listeners to text controllers
    nameController.addListener(updateButtonState);
    pass2Controller.addListener(updateButtonState);
    contactController.addListener(updateButtonState);
    aboutController.addListener(updateButtonState);
    email2Controller.addListener(updateButtonState);
    confirmController.addListener(updateButtonState);
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled =  email2Controller.text.isNotEmpty && nameController.text.isNotEmpty && pass2Controller.text.isNotEmpty &&  contactController.text.isNotEmpty && aboutController.text.isNotEmpty && confirmController.text.isNotEmpty ;
    });
  }


  @override
  void dispose() {
    nameController.removeListener(updateButtonState);
    pass2Controller.removeListener(updateButtonState);
    contactController.removeListener(updateButtonState);
    aboutController.removeListener(updateButtonState);
    email2Controller.removeListener(updateButtonState);
    confirmController.removeListener(updateButtonState);
    super.dispose();
  }
  Future<void> signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isRegistering = true;
      });

      final api = Api();

      try {
        await api.signUp(
          context,
          email2Controller.text,
          pass2Controller.text,
          nameController.text,
          contactController.text,
          aboutController.text,
        );
        Dialogs.showSnackbar(context, 'Registration successful');
      } catch (error) {
        Dialogs.showSnackbar(context, 'Registration failed');
      }

      setState(() {
        isRegistering = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
              onPressed: (){
                Navigator.pushReplacement(context, SizeTransition5(LoginScreen(value: widget.value,)));
              } ,
              icon: Icon(Icons.keyboard_arrow_left_outlined,color: Colors.black,size: 34,),
            ),
            backgroundColor: Colors.grey[50],
          ),
          body: Form(
            key: _formKey,
            child: SafeArea(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: mq.height*0.05,right: mq.width*0.14),
                        child: Text("Hello! Register to get\nstarted",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 27),),
                      ),
                      SizedBox(
                        height: mq.height * 0.04,
                      ),
                      CustomTextField(
                        hinttext: 'Enter Email',
                        labeltext: 'Email',
                        prefixicon: Icon(Icons.mail),
                        controller: email2Controller,
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
                        hinttext: 'Enter Name',
                        labeltext: 'Name',
                        prefixicon: Icon(Icons.drive_file_rename_outline),
                        controller: nameController,
                        isNumber: false,
                        isSecure: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter Name';
                          }
                          return null;
                        },
                      ),

                      SizedBox(
                        height: mq.height * 0.02,
                      ),
                      CustomTextField(
                        hinttext: 'Enter Contact Number',
                        labeltext: "Contact Number",
                        prefixicon: Icon(Icons.call),
                        controller: contactController,
                        isNumber: true,
                        isSecure: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: mq.height * 0.02,
                      ),
                      CustomTextField(
                        hinttext: 'About you',
                        labeltext: "About",
                        prefixicon: Icon(Icons.info_outline_rounded),
                        controller: aboutController,
                        isNumber: false,
                        isSecure: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter write something about you';
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
                        controller: pass2Controller,
                        isNumber: false,
                        isSecure: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          final passwordRegex = RegExp(r'^(?=.*[!@#\$%^&*])(?=.*[a-z])(?=.*[A-Z]).{6,}$');
                          if (!passwordRegex.hasMatch(value)) {
                            return 'Password must contain at least one special character, one lowercase letter, and one uppercase letter';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: mq.height * 0.02,
                      ),
                      CustomTextField(
                        hinttext: 'Confirm Password',
                        labeltext: 'Confirm Password',
                        prefixicon: Icon(Icons.confirmation_number_rounded),
                        controller: confirmController,
                        isNumber: false,
                        isSecure: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != pass2Controller.text) {
                            return 'Password does not match';
                          }
                          return null;
                        },
                      ),

                      SizedBox(
                        height: mq.height * 0.02,
                      ),
                      customButton(
                        onPressed: isButtonEnabled
                            ? () {
                          if (_formKey.currentState!.validate()) {

                            if (isRegistering) {
                              return null;
                            } else {
                              Center(
                                child: CircularProgressIndicator(backgroundColor: Colors.black,),
                              );
                              signUp().then((value) {
                                print("user created succesufully");
                                Navigator.pushReplacement(context,SizeTransition4(HomePage()));

                              });
                            }

                          }
                        }
                            : () {},
                        text: 'Register',
                        textColor: isButtonEnabled
                            ? Colors.white
                            : Colors.grey.shade700,
                        buttonColor: isButtonEnabled
                            ? AppColors.theme['splashScreenColor']
                            : Colors.grey,
                      ),
                      Row(
                        children: [
                          Padding(
                            padding:  EdgeInsets.only(left: mq.width*0.15),
                            child: Text("Already have an account ?",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: mq.width*0.01),
                            child: TextButton(onPressed: (){
                              Navigator.push(context, SizeTransition5(LoginScreen(value: widget.value,)));
                            }, child: Text("Login",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
                          ),
                        ]
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}