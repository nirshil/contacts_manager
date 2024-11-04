import 'package:contacts_manager/utilis/colorConstants.dart';
import 'package:contacts_manager/widgets/appTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SigninSignupForm extends StatelessWidget {
  final String heading;
  final TextEditingController emailcontroller;
  final TextEditingController passController;
  final TextEditingController? nameController;
  final TextEditingController? phoneController;
  final TextEditingController? cityController;
  final TextEditingController? dobController;
  final String buttonLabel;
  final VoidCallback ontap;
  final VoidCallback onTextButtontap;
  final String textButton;
  SigninSignupForm(
      {super.key,
      this.phoneController,
      this.isSignup = false,
      this.cityController,
      this.dobController,
      this.nameController,
      required this.onTextButtontap,
      required this.textButton,
      required this.ontap,
      required this.buttonLabel,
      required this.heading,
      required this.emailcontroller,
      required this.passController});
  final Widget sizedbox20 = const SizedBox(
    height: 20,
  );
  final Widget sizedbox15 = const SizedBox(
    height: 15,
  );
  bool isSignup;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: EdgeInsets.all(25),
          width: MediaQuery.of(context).size.width,
          height: isSignup
              ? MediaQuery.of(context).size.height * 0.8
              : MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 80, 78, 78),
              borderRadius: BorderRadius.circular(30)),
          child: Column(
            children: [
              text(
                heading: heading,
                decoration: TextDecoration.underline,
                size: 25,
              ),
              sizedbox20,
              formTextField(
                  hintText: 'Enter your email',
                  controller: emailcontroller,
                  fieldTitle: 'Email'),
              formTextField(
                  hintText: 'Enter your password',
                  controller: passController,
                  fieldTitle: 'Password'),
              isSignup
                  ? Column(
                      children: [
                        formTextField(
                            hintText: 'Enter your name',
                            controller: nameController!,
                            fieldTitle: 'Name'),
                        formTextField(
                            textInputType: TextInputType.phone,
                            hintText: 'Enter your phone number',
                            controller: phoneController!,
                            fieldTitle: 'Mobile'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: formTextField(
                                  hintText: 'Enter your city',
                                  controller: cityController!,
                                  fieldTitle: 'City'),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: formTextField(
                                  textInputType: TextInputType.datetime,
                                  hintText: 'Enter your DOB',
                                  controller: dobController!,
                                  fieldTitle: 'Date of birth'),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
              pageButton(buttonLabel: buttonLabel),
              InkWell(
                onTap: onTextButtontap,
                child: Text(
                  textButton,
                  style: TextStyle(color: Color.fromARGB(255, 255, 0, 0)),
                ),
              )
            ],
          )),
    );
  }

  Widget pageButton({
    required String buttonLabel,
  }) {
    return OutlinedButton(
      onPressed: ontap,
      child: Text(
        buttonLabel,
        style: TextStyle(color: ColorConstants.appmain, fontSize: 20),
      ),
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(const Color.fromARGB(255, 40, 39, 39)),
          minimumSize: MaterialStateProperty.all(Size(200, 50)),
          side: MaterialStateProperty.all(
              BorderSide(color: ColorConstants.appmain, width: 1.5)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
    );
  }

  Widget formTextField(
      {required String hintText,
      required TextEditingController controller,
      required String fieldTitle,
      TextInputType textInputType = TextInputType.name}) {
    Widget text({
      required String heading,
    }) {
      return Text(
        heading,
        style: const TextStyle(
            color: ColorConstants.appmain,
            fontSize: 20,
            fontWeight: FontWeight.bold),
      );
    }

    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: text(
            heading: fieldTitle,
          ),
        ),
        AppTextfield(
            keyboardType: textInputType,
            style: const TextStyle(color: Color.fromARGB(255, 168, 167, 167)),
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.appmain)),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: ColorConstants.appdivider)),
            controller: controller,
            hintText: hintText),
        sizedbox15
      ],
    );
  }

  Widget text(
      {required String heading,
      required double size,
      TextDecoration? decoration}) {
    return Text(
      heading,
      style: TextStyle(
          decorationColor: ColorConstants.appmain,
          decoration: decoration,
          decorationStyle: TextDecorationStyle.solid,
          color: ColorConstants.appmain,
          fontSize: size,
          fontWeight: FontWeight.bold),
    );
  }
}
