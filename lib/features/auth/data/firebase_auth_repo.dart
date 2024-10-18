import 'package:abhiman_assignment/features/auth/domain/entities/app_user.dart';
import 'package:abhiman_assignment/features/auth/domain/repos/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      //atempt the sign in
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      //fetch user doc form firestore
      DocumentSnapshot userDoc = await firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // create user
      AppUser user = AppUser(
          uid: userCredential.user!.uid, email: email, name: userDoc['name']);
      //return user
      return user;
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  @override
  Future<AppUser?> signupWithEmailPassword(
      String name, String email, String password) async {
    try {
      //atempt the sign up
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // create user
      AppUser user =
          AppUser(uid: userCredential.user!.uid, email: email, name: name);

      //save user data in firestore
      await firebaseFirestore
          .collection("users")
          .doc(user.uid)
          .set(user.toJson());
      //return user
      return user;
    } catch (e) {
      throw Exception("Login failed: $e");
    }
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    //get current logged in user from firebase
    final firebaseUser = firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
    }
    DocumentSnapshot userDoc =
        await firebaseFirestore.collection("user").doc(firebaseUser.uid).get();
    //check if user exist
    if (!userDoc.exists) {
      return null;
    }
    return AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        name: userDoc['name']);
  }
}
