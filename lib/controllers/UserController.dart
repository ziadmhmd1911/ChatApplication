import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/User.dart';

class UserController {
  Future<List<Map<String, String>>> getAllUserData(String currentUser) async {
      final firestore = FirebaseFirestore.instance;
      final userCollection = firestore.collection('users');

      final querySnapshot = await userCollection.where('Id', isNotEqualTo: currentUser).get();

      final userData = querySnapshot.docs.map((doc) {
        return {
          'id': doc['Id'] as String,
          'username': doc['full_name'] as String,
        };
      }).toList();

      return userData;
  }

  Future<User> getUserByName(String name) async {
    final firestore = FirebaseFirestore.instance;
    final userCollection = firestore.collection('users');

    final querySnapshot = await userCollection.where('full_name', isEqualTo: name).get();

    if(querySnapshot.docs.isEmpty) {
      return User(id: '', full_name: '', email: '', phone: '');
    }

    final userData = querySnapshot.docs.map((doc) {
      return User(
        id: doc['Id'] as String,
        full_name: doc['full_name'] as String,
        email: doc['email'] as String,
        phone: doc['phone'] as String,
        gender: doc['gender'] as String,
      );
    });

    return userData.first;
  }
  
}