import 'package:contacts_manager/modal/contactModel.dart';
import 'package:contacts_manager/services/dbDatabase.dart';
import 'package:contacts_manager/utilis/assetImageConstant.dart';
import 'package:contacts_manager/utilis/colorConstants.dart';
import 'package:contacts_manager/utilis/textConstants.dart';
import 'package:contacts_manager/widgets/appHeadings.dart';
import 'package:contacts_manager/widgets/formWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddOrEditContactPage extends StatefulWidget {
  final bool isEdit;
  final int? index;

  List<ContactModel>? contacts;
  AddOrEditContactPage(
      {super.key, this.isEdit = false, this.contacts, this.index});

  @override
  State<AddOrEditContactPage> createState() => _AddOrEditContactPageState();
}

class _AddOrEditContactPageState extends State<AddOrEditContactPage> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();
  Uint8List? imageBytes;
  String selectedtag = '';
  String tagselected = '';
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  DbDatabase _database = DbDatabase();
  bool updatedImageSelected = false;
  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      nameController.text = widget.contacts![widget.index!].name;
      emailController.text = widget.contacts![widget.index!].email!;
      phoneController.text = widget.contacts![widget.index!].phoneNumber;
      addressController.text = widget.contacts![widget.index!].address!;
      if (widget.contacts![widget.index!].image != null) {
        imageBytes = widget.contacts![widget.index!].image!;
      }

      print(widget.contacts![widget.index!].tags!);

      if (widget.contacts![widget.index!].tags != null) {
        tagselected = widget.contacts![widget.index!].tags!;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.appbg,
        body: Padding(
          padding: EdgeInsets.only(top: 40, left: 20, right: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppHeadings(
                  text: widget.isEdit
                      ? TextConstants.updatePageHeading
                      : TextConstants.addPageHeading,
                  size: 30,
                ),
                SizedBox(
                  height: 20,
                ),
                imageBanner(),
                SizedBox(
                  height: 20,
                ),
                FormWidget(
                  selectedTag: widget.isEdit ? tagselected : selectedtag,
                  passTag: (tag) {
                    setState(() {
                      selectedtag = tag;
                    });
                  },
                  nameController: nameController,
                  phoneController: phoneController,
                  emailController: emailController,
                  addressController: addressController,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: InkWell(
          onTap: widget.isEdit
              ? () async {
                  if (_image != null) {
                    imageBytes = await _image!.readAsBytes();
                  }
                  var updatedContact = ContactModel(
                      name: nameController.text,
                      phoneNumber: phoneController.text,
                      id: widget.contacts![widget.index!].id,
                      address: addressController.text,
                      email: emailController.text,
                      tags: selectedtag,
                      image: imageBytes);
                  await _database.updateContact(updatedContact);
                  print('success');
                  print(await _database.contact());
                  clearController();
                  Navigator.pop(context, true);
                }
              : () async {
                  if (nameController.text.isNotEmpty &&
                      phoneController.text.isNotEmpty &&
                      phoneController.text.length == 10) {
                    await addData();
                    clearController();
                    Navigator.pop(
                      context,
                    );
                  } else {
                    print('failed');
                  }
                },
          child: BottomAppBar(
            color: ColorConstants.appmain,
            child: Center(
                child: Text(
              widget.isEdit ? "Update" : "Add",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            )),
          ),
        ));
  }

  Widget imageBanner() {
    return InkWell(
      onTap: () async {
        await _pickImage(ImageSource.gallery);
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: widget.isEdit &&
                    widget.contacts![widget.index!].image != null &&
                    updatedImageSelected == false
                ? MemoryImage(widget.contacts![widget.index!].image!)
                : _image != null
                    ? FileImage(_image!)
                    : AssetImage(AssetImageConstants().defaultProfile)
                        as ImageProvider,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(90),
          color: ColorConstants.appdivider,
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        updatedImageSelected = true;
      });
    }
  }

  Future<void> addData() async {
    if (_image != null) {
      imageBytes = await _image!.readAsBytes();
    }
    var contact = ContactModel(
        name: nameController.text,
        phoneNumber: phoneController.text,
        email: emailController.text,
        address: addressController.text,
        tags: selectedtag,
        image: imageBytes);
    _database.insertData(contact);
  }

  void clearController() {
    emailController.clear();
    nameController.clear();
    phoneController.clear();
    addressController.clear();
  }
}
