import 'package:contacts_manager/utilis/colorConstants.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHeadings extends StatelessWidget {
  final String text;
  final double size;
  const AppHeadings({super.key, required this.text, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.teko(
          fontSize: size,
          color: ColorConstants.appmain,
          height: 1,
          letterSpacing: 2),
    );
  }
}
