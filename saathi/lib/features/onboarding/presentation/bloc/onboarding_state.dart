import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final int currentStep;
  final bool isLoading;
  final String? errorMessage;
  // Basic Info
  final String? displayName;
  final String? gender;
  final DateTime? dob;
  // Lifestyle
  final List<String> interests;
  final List<String> hobbies;
  final String? drinking;
  // Habits & Intent
  final String? smoking;
  final String? status;
  final String? bio;
  // Final Identity
  final String? profilePicUrl;
  final bool isProfileComplete;

  const OnboardingState({
    this.currentStep = 1,
    this.isLoading = false,
    this.errorMessage,
    this.displayName,
    this.gender,
    this.dob,
    this.interests = const [],
    this.hobbies = const [],
    this.drinking,
    this.smoking,
    this.status,
    this.bio,
    this.profilePicUrl,
    this.isProfileComplete = false,
  });

  OnboardingState copyWith({
    int? currentStep,
    bool? isLoading,
    String? errorMessage,
    String? displayName,
    String? gender,
    DateTime? dob,
    List<String>? interests,
    List<String>? hobbies,
    String? drinking,
    String? smoking,
    String? status,
    String? bio,
    String? profilePicUrl,
    bool? isProfileComplete,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Reset error on change if null passed
      displayName: displayName ?? this.displayName,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      interests: interests ?? this.interests,
      hobbies: hobbies ?? this.hobbies,
      drinking: drinking ?? this.drinking,
      smoking: smoking ?? this.smoking,
      status: status ?? this.status,
      bio: bio ?? this.bio,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      isProfileComplete: isProfileComplete ?? this.isProfileComplete,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        isLoading,
        errorMessage,
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
