import 'package:contacts_manager/utilis/assetImageConstant.dart';
import 'package:contacts_manager/utilis/colorConstants.dart';
import 'package:flutter/material.dart';

class ContactTileWidget extends StatelessWidget {
  const ContactTileWidget(
      {super.key,
      required this.onTap,
      required this.image,
      required this.name,
      required this.number});
  final Widget image;
  final String name;
  final String number;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      tileColor: ColorConstants.appbg,
      leading: SizedBox(
        width: 50, // Specify a fixed width
        height: 50, // Specify a fixed height
        child: ClipRRect(
            borderRadius: BorderRadius.circular(
                25), // Match this to height/width for a circle
            child: image),
      ),
      title: tileText(
          text: name,
          color: ColorConstants.appmain,
          size: 18,
          weight: FontWeight.bold),
      subtitle: tileText(
          text: number, color: ColorConstants.applight, size: 15, space: 2),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    );
  }

  Widget tileText({
    required String text,
    required Color color,
    double space = 1,
    FontWeight weight = FontWeight.normal,
    required double size,
  }) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: weight,
          letterSpacing: space),
    );
  }
}
