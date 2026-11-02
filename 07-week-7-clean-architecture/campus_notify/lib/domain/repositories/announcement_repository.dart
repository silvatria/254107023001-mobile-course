import '../entities/announcement.dart';

abstract interface class AnnouncementRepository {
  Future<List<Announcement>> getAll();

  Future<void> upsert(Announcement announcement);

  Future<void> markAsRead(String id);
}
