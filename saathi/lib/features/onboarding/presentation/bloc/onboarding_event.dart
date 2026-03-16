import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class NextStepEvent extends OnboardingEvent {}

class PreviousStepEvent extends OnboardingEvent {}

class UpdateBasicInfoEvent extends OnboardingEvent {
  final String displayName;
  final String gender;
  final DateTime dob;

  const UpdateBasicInfoEvent({
    required this.displayName,
    required this.gender,
    required this.dob,
  });

  @override
  List<Object> get props => [displayName, gender, dob];
}

class UpdateLifestyleEvent extends OnboardingEvent {
  final List<String> interests;
  final List<String> hobbies;
  final String drinking;

  const UpdateLifestyleEvent({
    required this.interests,
    required this.hobbies,
    required this.drinking,
  });

  @override
  List<Object> get props => [interests, hobbies, drinking];
}

class UpdateStatusEvent extends OnboardingEvent {
  final String status;

  const UpdateStatusEvent(this.status);

  @override
  List<Object> get props => [status];
}

class UpdateBioEvent extends OnboardingEvent {
  final String bio;

  const UpdateBioEvent(this.bio);

  @override
  List<Object> get props => [bio];
}

class UploadProfilePictureEvent extends OnboardingEvent {
  final File file;
  final String userId;

  const UploadProfilePictureEvent({required this.file, required this.userId});

  @override
  List<Object> get props => [file, userId];
}

class SubmitProfileEvent extends OnboardingEvent {
  final String userId;
  const SubmitProfileEvent(this.userId);

  @override
  List<Object> get props => [userId];
}
