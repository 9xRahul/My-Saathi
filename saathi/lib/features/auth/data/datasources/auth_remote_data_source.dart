import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> verifyPhone({
    required String phoneNumber,
    required Function(String) codeSent,
    required Function(Exception) verificationFailed,
  });
  Future<UserModel> verifyOtp({
    required String verificationId,
    required String smsCode,
  });
  Future<void> setupPassword({required String password});
  Future<UserModel> loginWithPassword({
    required String phoneNumber,
    required String password,
  });
  Future<UserModel> getCurrentUser();
  Future<void> logout();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl(this.firebaseAuth, this.firestore);

  @override
  Future<void> verifyPhone({
    required String phoneNumber,
    required Function(String) codeSent,
    required Function(Exception) verificationFailed,
  }) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        verificationFailed(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        codeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Future<UserModel> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user == null) {
        throw Exception('User is null after OTP verification');
      }

      final doc = await firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) {
        final newUser = UserModel(
          id: user.uid,
          phoneNumber: user.phoneNumber,
        );
        await firestore.collection('users').doc(user.uid).set(newUser.toJson());
        return newUser;
      } else {
        return UserModel.fromJson(doc.data()!);
      }
    } catch (e) {
      throw Exception('Failed to verify OTP: \${e.toString()}');
    }
  }

  @override
  Future<void> setupPassword({required String password}) async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      try {
        await user.updatePassword(password);
      } catch (e) {
        throw Exception('Failed to setup password: \${e.toString()}');
      }
    } else {
      throw Exception('No user currently signed in.');
    }
  }

  @override
  Future<UserModel> loginWithPassword({
    required String phoneNumber,
    required String password,
  }) async {
    // Firebase Auth doesn't support phone+password login natively in a straightforward way.
    // However, if the user set a password, we can look up their email by phone or just 
    // use a custom scheme if we stored phone as email (e.g. phone@saathi.com).
    // Let's assume we map phone to email internally for password auth.
    try {
      final fakeEmail = '\${phoneNumber.replaceAll('', '')}@saathi.com';
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: fakeEmail,
        password: password,
      );
      final user = userCredential.user;
      if (user != null) {
        final doc = await firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromJson(doc.data()!);
        }
      }
      throw Exception('User not found');
    } catch (e) {
      throw Exception('Failed to login with password: \${e.toString()}');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      final doc = await firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
    }
    throw Exception('No current user');
  }

  @override
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
