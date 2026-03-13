import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> verifyPhone({
    required String phoneNumber,
    required Function(String verificationId) codeSent,
    required Function(Failure failure) verificationFailed,
  });

  Future<Either<Failure, UserEntity>> verifyOtp({
    required String verificationId,
    required String smsCode,
  });

  Future<Either<Failure, void>> setupPassword({
    required String password,
  });

  Future<Either<Failure, UserEntity>> loginWithPassword({
    required String phoneNumber,
    required String password,
  });

  Future<Either<Failure, UserEntity>> getCurrentUser();
  
  Future<Either<Failure, void>> logout();
}
