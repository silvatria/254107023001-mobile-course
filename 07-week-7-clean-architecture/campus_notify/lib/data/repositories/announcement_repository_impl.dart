import 'package:app_badge_plus/app_badge_plus.dart';

import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../datasources/announcement_storage.dart';
import '../models/announcement_data_model.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  AnnouncementRepositoryImpl({AnnouncementLocalDataSource? dataSource})
    : _dataSource = dataSource ?? AnnouncementLocalDataSource();

  final AnnouncementLocalDataSource _dataSource;

  @override
  Future<List<Announcement>> getAll() async {
    final announcements = await _loadAll();
    await _updateBadge(announcements);
    return announcements;
  }

  @override
  Future<void> upsert(Announcement announcement) async {
    await _dataSource.upsert(
      AnnouncementDataModel.fromEntity(announcement).toJson(),
    );
    await _updateBadge(await _loadAll());
  }

  @override
  Future<void> markAsRead(String id) async {
    final announcements = await _loadAll();
    if (!announcements.any((item) => item.id == id && !item.isRead)) return;

    await _dataSource.saveAll(
      announcements
          .map(
            (item) => AnnouncementDataModel.fromEntity(
              item.id == id ? item.copyWith(isRead: true) : item,
            ).toJson(),
          )
          .toList(growable: false),
    );
    await _updateBadge(await _loadAll());
  }

  Future<List<Announcement>> _loadAll() async {
    final stored = await _dataSource.readAll();
    return stored
            ?.map(AnnouncementDataModel.fromJson)
            .map((model) => model.toEntity())
            .toList(growable: false) ??
        const <Announcement>[];
  }

  Future<void> _updateBadge(List<Announcement> announcements) async {
    final unreadCount = announcements.where((item) => !item.isRead).length;
    if (await AppBadgePlus.isSupported()) {
      await AppBadgePlus.updateBadge(unreadCount);
    }
  }
}
