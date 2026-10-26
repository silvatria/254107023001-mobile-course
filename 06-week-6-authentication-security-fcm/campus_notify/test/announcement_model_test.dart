import 'package:campus_notify/models/app_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('announcement keeps its detail and read state when stored', () {
    const announcement = PengumumanModel(
      id: 'notice-1',
      judul: 'Perubahan jadwal',
      deskripsi: 'Kelas dimulai pukul 10.00.',
      isRead: true,
    );

    final restored = PengumumanModel.fromJson(announcement.toJson());

    expect(restored.id, announcement.id);
    expect(restored.judul, announcement.judul);
    expect(restored.deskripsi, announcement.deskripsi);
    expect(restored.isRead, isTrue);
  });

  test('copyWith can mark an announcement as read', () {
    const announcement = PengumumanModel(
      id: 'notice-2',
      judul: 'Rapat',
      deskripsi: 'Rapat dimulai pukul 13.00.',
    );

    final readAnnouncement = announcement.copyWith(isRead: true);

    expect(readAnnouncement.isRead, isTrue);
    expect(readAnnouncement.id, announcement.id);
    expect(readAnnouncement.deskripsi, announcement.deskripsi);
  });
}
