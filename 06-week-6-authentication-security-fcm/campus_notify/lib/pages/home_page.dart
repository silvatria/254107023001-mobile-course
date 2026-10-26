import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/app_model.dart'; // Sesuaikan path import model lu

Future<String?> _loadFcmToken() async {
  // ignore: deprecated_member_use
  return FirebaseMessaging.instance.getToken();
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(context, ref) {
    final currentUser = ref.watch(authProvider);
    final allPengumuman = ref.watch(pengumumanProvider);
    final unreadPengumuman = allPengumuman
        .where((announcement) => !announcement.isRead)
        .toList();
    final unreadCount = ref.watch(unreadCountProvider);
    final announcementsLoad = ref.watch(pengumumanReadyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengumuman'),
        actions: [
          IconButton(
            tooltip: 'Arsip pengumuman',
            icon: const Icon(Icons.archive_outlined),
            onPressed: () => context.push('/arsip'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.notifications, size: 28),
                if (unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authProvider.notifier).state = null;
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (currentUser != null) ...[
              Card(
                color: Colors.deepPurple.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nama: ${currentUser.nama}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text('NIM: ${currentUser.nim}'),
                      Text('Email: ${currentUser.email}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'FCM Token (Debug View):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            FutureBuilder<String?>(
              future: _loadFcmToken(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();
                final fullToken = snapshot.data ?? '';
                final maskedToken = fullToken.length > 12
                    ? '${fullToken.substring(0, 12)}...'
                    : fullToken;
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    maskedToken,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      color: Colors.blueAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 12, right: 8),
                    child: Text(
                      'Pengumuman Belum Dibaca:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Chip(
                  avatar: const Icon(Icons.mark_email_unread, size: 16),
                  label: Text('$unreadCount'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (announcementsLoad.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (announcementsLoad.hasError)
              Text('Gagal memuat pengumuman: ${announcementsLoad.error}')
            else if (unreadPengumuman.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Center(
                  child: Text(
                    'Tidak ada pengumuman baru.',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...unreadPengumuman.map(
                (item) => Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.mark_email_unread_outlined,
                      color: Colors.deepPurple,
                    ),
                    title: Text(item.judul),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () async {
                      await ref
                          .read(pengumumanProvider.notifier)
                          .markAsRead(item.id);
                      if (context.mounted) {
                        context.push(
                          '/pengumuman/${Uri.encodeComponent(item.id)}',
                          extra: item,
                        );
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
