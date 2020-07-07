import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget  {
  final Widget leading;

  const MyAppBar({Key key, this.leading}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AppBar(leading:leading ,
      centerTitle: true,
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Wirtz',
          style: GoogleFonts.patuaOne(
            fontSize: 35,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Colors.indigo,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
