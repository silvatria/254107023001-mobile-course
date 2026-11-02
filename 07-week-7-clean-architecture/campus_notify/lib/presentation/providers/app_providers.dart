import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/announcement.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../domain/usecases/announcement_use_cases.dart';
import '../../domain/usecases/login.dart';

final announcementRepositoryProvider = Provider<AnnouncementRepository>(
  (ref) => throw StateError('Override the announcement repository at startup.'),
);

final getAnnouncementsProvider = Provider(
  (ref) => GetAnnouncements(ref.watch(announcementRepositoryProvider)),
);

final saveAnnouncementProvider = Provider(
  (ref) => SaveAnnouncement(ref.watch(announcementRepositoryProvider)),
);

final markAnnouncementAsReadProvider = Provider(
  (ref) => MarkAnnouncementAsRead(ref.watch(announcementRepositoryProvider)),
);

final authenticationRepositoryProvider = Provider<AuthenticationRepository>(
  (ref) =>
      throw StateError('Override the authentication repository at startup.'),
);

final loginProvider = Provider(
  (ref) => Login(ref.watch(authenticationRepositoryProvider)),
);

class AnnouncementNotifier extends StateNotifier<List<Announcement>> {
  AnnouncementNotifier({
    required this.getAnnouncements,
    required this.saveAnnouncement,
    required this.markAnnouncementAsRead,
  }) : super(const []) {
    _ready = _restore();
  }

  final GetAnnouncements getAnnouncements;
  final SaveAnnouncement saveAnnouncement;
  final MarkAnnouncementAsRead markAnnouncementAsRead;
  late final Future<void> _ready;

  Future<void> get ready => _ready;

  Future<void> _restore() async {
    state = await getAnnouncements();
  }

  Future<void> reload() async {
    await _ready;
    state = await getAnnouncements();
  }

  Future<Announcement?> findById(String id) async {
    await reload();
    for (final announcement in state) {
      if (announcement.id == id) return announcement;
    }
    return null;
  }

  Future<void> addOrUpdate(Announcement announcement) async {
    await _ready;
    final existingIndex = state.indexWhere(
      (item) => item.id == announcement.id,
    );
    final existing = existingIndex == -1 ? null : state[existingIndex];
    final updated = announcement.copyWith(isRead: existing?.isRead ?? false);

    await saveAnnouncement(updated);
    await reload();
  }

  Future<void> markAsRead(String id) async {
    await _ready;
    if (!state.any((item) => item.id == id && !item.isRead)) return;
    await markAnnouncementAsRead(id);
    await reload();
  }
}

final pengumumanProvider =
    StateNotifierProvider<AnnouncementNotifier, List<Announcement>>((ref) {
      return AnnouncementNotifier(
        getAnnouncements: ref.watch(getAnnouncementsProvider),
        saveAnnouncement: ref.watch(saveAnnouncementProvider),
        markAnnouncementAsRead: ref.watch(markAnnouncementAsReadProvider),
      );
    });

final unreadCountProvider = Provider<int>((ref) {
  final list = ref.watch(pengumumanProvider);
  return list.where((item) => !item.isRead).length;
});

final pengumumanReadyProvider = FutureProvider<void>((ref) {
  return ref.watch(pengumumanProvider.notifier).ready;
});

final authProvider = StateProvider<User?>((ref) => null);
