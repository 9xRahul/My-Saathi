import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

@injectable
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final UserRepository userRepository;

  OnboardingBloc(this.userRepository) : super(const OnboardingState()) {
    on<NextStepEvent>(_onNextStep);
    on<PreviousStepEvent>(_onPreviousStep);
    on<UpdateBasicInfoEvent>(_onUpdateBasicInfo);
    on<UpdateLifestyleEvent>(_onUpdateLifestyle);
    on<UpdateStatusEvent>(_onUpdateStatus);
    on<UpdateBioEvent>(_onUpdateBio);
    on<UploadProfilePictureEvent>(_onUploadProfilePicture);
    on<SubmitProfileEvent>(_onSubmitProfile);
  }

  void _onNextStep(NextStepEvent event, Emitter<OnboardingState> emit) {
    if (state.currentStep < 4) {
      emit(state.copyWith(currentStep: state.currentStep + 1, errorMessage: null));
    }
  }

  void _onPreviousStep(PreviousStepEvent event, Emitter<OnboardingState> emit) {
    if (state.currentStep > 1) {
      emit(state.copyWith(currentStep: state.currentStep - 1, errorMessage: null));
    }
  }

  void _onUpdateBasicInfo(UpdateBasicInfoEvent event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
      displayName: event.displayName,
      gender: event.gender,
      dob: event.dob,
    ));
    add(NextStepEvent());
  }

  void _onUpdateLifestyle(UpdateLifestyleEvent event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(
      interests: event.interests,
      hobbies: event.hobbies,
      drinking: event.drinking,
    ));
    add(NextStepEvent());
  }

  void _onUpdateStatus(UpdateStatusEvent event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(status: event.status));
    add(NextStepEvent());
  }

  void _onUpdateBio(UpdateBioEvent event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(bio: event.bio));
    add(NextStepEvent());
  }

  Future<void> _onUploadProfilePicture(UploadProfilePictureEvent event, Emitter<OnboardingState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await userRepository.uploadProfilePicture(event.file, event.userId);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (url) => emit(state.copyWith(isLoading: false, profilePicUrl: url)),
    );
  }

  Future<void> _onSubmitProfile(SubmitProfileEvent event, Emitter<OnboardingState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final user = UserEntity(
      id: event.userId,
      displayName: state.displayName,
      gender: state.gender,
      dob: state.dob,
      interests: state.interests,
      hobbies: state.hobbies,
      drinking: state.drinking,
      smoking: state.smoking,
      status: state.status,
      bio: state.bio,
      profilePicUrl: state.profilePicUrl,
      isProfileComplete: true,
    );

    final result = await userRepository.updateProfile(user);
    result.fold(
      (failure) => emit(state.copyWith(isLoading: false, errorMessage: failure.message)),
      (_) => emit(state.copyWith(isLoading: false, isProfileComplete: true)),
    );
  }
}
