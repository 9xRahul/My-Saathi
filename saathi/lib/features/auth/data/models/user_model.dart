import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    super.phoneNumber,
    super.displayName,
    super.gender,
    super.dob,
    super.interests,
    super.hobbies,
    super.drinking,
    super.smoking,
    super.status,
    super.bio,
    super.profilePicUrl,
    super.isProfileComplete,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      displayName: json['displayName'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] != null ? (json['dob'] as Timestamp).toDate() : null,
      interests: (json['interests'] as List<dynamic>?)?.map((e) => e as String).toList(),
      hobbies: (json['hobbies'] as List<dynamic>?)?.map((e) => e as String).toList(),
      drinking: json['drinking'] as String?,
      smoking: json['smoking'] as String?,
      status: json['status'] as String?,
      bio: json['bio'] as String?,
      profilePicUrl: json['profilePicUrl'] as String?,
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'displayName': displayName,
      'gender': gender,
      'dob': dob != null ? Timestamp.fromDate(dob!) : null,
      'interests': interests,
      'hobbies': hobbies,
      'drinking': drinking,
      'smoking': smoking,
      'status': status,
      'bio': bio,
      'profilePicUrl': profilePicUrl,
      'isProfileComplete': isProfileComplete,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      phoneNumber: entity.phoneNumber,
      displayName: entity.displayName,
      gender: entity.gender,
      dob: entity.dob,
      interests: entity.interests,
      hobbies: entity.hobbies,
      drinking: entity.drinking,
      smoking: entity.smoking,
      status: entity.status,
      bio: entity.bio,
      profilePicUrl: entity.profilePicUrl,
      isProfileComplete: entity.isProfileComplete,
    );
  }
}
