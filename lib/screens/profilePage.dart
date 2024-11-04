import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_manager/screens/loginPage.dart';
import 'package:contacts_manager/services/firebaseServices.dart';
import 'package:contacts_manager/services/firestoreServices.dart';
import 'package:contacts_manager/utilis/assetImageConstant.dart';
import 'package:contacts_manager/utilis/colorConstants.dart';
import 'package:contacts_manager/widgets/appTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirestoreServices _firestoreservices = FirestoreServices();

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  final FireBaseServices _service = FireBaseServices();

  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController cityController = TextEditingController();

  final Widget sizedbox30 = const SizedBox(
    height: 30,
  );

  Map<String, dynamic> data = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.appbg,
        body: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 60),
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('User')
                  .doc(userId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text("No data found.");
                }
                data = snapshot.data!.data() as Map<String, dynamic>;
                if (nameController.text.isEmpty) {
                  nameController.text = data['name'];
                  phoneController.text = data['phone'];
                  cityController.text = data['city'];
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: profileImage(),
                    ),
                    sizedbox30,
                    mainText(text: data['name'], size: 25),
                    mainText(text: data['phone'], size: 20),
                    mainText(text: data['city'], size: 20),
                    sizedbox30,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    const BorderSide(
                                        width: 2,
                                        color:
                                            Color.fromARGB(255, 0, 226, 120))),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)))),
                            onPressed: () {
                              showDialogbox(context);
                            },
                            child: const Text(
                              '  Update  ',
                              style: TextStyle(
                                  fontSize: 23,
                                  color: Color.fromARGB(255, 0, 226, 120)),
                            )),
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(255, 180, 12, 0)),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)))),
                            onPressed: () {
                              _service.deleteUser();
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            },
                            child: const Text(
                              'Delete Account',
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    )
                  ],
                );
              }),
        ));
  }

  Widget mainText({required String text, required double size}) {
    return Text(text,
        style: TextStyle(
            color: ColorConstants.applight,
            fontSize: size,
            fontWeight: FontWeight.bold));
  }

  void showDialogbox(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Update Details',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  dialogTextField(label: 'Name', controller: nameController),
                  dialogTextField(label: 'Phone', controller: phoneController),
                  dialogTextField(label: 'city', controller: cityController),
                  const SizedBox(
                    height: 35,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      dialogButton(
                          ontap: () async {
                            await _firestoreservices.updateData(
                                uid: userId,
                                name: nameController.text,
                                phone: phoneController.text,
                                city: cityController.text);
                            Navigator.pop(context);
                          },
                          label: 'Done',
                          color: const Color.fromARGB(255, 253, 17, 0)),
                      const SizedBox(
                        width: 15,
                      ),
                      dialogButton(
                          ontap: () {
                            Navigator.pop(context);
                          },
                          label: 'Cancel')
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget dialogButton(
      {required VoidCallback ontap,
      required String label,
      Color color = Colors.black}) {
    return InkWell(
      onTap: ontap,
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 21,
        ),
      ),
    );
  }

  Widget dialogTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return AppTextfield(
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(255, 240, 0, 0))),
      controller: controller,
      hintText: label,
      enabledBorder:
          UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    );
  }

  Widget profileImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AssetImageConstants().defaultProfile)),
          borderRadius: BorderRadius.circular(50),
          color: const Color.fromARGB(255, 70, 70, 70)),
    );
  }
}
