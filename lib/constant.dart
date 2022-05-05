import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_firestorage;

FirebaseAuth kFirebaseAuth = FirebaseAuth.instance;

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

CollectionReference collectionReference = firebaseFirestore.collection("user");

firebase_firestorage.FirebaseStorage storage =
    firebase_firestorage.FirebaseStorage.instance;
