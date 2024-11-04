import 'package:contacts_manager/screens/loginPage.dart';
import 'package:contacts_manager/services/firebaseServices.dart';
import 'package:contacts_manager/services/firestoreServices.dart';
import 'package:contacts_manager/utilis/colorConstants.dart';
import 'package:contacts_manager/widgets/formWidget.dart';
import 'package:contacts_manager/widgets/signupSigninForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  final TextEditingController numberController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  final FireBaseServices firebaseServices = FireBaseServices();
  final FirestoreServices firestoreServices = FirestoreServices();
  bool isLoading = false;

  void signupHandler() async {
    try {
      setState(() {
        isLoading = true;
      });
      await firebaseServices.registerUser(
          name: nameController.text,
          phone: numberController.text,
          city: cityController.text,
          email: emailController.text,
          password: passController.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.white, content: Text('Somthing went wrong')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.appbg,
      body: Padding(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        child: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : SigninSignupForm(
                    nameController: nameController,
                    phoneController: numberController,
                    dobController: dobController,
                    cityController: cityController,
                    isSignup: true,
                    textButton: 'Already have an account?Login now!!',
                    onTextButtontap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    buttonLabel: 'Signup',
                    emailcontroller: emailController,
                    passController: passController,
                    heading: 'Register now !!',
                    ontap: () {
                      signupHandler();
                    },
                  )),
      ),
    );
  }
}
