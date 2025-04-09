import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
    debugPrint("Firebase initialized");
  }
}