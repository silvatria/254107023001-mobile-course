import '../entities/user.dart';

abstract interface class AuthenticationRepository {
  Future<User?> login({required String email, required String password});
}
