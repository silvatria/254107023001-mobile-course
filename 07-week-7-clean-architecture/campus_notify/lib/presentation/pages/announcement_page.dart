import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/announcement.dart';
import '../providers/app_providers.dart';

class AnnouncementPage extends ConsumerStatefulWidget {
  const AnnouncementPage({super.key, required this.id, this.announcement});

  final String id;
  final Announcement? announcement;

  @override
  ConsumerState<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends ConsumerState<AnnouncementPage> {
  late final Future<Announcement?> _announcementFuture;

  @override
  void initState() {
    super.initState();
    _announcementFuture = _loadAnnouncement();
  }

  Future<Announcement?> _loadAnnouncement() async {
    final notifier = ref.read(pengumumanProvider.notifier);
    final announcement =
        widget.announcement ?? await notifier.findById(widget.id);

    if (announcement != null) {
      await notifier.markAsRead(announcement.id);
    }

    return announcement;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pengumuman')),
      body: FutureBuilder<Announcement?>(
        future: _announcementFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Gagal memuat detail pengumuman: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          final announcement = snapshot.data;
          if (announcement == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Pengumuman tidak ditemukan. Pastikan pesan FCM menyertakan '
                  'ID, judul, dan deskripsi pengumuman.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Chip(label: Text('ID Pengumuman: ${announcement.id}')),
                const Divider(height: 24),
                Text(
                  announcement.description,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
