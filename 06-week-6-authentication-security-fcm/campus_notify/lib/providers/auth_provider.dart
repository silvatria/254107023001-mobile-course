import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. Provider untuk State Auth utama
final authStateProvider = AsyncNotifierProvider<AuthNotifier, bool>(
  AuthNotifier.new,
);

class AuthNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    // Membaca token awal saat aplikasi pertama kali dimuat
    final token = await ref.read(tokenStoreProvider).readAccess();
    return token != null;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session = await ref
          .read(authRepositoryProvider)
          .login(email: email, password: password);
      await ref
          .read(tokenStoreProvider)
          .save(access: session.access, refresh: session.refresh);
      return true;
    });
  }

  Future<void> logout() async {
    await ref.read(tokenStoreProvider).clear();
    ref.invalidateSelf();
  }
}

final tokenStoreProvider = Provider((ref) => TokenStore());
final authRepositoryProvider = Provider((ref) => AuthRepository());

class TokenStore {
  Future<String?> readAccess() async => null;
  Future<void> save({required String access, required String refresh}) async {}
  Future<void> clear() async {}
}

class AuthSession {
  final String access = 'dummy_access_token';
  final String refresh = 'dummy_refresh_token';
}

class AuthRepository {
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return AuthSession();
  }
}
