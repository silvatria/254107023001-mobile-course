import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementStorage {
  static const _storageKey = 'campus_notify.announcements';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Future<List<Map<String, dynamic>>?> readAll() async {
    final stored = await _preferences.getString(_storageKey);
    if (stored == null) return null;

    final decoded = jsonDecode(stored);
    if (decoded is! List) {
      throw const FormatException('Stored announcements must be a list.');
    }

    return decoded.map((entry) {
      if (entry is! Map) {
        throw const FormatException('Stored announcement must be an object.');
      }
      return Map<String, dynamic>.from(entry);
    }).toList();
  }

  Future<void> saveAll(List<Map<String, dynamic>> announcements) {
    return _preferences.setString(_storageKey, jsonEncode(announcements));
  }

  Future<void> upsert(Map<String, dynamic> announcement) async {
    final id = announcement['id'];
    if (id is! String || id.isEmpty) {
      throw ArgumentError.value(id, 'announcement.id', 'Must not be empty.');
    }

    final announcements = await readAll() ?? <Map<String, dynamic>>[];
    final existingIndex = announcements.indexWhere((item) => item['id'] == id);
    final existing = existingIndex == -1
        ? null
        : announcements.removeAt(existingIndex);
    announcements.insert(0, {
      ...announcement,
      'isRead': existing?['isRead'] == true,
    });
    await saveAll(announcements);
  }
}
