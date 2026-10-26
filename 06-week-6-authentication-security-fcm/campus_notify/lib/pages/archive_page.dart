import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/app_model.dart';

class ArchivePage extends ConsumerWidget {
  const ArchivePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final announcements = ref.watch(pengumumanProvider);
    final readAnnouncements = announcements
        .where((announcement) => announcement.isRead)
        .toList();
    final loadState = ref.watch(pengumumanReadyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Arsip Pengumuman')),
      body: loadState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : loadState.hasError
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Gagal memuat arsip: ${loadState.error}'),
              ),
            )
          : readAnnouncements.isEmpty
          ? const Center(child: Text('Belum ada pengumuman di arsip.'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: readAnnouncements.length,
              itemBuilder: (context, index) {
                final announcement = readAnnouncements[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.drafts_outlined,
                      color: Colors.grey,
                    ),
                    title: Text(announcement.judul),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      context.push(
                        '/pengumuman/${Uri.encodeComponent(announcement.id)}',
                        extra: announcement,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
