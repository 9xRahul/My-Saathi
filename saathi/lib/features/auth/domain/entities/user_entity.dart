import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String? phoneNumber;
  final String? displayName;
  final String? gender;
  final DateTime? dob;
  final List<String>? interests;
  final List<String>? hobbies;
  final String? drinking;
  final String? smoking;
  final String? status;
  final String? bio;
  final String? profilePicUrl;
  final bool isProfileComplete;

  const UserEntity({
    required this.id,
    this.phoneNumber,
    this.displayName,
    this.gender,
    this.dob,
    this.interests,
    this.hobbies,
    this.drinking,
    this.smoking,
    this.status,
    this.bio,
    this.profilePicUrl,
    this.isProfileComplete = false,
  });

  @override
  List<Object?> get props => [
        id,
        phoneNumber,
        displayName,
        gender,
        dob,
        interests,
        hobbies,
        drinking,
        smoking,
        status,
        bio,
        profilePicUrl,
        isProfileComplete,
      ];
}
