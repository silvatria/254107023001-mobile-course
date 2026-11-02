import '../entities/announcement.dart';
import '../repositories/announcement_repository.dart';

class GetAnnouncements {
  const GetAnnouncements(this._repository);

  final AnnouncementRepository _repository;

  Future<List<Announcement>> call() => _repository.getAll();
}

class SaveAnnouncement {
  const SaveAnnouncement(this._repository);

  final AnnouncementRepository _repository;

  Future<void> call(Announcement announcement) =>
      _repository.upsert(announcement);
}

class MarkAnnouncementAsRead {
  const MarkAnnouncementAsRead(this._repository);

  final AnnouncementRepository _repository;

  Future<void> call(String id) => _repository.markAsRead(id);
}
