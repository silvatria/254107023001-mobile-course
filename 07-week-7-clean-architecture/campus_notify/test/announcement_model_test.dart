import 'package:campus_notify/data/models/announcement_data_model.dart';
import 'package:campus_notify/domain/entities/announcement.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('announcement keeps its detail and read state when stored', () {
    const announcement = Announcement(
      id: 'notice-1',
      title: 'Perubahan jadwal',
      description: 'Kelas dimulai pukul 10.00.',
      isRead: true,
    );

    final restored = AnnouncementDataModel.fromJson(
      AnnouncementDataModel.fromEntity(announcement).toJson(),
    ).toEntity();

    expect(restored.id, announcement.id);
    expect(restored.title, announcement.title);
    expect(restored.description, announcement.description);
    expect(restored.isRead, isTrue);
  });

  test('copyWith can mark an announcement as read', () {
    const announcement = Announcement(
      id: 'notice-2',
      title: 'Rapat',
      description: 'Rapat dimulai pukul 13.00.',
    );

    final readAnnouncement = announcement.copyWith(isRead: true);

    expect(readAnnouncement.isRead, isTrue);
    expect(readAnnouncement.id, announcement.id);
    expect(readAnnouncement.description, announcement.description);
  });
}
