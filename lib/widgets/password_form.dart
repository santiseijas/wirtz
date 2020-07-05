import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextForm extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final IconData icon;
  final bool oscureText;
  final TextInputType type;

  const TextForm(
      {Key key,
      this.controller,
      this.text,
      this.icon,
      this.oscureText,
      this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(keyboardType: type,
      obscureText: oscureText,
      controller: controller,
      decoration: new InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.white,
        ),
        labelText: text,
        labelStyle: GoogleFonts.patuaOne(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            color: Colors.white),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
          color: Colors.white,
        )),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'La contraseña no puede estar vacia';
        }
        return null;
      },
    );
  }
}
