import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserEntity>> updateProfile(UserEntity user);
  Future<Either<Failure, String>> uploadProfilePicture(File imageFile, String userId);
}
