
import 'package:cloud_firestore/cloud_firestore.dart';

class Tokens{
  String id;
  String token;

  Tokens({this.id, this.token});

  factory Tokens.fromDoc(DocumentSnapshot doc){
    return Tokens(
      id: doc.documentID,
      token: doc['device_token'],
    );
  }
}