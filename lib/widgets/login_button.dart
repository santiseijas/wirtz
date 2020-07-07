import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final VoidCallback _onPressed;
  final Color color;
  final String text;

  MyButton({Key key, VoidCallback onPressed, this.text, this.color})
      : _onPressed = onPressed,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[

        InkWell(
          onTap: _onPressed,
          child: Container(
            width: 150,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: color == null ? Colors.white : color),
            child: Text(text.toUpperCase(),
                style: GoogleFonts.patuaOne(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                    color: color == null ? Colors.black : Colors.white)),
          ),
        )
      ],
    );
  }
}
