import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'note_providers.dart';

class SyncSummary {
  const SyncSummary({
    required this.pendingSync,
  });

  final int pendingSync;
}

final syncSummaryProvider = FutureProvider.autoDispose<SyncSummary>((ref) async {
  final repository = ref.watch(noteRepositoryProvider);
  final pendingSync = await repository.countDirty();
  return SyncSummary(pendingSync: pendingSync);
});

Future<void> syncNotes(WidgetRef ref) async {
  final repository = ref.read(noteRepositoryProvider);
  await repository.markAllSynced();
  ref.invalidate(syncSummaryProvider);
}
