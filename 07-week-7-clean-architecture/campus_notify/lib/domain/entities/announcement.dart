class Announcement {
  const Announcement({
    required this.id,
    required this.title,
    required this.description,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String description;
  final bool isRead;

  Announcement copyWith({bool? isRead}) {
    return Announcement(
      id: id,
      title: title,
      description: description,
      isRead: isRead ?? this.isRead,
    );
  }
}
