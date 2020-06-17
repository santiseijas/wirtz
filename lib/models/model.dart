import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wirtz/models/marker_model.dart';
import 'package:wirtz/services/locator.dart';
import '../services/api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Model extends ChangeNotifier {
  Api _api = locator<Api>();

  List<Markers> products;


  Future<List<Markers>> fetchProducts() async {
    var result = await _api.getDataCollection();
    products = result.documents
        .map((doc) => Markers.fromMap(doc.data, doc.documentID))
        .toList();
    return products;
  }

  Stream<QuerySnapshot> fetchProductsAsStream() {
    return _api.streamDataCollection();
  }

  Future<Markers> getProductById(String id) async {
    var doc = await _api.getDocumentById(id);
    return  Markers.fromMap(doc.data, doc.documentID) ;
  }


  Future removeProduct(String id) async{
    await _api.removeDocument(id) ;
    return ;
  }
  Future updateProduct(Markers data,String id) async{
    await _api.updateDocument(data.toJson(), id) ;
    return ;
  }

  Future addProduct(Markers data) async{
    var result  = await _api.addDocument(data.toJson()) ;

    return result;

  }





}
