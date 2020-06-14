import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseAPI {
  static Stream<QuerySnapshot> markersStream =
  Firestore.instance.collection('markers').snapshots();

  static CollectionReference reference =
  Firestore.instance.collection('markers');

  static addMarkers(String titulo,String descripcion) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.add({
        "titulo": titulo,
        "descripcion": descripcion,
      });
    });
  }

  static removeMarkers(String id) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).delete().catchError((error) {
        print(error);
      });
    });
  }

  static updateMarkers(String id, String newTitulo, String newDes) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).updateData({
        "titulo": newTitulo,
        "descripcion": newDes,
      }).catchError((error) {
        print(error);
      });
    });
  }
  static updateCheck(String id, bool newCheck) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).updateData({
        "check": newCheck,
      }).catchError((error) {
        print(error);
      });
    });
  }

}