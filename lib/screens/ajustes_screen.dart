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

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imagenFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Edita la foto',
            toolbarColor: Colors.indigo,
            toolbarWidgetColor: Colors.white,
            backgroundColor: Colors.indigo,
            cropGridColor: Colors.white,
            activeControlsWidgetColor: Colors.indigoAccent,
            initAspectRatio: CropAspectRatioPreset.original,
            dimmedLayerColor: Colors.white,
            statusBarColor: Colors.indigo,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      imagenFile = croppedFile;
      setState(() {
        imagenFile = croppedFile ?? imagenFile;
      });
    }
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
              LoginButton(
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
                                  onPressed: () =>
                                      pickImage(ImageSource.gallery),
                                ),
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
                                  onPressed: () => pickImage(
                                    ImageSource.camera,
                                  ),
                                ),
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
              LoginButton(
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
                                  onPressed: () =>
                                      pickImage2(ImageSource.gallery),
                                ),
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
                                  onPressed: () => pickImage2(
                                    ImageSource.camera,
                                  ),
                                ),
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
          ),
          if (imagenFile != null && imagenFile2 != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Image.file(
                  imagenFile,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * .4,
                  height: MediaQuery.of(context).size.height * 0.18,
                ),
                Image.file(
                  imagenFile2,
                  fit: BoxFit.contain,
                  width: MediaQuery.of(context).size.width * .4,
                  height: MediaQuery.of(context).size.height * 0.18,
                ),
              ],
            ),
            /* Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    color: Colors.indigo,
                    icon: Icon(Icons.crop),
                    onPressed: _cropImage,
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  IconButton(
                    color: Colors.indigo,
                    iconSize: 30,
                    icon: Icon(Icons.refresh),
                    onPressed: clear,
                  )
                ],
              ),
            ),*/
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Uploader(
                  file2: imagenFile2,
                  file: imagenFile,
                  userRepository: widget.userRepository,
                ),
              ],
            )
          ],
        ],
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  final UserRepository userRepository;
  final File file;
  final File file2;

  const Uploader({Key key, this.file, this.userRepository, this.file2})
      : super(key: key);
  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage storage =
      FirebaseStorage(storageBucket: 'gs://beeto-f3425.appspot.com');

  StorageUploadTask uploadTask;
  StorageUploadTask uploadTask2;

  Future<void> startUpload() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    String filePath = 'images/$uid+' 'alante' '+${DateTime.now()}.png';
    String filePath2 = 'images/$uid+' + 'detras' '+${DateTime.now()}.png';

    setState(() {
      uploadTask = storage.ref().child(filePath).putFile(widget.file);
      uploadTask2 = storage.ref().child(filePath2).putFile(widget.file2);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;
          double progressPercent =
              event != null ? event.bytesTransferred / event.totalByteCount : 0;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (uploadTask.isComplete)
                Text('completado'.toUpperCase(),
                    style: GoogleFonts.patuaOne(
                        fontSize: 25,
                        fontStyle: FontStyle.italic,
                        color: Colors.black)),
              LinearProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                value: progressPercent,
              ),
            ],
          );
        },
      );
    } else {
      return LoginButton(
        color: Colors.indigo,
        text: 'sube la foto',
        onPressed: startUpload,
      );
    }

  }
}
