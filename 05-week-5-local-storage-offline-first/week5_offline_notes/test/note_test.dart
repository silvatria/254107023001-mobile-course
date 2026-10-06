import 'package:flutter_test/flutter_test.dart';

import 'package:week5_offline_notes/data/local/note.dart';

void main() {
  test('Note can round-trip through map serialization', () {
    final now = DateTime(2025, 1, 2, 3, 4, 5);
    final note = Note(
      id: 7,
      title: 'Judul',
      body: 'Isi catatan',
      updatedAt: now,
      dirty: true,
    );

    final map = note.toMap();
    final restored = Note.fromMap(map);

    expect(restored.id, 7);
    expect(restored.title, 'Judul');
    expect(restored.body, 'Isi catatan');
    expect(restored.updatedAt, now);
    expect(restored.dirty, isTrue);
  });
}
