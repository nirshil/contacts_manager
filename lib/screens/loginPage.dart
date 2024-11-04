import 'package:contacts_manager/screens/homePage.dart';
import 'package:contacts_manager/services/firebaseServices.dart';
import 'package:contacts_manager/services/firestoreServices.dart';
import 'package:contacts_manager/utilis/colorConstants.dart';
import 'package:contacts_manager/widgets/signupSigninForm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passController = TextEditingController();

  final FireBaseServices _fireBaseServices = FireBaseServices();
  final FirestoreServices _firestoreServices = FirestoreServices();
  bool isLoading = false;

  void loginHandler() async {
    try {
      setState(() {
        isLoading = true;
      });
      await _fireBaseServices.LoginUser(
          email: emailController.text, password: passController.text);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('something went wrong')));
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
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : SigninSignupForm(
                  textButton: "Don't have an account? Register now!!",
                  onTextButtontap: () {
                    Navigator.pop(context);
                  },
                  ontap: () async {
                    loginHandler();
                  },
                  buttonLabel: 'Login',
                  heading: 'Login Now',
                  emailcontroller: emailController,
                  passController: passController),
        ),
      ),
    );
  }
}
