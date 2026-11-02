import '../../domain/entities/announcement.dart';

class AnnouncementDataModel {
  const AnnouncementDataModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isRead,
  });

  final String id;
  final String title;
  final String description;
  final bool isRead;

  factory AnnouncementDataModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementDataModel(
      id: json['id'] as String,
      title: json['judul'] as String,
      description: json['deskripsi'] as String,
      isRead: json['isRead'] as bool? ?? false,
    );
  }

  factory AnnouncementDataModel.fromEntity(Announcement announcement) {
    return AnnouncementDataModel(
      id: announcement.id,
      title: announcement.title,
      description: announcement.description,
      isRead: announcement.isRead,
    );
  }

  Announcement toEntity() => Announcement(
    id: id,
    title: title,
    description: description,
    isRead: isRead,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'judul': title,
    'deskripsi': description,
    'isRead': isRead,
  };
}
