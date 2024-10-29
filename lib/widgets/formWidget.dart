import 'package:contacts_manager/screens/addOrEditContactPage.dart';
import 'package:contacts_manager/utilis/colorConstants.dart';
import 'package:contacts_manager/widgets/appTextField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FormWidget extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final TextEditingController emailController;
  final List<String> tags = ['Family ', 'Work ', 'Friends '];
  final Function(String) passTag;

  final String selectedTag;
  FormWidget(
      {super.key,
      required this.passTag,
      required this.nameController,
      required this.phoneController,
      required this.addressController,
      required this.emailController,
      required this.selectedTag});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  int selectedindex = -1;

  Widget sizedbox = SizedBox(
    height: 20,
  );
  @override
  void initState() {
    super.initState();
    // Use the selectedTag from AddOrEditContactPage to set selectedindex only if editing
    if (widget.selectedTag.isNotEmpty) {
      selectedindex = widget.tags.indexOf(widget.selectedTag);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fieldTitle(
            fieldName: 'Name ',
          ),
          formTextField(
              controller: widget.nameController, hintText: 'Enter your name'),
          sizedbox,
          fieldTitle(
            fieldName: 'Phone ',
          ),
          formTextField(
              maxlength: 10,
              type: TextInputType.phone,
              controller: widget.phoneController,
              hintText: 'Enter your phone'),
          sizedbox,
          fieldTitle(
            fieldName: 'Email',
          ),
          formTextField(
              controller: widget.emailController, hintText: 'Enter your email'),
          sizedbox,
          fieldTitle(
            fieldName: 'Address',
          ),
          formTextField(
              controller: widget.addressController,
              hintText: 'Enter your address'),
          SizedBox(
            height: 15,
          ),
          tagList(widget.tags)
        ],
      ),
    );
  }

  Widget fieldTitle({
    required String fieldName,
  }) {
    return Text(
      fieldName,
      style: TextStyle(
          color: Color.fromARGB(255, 114, 114, 114),
          fontSize: 20,
          fontWeight: FontWeight.w500),
    );
  }

  Widget formTextField(
      {required TextEditingController controller,
      required String hintText,
      int? maxlength,
      TextInputType type = TextInputType.name}) {
    return AppTextfield(
      maxlength: maxlength,
      keyboardType: type,
      enteredTextColor: ColorConstants.applight,
      padding: EdgeInsets.only(left: 0),
      controller: controller,
      hintText: hintText,
      style: const TextStyle(
          color: Color.fromARGB(131, 130, 130, 130), fontSize: 18),
      focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.appmain)),
      border: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.appdivider)),
      enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: ColorConstants.appdivider)),
    );
  }

  Widget tagList(List<String> tags) {
    Text tagText({required String text, required int index}) {
      return Text(
        text,
        style: TextStyle(
            color: selectedindex == index
                ? ColorConstants.appmain
                : ColorConstants.appdivider,
            fontSize: 15,
            fontWeight: FontWeight.w600),
      );
    }

    Icon icon({required int index}) {
      return Icon(
        selectedindex == index
            ? Icons.radio_button_on_outlined
            : Icons.radio_button_off_outlined,
        color: selectedindex == index
            ? ColorConstants.appmain
            : ColorConstants.appdivider,
      );
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
            tags.length,
            (index) => InkWell(
                  onTap: () {
                    setState(() {
                      selectedindex = index;
                    });
                    widget.passTag(tags[index]);
                  },
                  child: Row(
                    children: [
                      tagText(text: tags[index], index: index),
                      icon(index: index),
                    ],
                  ),
                )));
  }
}
