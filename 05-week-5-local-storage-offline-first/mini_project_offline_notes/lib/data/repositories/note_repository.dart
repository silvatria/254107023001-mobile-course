import 'package:sqflite/sqflite.dart';

import '../local/db.dart';
import '../local/note.dart';

abstract interface class NoteRepository {
  Future<List<Note>> fetchNotes();
  Future<Note?> getNoteById(int id);
  Future<Note> addNote({required String title, String body = ''});
  Future<void> updateNote(Note note);
  Future<void> deleteNote(int id);
  Future<int> countDirty();
  Future<void> markAllSynced();
}

class SqfliteNoteRepository implements NoteRepository {
  SqfliteNoteRepository({Future<Database> Function()? openDb})
    : _openDb = openDb ?? openNotesDb;

  final Future<Database> Function() _openDb;

  @override
  Future<List<Note>> fetchNotes() async {
    final db = await _openDb();
    final rows = await db.query('notes', orderBy: 'updated_at DESC, id DESC');
    return rows.map(Note.fromMap).toList();
  }

  @override
  Future<Note?> getNoteById(int id) async {
    final db = await _openDb();
    final rows = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return rows.isEmpty ? null : Note.fromMap(rows.first);
  }

  @override
  Future<Note> addNote({required String title, String body = ''}) async {
    final db = await _openDb();
    final note = Note(
      title: title,
      body: body,
      updatedAt: DateTime.now().toUtc(),
      dirty: true,
    );
    final id = await db.insert('notes', note.toMap());
    return note.copyWith(id: id);
  }

  @override
  Future<void> updateNote(Note note) async {
    if (note.id == null) {
      throw ArgumentError('Catatan belum memiliki id');
    }
    final db = await _openDb();
    final updated = note.copyWith(
      updatedAt: DateTime.now().toUtc(),
      dirty: true,
    );
    await db.update(
      'notes',
      updated.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  @override
  Future<void> deleteNote(int id) async {
    final db = await _openDb();
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<int> countDirty() async {
    final db = await _openDb();
    final rows = await db.rawQuery(
      'SELECT COUNT(*) AS c FROM notes WHERE dirty = 1',
    );
    return (rows.first['c'] as num?)?.toInt() ?? 0;
  }

  @override
  Future<void> markAllSynced() async {
    final db = await _openDb();
    await db.update('notes', {'dirty': 0}, where: 'dirty = 1');
  }
}
