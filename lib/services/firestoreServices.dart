import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> addData(
      {required String name,
      required String phone,
      required String uid,
      required String city}) async {
    final user = <String, String>{'name': name, 'phone': phone, 'city': city};
    try {
      await firestore.collection('User').doc(uid).set(user);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getData() async {
    try {
      await firestore.collection('User').doc().get();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteData(String uid) async {
    try {
      await firestore.collection('User').doc(uid).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateData(
      {required String uid,
      required String name,
      required String phone,
      required String city}) async {
    try {
      await firestore
          .collection('User')
          .doc(uid)
          .update({'name': name, 'phone': phone, 'city': city});
    } catch (e) {
      print(e);
    }
  }
}
