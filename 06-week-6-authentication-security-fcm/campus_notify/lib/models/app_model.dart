import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:app_badge_plus/app_badge_plus.dart';

import '../data/announcement_storage.dart';

class UserModel {
  final String nim;
  final String nama;
  final String email;
  final String password;

  UserModel({
    required this.nim,
    required this.nama,
    required this.email,
    required this.password,
  });
}

class PengumumanModel {
  final String id;
  final String judul;
  final String deskripsi;
  final bool isRead;

  const PengumumanModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    this.isRead = false,
  });

  factory PengumumanModel.fromJson(Map<String, dynamic> json) {
    return PengumumanModel(
      id: json['id'] as String,
      judul: json['judul'] as String,
      deskripsi: json['deskripsi'] as String,
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'judul': judul,
    'deskripsi': deskripsi,
    'isRead': isRead,
  };

  PengumumanModel copyWith({bool? isRead}) {
    return PengumumanModel(
      id: id,
      judul: judul,
      deskripsi: deskripsi,
      isRead: isRead ?? this.isRead,
    );
  }
}

// Mock Data Users
final List<UserModel> dummyUsers = [
  UserModel(
    nim: '254107023001',
    nama: 'Chen',
    email: 'chen@polinema.ac.id',
    password: 'password123',
  ),
  UserModel(
    nim: '254107023002',
    nama: 'Mahasiswa Demo',
    email: 'demo@polinema.ac.id',
    password: '123',
  ),
];

// StateNotifier untuk mengelola list pengumuman & sinkronisasi Badge App Icon
class PengumumanNotifier extends StateNotifier<List<PengumumanModel>> {
  PengumumanNotifier({AnnouncementStorage? storage})
    : _storage = storage ?? AnnouncementStorage(),
      super(const []) {
    _ready = _restore();
  }

  final AnnouncementStorage _storage;
  late final Future<void> _ready;

  Future<void> get ready => _ready;

  Future<void> _restore() async {
    final stored = await _storage.readAll();
    state =
        stored?.map(PengumumanModel.fromJson).toList(growable: false) ??
        const [];
    await _updateBadge();
  }

  Future<void> reload() async {
    await _ready;
    final stored = await _storage.readAll();
    if (stored == null) return;
    state = stored.map(PengumumanModel.fromJson).toList(growable: false);
    await _updateBadge();
  }

  Future<PengumumanModel?> findById(String id) async {
    await reload();
    for (final announcement in state) {
      if (announcement.id == id) return announcement;
    }
    return null;
  }

  Future<void> addOrUpdate(PengumumanModel announcement) async {
    await _ready;
    final existingIndex = state.indexWhere(
      (item) => item.id == announcement.id,
    );
    final existing = existingIndex == -1 ? null : state[existingIndex];
    final updated = announcement.copyWith(isRead: existing?.isRead ?? false);

    state = [
      updated,
      for (final item in state)
        if (item.id != announcement.id) item,
    ];
    await _persistAndUpdateBadge();
  }

  Future<void> markAsRead(String id) async {
    await _ready;
    if (!state.any((item) => item.id == id && !item.isRead)) return;
    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(isRead: true) else item,
    ];
    await _persistAndUpdateBadge();
  }

  Future<void> _persistAndUpdateBadge() async {
    await _storage.saveAll(state.map((item) => item.toJson()).toList());
    await _updateBadge();
  }

  Future<void> _updateBadge() async {
    final unreadCount = state.where((item) => !item.isRead).length;
    if (await AppBadgePlus.isSupported()) {
      await AppBadgePlus.updateBadge(unreadCount);
    }
  }
}

final pengumumanProvider =
    StateNotifierProvider<PengumumanNotifier, List<PengumumanModel>>((ref) {
      return PengumumanNotifier();
    });

final unreadCountProvider = Provider<int>((ref) {
  final list = ref.watch(pengumumanProvider);
  return list.where((item) => !item.isRead).length;
});

final pengumumanReadyProvider = FutureProvider<void>((ref) {
  return ref.watch(pengumumanProvider.notifier).ready;
});

// Auth State Provider
final authProvider = StateProvider<UserModel?>((ref) => null);
