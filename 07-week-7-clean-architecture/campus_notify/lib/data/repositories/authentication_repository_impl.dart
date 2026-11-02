import '../../domain/entities/user.dart';
import '../../domain/repositories/authentication_repository.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  static const _accounts = [
    _DemoAccount(
      user: User(
        nim: '254107023001',
        name: 'Chen',
        email: 'chen@polinema.ac.id',
      ),
      password: 'password123',
    ),
    _DemoAccount(
      user: User(
        nim: '254107023002',
        name: 'Mahasiswa Demo',
        email: 'demo@polinema.ac.id',
      ),
      password: '123',
    ),
  ];

  @override
  Future<User?> login({required String email, required String password}) async {
    for (final account in _accounts) {
      if (account.user.email == email && account.password == password) {
        return account.user;
      }
    }
    return null;
  }
}

class _DemoAccount {
  const _DemoAccount({required this.user, required this.password});

  final User user;
  final String password;
}
