/*
import 'package:cloud_firestore/cloud_firestore.dart';

class MarkersModel {
  String name;
  int id;
  int latitude;
  int longitude;

  String type;
  // 2
  // 3
  DocumentReference reference;
  // 4
  // 5
  factory MarkersModel.fromSnapshot(DocumentSnapshot snapshot) {
    Pet newPet = Pet.fromJson(snapshot.data);
    newPet.reference = snapshot.reference;
    return newPet;
  }
  // 6
  factory Pet.fromJson(Map<String, dynamic> json) => _PetFromJson(json);
  // 7
  Map<String, dynamic> toJson() => _PetToJson(this);
  @override
  String toString() => "Pet<$name>";
}

}
*/
