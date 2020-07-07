import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wirtz/models/user_repository.dart';
import 'package:wirtz/widgets/login_button.dart';

class SubirImagen extends StatefulWidget {
  final UserRepository userRepository;

  const SubirImagen({Key key, this.userRepository}) : super(key: key);
  @override
  _SubirImagenState createState() => _SubirImagenState();
}

class _SubirImagenState extends State<SubirImagen> {
  File imagenFile;
  File imagenFile2;
  StorageUploadTask uploadTask;
  StorageUploadTask uploadTask2;
  final FirebaseStorage storage =
      FirebaseStorage(storageBucket: 'gs://beeto-f3425.appspot.com');

  final picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.getImage(
      source: source,
      maxHeight: MediaQuery.of(context).size.height * 0.3,
      maxWidth: MediaQuery.of(context).size.width * 0.5,
    );

    setState(() {
      imagenFile = File(pickedFile.path);
    });
  }

  Future<void> pickImage2(ImageSource source) async {
    final pickedFile = await picker.getImage(
      source: source,
      maxHeight: MediaQuery.of(context).size.height * 0.3,
      maxWidth: MediaQuery.of(context).size.width * 0.5,
    );

    setState(() {
      imagenFile2 = File(pickedFile.path);
    });
  }

  void clear() {
    setState(() {
      imagenFile = null;
      imagenFile2 = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Text(
              'Sube tu carnet de conducir para verificar tu identidad'
                  .toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.patuaOne(
                  fontSize: 23,
                  fontStyle: FontStyle.italic,
                  color: Colors.black)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Image.asset(
                'assets/images/carnet.jpg',
                height: 100,
              ),
              Image.asset(
                'assets/images/carnetDetras.jpg',
                height: 80,
              ),
            ],
          ),
          Text(
              'Tiene que ser por las dos partes y que se ven bien los datos'
                  .toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.patuaOne(
                  fontSize: 23,
                  fontStyle: FontStyle.italic,
                  color: Colors.black)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              MyButton(color: Colors.indigoAccent,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Parte de alante'),
                          actions: <Widget>[
                            Column(
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(
                                      Icons.picture_in_picture,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      pickImage(ImageSource.gallery);
                                      this.setState(() {});
                                      Navigator.of(context).pop();
                                    }),
                                Text('galeria'.toUpperCase(),
                                    style: GoogleFonts.patuaOne(
                                        letterSpacing: .5,
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black))
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(
                                      Icons.camera,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      pickImage(
                                        ImageSource.camera,
                                      );
                                      this.setState(() {});
                                      Navigator.of(context).pop();
                                    }),
                                Text('camara'.toUpperCase(),
                                    style: GoogleFonts.patuaOne(
                                        letterSpacing: .5,
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black))
                              ],
                            )
                          ],
                        );
                      });
                },
                text: 'parte de alante',
              ),
              MyButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Parte de atras'),
                          actions: <Widget>[
                            Column(
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(
                                      Icons.picture_in_picture,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      pickImage2(ImageSource.gallery);
                                      this.setState(() {});
                                      Navigator.of(context).pop();
                                    }),
                                Text('galeria'.toUpperCase(),
                                    style: GoogleFonts.patuaOne(
                                        letterSpacing: .5,
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black))
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(
                                      Icons.camera,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      pickImage2(
                                        ImageSource.camera,
                                      );
                                      this.setState(() {});
                                      Navigator.of(context).pop();
                                    }),
                                Text('camara'.toUpperCase(),
                                    style: GoogleFonts.patuaOne(
                                        letterSpacing: .5,
                                        fontSize: 14,
                                        fontStyle: FontStyle.normal,
                                        color: Colors.black))
                              ],
                            )
                          ],
                        );
                      });
                },
                text: 'parte de atras',
              ),
            ],
          ),SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              decideImage(imagenFile),
              decideImage(imagenFile2)
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 200,),
              cargarDatos(),
            ],
          )
        ],
      ),
    );
  }

  Future<void> startUpload() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    String filePath = 'images/$uid+' 'alante' '+${DateTime.now()}.png';
    String filePath2 = 'images/$uid+' + 'detras' '+${DateTime.now()}.png';

    setState(() {
      uploadTask = storage.ref().child(filePath).putFile(imagenFile);
      uploadTask2 = storage.ref().child(filePath2).putFile(imagenFile2);
    });
  }

  Widget decideImage(File imagen) {
    if (imagen == null) {
      return Text('Ninguna seleccionada');
    } else {
      return Image.file(
        imagen,
        fit: BoxFit.contain,
        width: MediaQuery.of(context).size.width * .4,
        height: MediaQuery.of(context).size.height * 0.18,
      );
    }
  }

  Widget cargarDatos() {
    if (uploadTask != null && uploadTask2 != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;
          double progressPercent =
              event != null ? event.bytesTransferred / event.totalByteCount : 0;
          return Column(
            children: <Widget>[
              if (uploadTask.isComplete&&uploadTask2.isComplete)
                Text('completado'.toUpperCase(),
                    style: GoogleFonts.patuaOne(
                        fontSize: 25,
                        fontStyle: FontStyle.italic,
                        color: Colors.black)),
              SizedBox(
                width: 100,
                child: LinearProgressIndicator(
                  value: progressPercent,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              )
            ],
          );
        },
      );
    } else {
      return MyButton(
        color: Colors.indigo,
        text: 'sube la foto',
        onPressed: startUpload,
      );
    }
  }
}


