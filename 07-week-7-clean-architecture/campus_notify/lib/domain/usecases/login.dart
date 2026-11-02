import '../entities/user.dart';
import '../repositories/authentication_repository.dart';

class Login {
  const Login(this._repository);

  final AuthenticationRepository _repository;

  Future<User?> call({required String email, required String password}) {
    return _repository.login(email: email, password: password);
  }
}
