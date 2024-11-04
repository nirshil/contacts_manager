import 'package:contacts_manager/services/firestoreServices.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireBaseServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreServices _firestoreServices = FirestoreServices();
  Future<void> registerUser(
      {required String email,
      required String password,
      required String name,
      required String phone,
      required String city}) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        _firestoreServices.addData(
            name: name, phone: phone, uid: user.uid, city: city);
      }

      print(user);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> LoginUser(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestoreServices.deleteData(user.uid);
        await user.delete();
        await _auth.signOut();
      }
    } catch (e) {
      print(e);
    }
  }
}
