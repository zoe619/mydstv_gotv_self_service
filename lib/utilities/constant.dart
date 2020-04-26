

// file to store references to our database collections

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

final Firestore _db = Firestore.instance;

final usersRef = _db.collection('users');
final tokensRef = _db.collection('DeviceTokens');

final FirebaseStorage _storage = FirebaseStorage.instance;
final storageRef = _storage.ref();

final DateFormat timeFormat = DateFormat('E, h:mm a');