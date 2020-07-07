import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LandingScreen extends StatefulWidget {
  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  File imageFile;
  File imageFile2;
  final picker = ImagePicker();


  _openGallary(BuildContext context) async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {});
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {});
    Navigator.of(context).pop();
  }

  _openGallary2(BuildContext context) async {
    imageFile2 = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {});
    Navigator.of(context).pop();
  }

  _openCamera2(BuildContext context) async {
    imageFile2 = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {});
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a choice"),
            content: SingleChildScrollView(
                child: ListBody(
              children: [
                GestureDetector(
                  child: Text("Gallary"),
                  onTap: () {
                    _openGallary(context);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () {
                    _openCamera(context);
                  },
                ),
              ],
            )),
          );
        });
  }

  Future<void> _showChoiceDialog2(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a choice"),
            content: SingleChildScrollView(
                child: ListBody(
              children: [
                GestureDetector(
                  child: Text("Gallary"),
                  onTap: () {
                    _openGallary2(context);
                  },
                ),
                Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: Text("Camera"),
                  onTap: () {
                    _openCamera2(context);
                  },
                ),
              ],
            )),
          );
        });
  }

  Widget _decideImage() {
    if (imageFile == null) {
      return Text('No selected!');
    } else {
      return Image.file(
        imageFile,
        width: 200,
        height: 200,
      );
    }
  }

  Widget _decideImage2() {
    if (imageFile2 == null) {
      return Text('No selected!');
    } else {
      return Image.file(
        imageFile2,
        width: 200,
        height: 200,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _decideImage(),
              _decideImage2(),
              RaisedButton(
                onPressed: () {
                  _showChoiceDialog(context);
                  _showChoiceDialog2(context);
                },
                child: Text("Select Image"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
