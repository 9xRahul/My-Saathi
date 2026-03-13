import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> updateProfile(UserEntity user);
  Future<String> uploadProfilePicture(File imageFile, String userId);
}

@LazySingleton(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  UserRemoteDataSourceImpl(this.firestore, this.storage);

  @override
  Future<UserModel> updateProfile(UserEntity user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await firestore.collection('users').doc(user.id).update(userModel.toJson());
      
      final doc = await firestore.collection('users').doc(user.id).get();
      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      throw Exception('Failed to update profile: \${e.toString()}');
    }
  }

  @override
  Future<String> uploadProfilePicture(File imageFile, String userId) async {
    try {
      final ref = storage.ref().child('profile_pictures').child('\$userId.jpg');
      await ref.putFile(imageFile);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      throw Exception('Failed to upload profile picture: \${e.toString()}');
    }
  }
}
