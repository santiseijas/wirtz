import 'package:cloud_firestore/cloud_firestore.dart';

class MarkersRepository {
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

  static updateMarkers(String id, String userId,bool reservado) {
    Firestore.instance.runTransaction((Transaction transaction) async {
      await reference.document(id).updateData({
        "userId": userId,
        "reservado":reservado,
      }).catchError((error) {
        print(error);
      });
    });
  }


}