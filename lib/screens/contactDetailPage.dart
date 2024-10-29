import 'dart:ui';

import 'package:contacts_manager/modal/contactModel.dart';
import 'package:contacts_manager/screens/addOrEditContactPage.dart';
import 'package:contacts_manager/screens/homePage.dart';
import 'package:contacts_manager/services/dbDatabase.dart';
import 'package:contacts_manager/utilis/assetImageConstant.dart';
import 'package:contacts_manager/utilis/colorConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class ContactDetailPage extends StatefulWidget {
  ContactDetailPage({
    super.key,
    required this.index,
  });
  final int index;

  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  DbDatabase _database = DbDatabase();
  List<ContactModel>? contact;
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    getContacts();
  }

  Future<void> getContacts() async {
    contact = await _database.contact();
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(contact == null);
    if (isloading) {
      return Scaffold(
        backgroundColor: ColorConstants.appbg,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (contact == null || widget.index >= contact!.length) {
      return Scaffold(
        backgroundColor: ColorConstants.appbg,
        body: Center(
          child: Text(
            'Contact not found',
            style: TextStyle(color: ColorConstants.applight, fontSize: 20),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: ColorConstants.appbg,
      body: Padding(
        padding: EdgeInsets.only(top: 60, left: 15, right: 15),
        child: Column(
          children: [
            topButtons(context),
            SizedBox(
              height: 30,
            ),
            imageBanner(context, image: contact?[widget.index].image),
            pageText(
                data: contact![widget.index].name,
                size: 55,
                weight: FontWeight.bold),
            pageText(
                data: contact![widget.index].phoneNumber,
                size: 30,
                weight: FontWeight.w500),
            pageText(
                data: contact?[widget.index].email == null ||
                        contact![widget.index].email!.isEmpty
                    ? 'Email not available'
                    : contact![widget.index].email,
                size: 25,
                weight: FontWeight.w500),
            pageText(
                data: contact?[widget.index].address == null ||
                        contact![widget.index].address!.isEmpty
                    ? 'Address not available'
                    : contact![widget.index].address,
                size: 25,
                weight: FontWeight.w500)
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
        child: deleteButton(ontap: () async {
          await _database.deleteContact(contact![widget.index].id!);
          Navigator.pop(context);
        }),
      ),
    );
  }

  Widget topButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.only(left: 5),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: const Color.fromARGB(113, 130, 130, 130),
                borderRadius: BorderRadius.circular(50)),
            child: Center(child: Icon(Icons.arrow_back_ios)),
          ),
        ),
        InkWell(
          onTap: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddOrEditContactPage(
                          isEdit: true,
                          contacts: contact,
                          index: widget.index,
                        )));
            getContacts();
          },
          child: Container(
            width: 70,
            height: 40,
            decoration: BoxDecoration(
                color: const Color.fromARGB(113, 130, 130, 130),
                borderRadius: BorderRadius.circular(50)),
            child: Center(
                child: Text(
              'edit',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            )),
          ),
        )
      ],
    );
  }

  Widget imageBanner(BuildContext context, {Uint8List? image}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          image: image == null
              ? AssetImage(AssetImageConstants().defaultProfile)
                  as ImageProvider
              : MemoryImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget pageText(
      {String? data, required double size, required FontWeight weight}) {
    return Text(
      data!,
      style: TextStyle(
          fontSize: size, color: ColorConstants.applight, fontWeight: weight),
    );
  }

  Widget deleteButton({required VoidCallback ontap}) {
    return OutlinedButton(
      onPressed: ontap,
      child: Text(
        'Delete Contact',
        style: TextStyle(color: Colors.red, fontSize: 20),
      ),
      style: ButtonStyle(
          side: MaterialStateProperty.all(BorderSide(color: Colors.red)),
          minimumSize: MaterialStateProperty.all(Size(200, 50)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
    );
  }
}
