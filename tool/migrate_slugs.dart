import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:entao_bora/firebase_options.dart';
import 'package:entao_bora/shared/helpers/slug_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

const _dryRun = bool.fromEnvironment('DRY_RUN', defaultValue: true);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final firestore = FirebaseFirestore.instance;
  final placesReport = await _analyzeCollection(
    firestore: firestore,
    collectionPath: 'places',
    label: 'PLACES',
    titleField: 'name',
  );
  final eventsReport = await _analyzeCollection(
    firestore: firestore,
    collectionPath: 'events',
    label: 'EVENTS',
    titleField: 'title',
  );

  _printReport(placesReport);
  _printReport(eventsReport);

  if (_dryRun) {
    debugPrint('DRY-RUN ativo: nenhum documento foi alterado.');
    return;
  }

  await _writeSafeSlugUpdates(firestore, placesReport);
  await _writeSafeSlugUpdates(firestore, eventsReport);

  debugPrint('Migracao concluida. Apenas o campo "slug" foi atualizado.');
}

Future<_CollectionSlugReport> _analyzeCollection({
  required FirebaseFirestore firestore,
  required String collectionPath,
  required String label,
  required String titleField,
}) async {
  final snapshot = await firestore.collection(collectionPath).get();
  final docs = <_SlugDocument>[];

  for (final doc in snapshot.docs) {
    final data = doc.data();
    final title = data[titleField]?.toString().trim() ?? '';
    final existingSlug = data['slug']?.toString().trim() ?? '';
    final generatedSlug = existingSlug.isNotEmpty
        ? existingSlug
        : SlugHelper.fromTitle(title);

    docs.add(
      _SlugDocument(
        id: doc.id,
        title: title,
        currentSlug: existingSlug,
        targetSlug: generatedSlug,
      ),
    );
  }

  final docsBySlug = <String, List<_SlugDocument>>{};

  for (final doc in docs) {
    if (doc.targetSlug.isEmpty) continue;

    docsBySlug.putIfAbsent(doc.targetSlug, () => []).add(doc);
  }

  final conflictSlugs = docsBySlug.entries
      .where((entry) => entry.value.length > 1)
      .map((entry) => entry.key)
      .toSet();

  final emptyGeneratedSlugDocs = docs
      .where((doc) => doc.currentSlug.isEmpty && doc.targetSlug.isEmpty)
      .toList();

  final safeUpdates = docs
      .where(
        (doc) =>
            doc.currentSlug.isEmpty &&
            doc.targetSlug.isNotEmpty &&
            !conflictSlugs.contains(doc.targetSlug),
      )
      .toList();

  return _CollectionSlugReport(
    label: label,
    collectionPath: collectionPath,
    total: docs.length,
    alreadyHadSlug: docs.where((doc) => doc.currentSlug.isNotEmpty).length,
    safeUpdates: safeUpdates,
    conflicts: {for (final slug in conflictSlugs) slug: docsBySlug[slug]!},
    emptyGeneratedSlugDocs: emptyGeneratedSlugDocs,
  );
}

Future<void> _writeSafeSlugUpdates(
  FirebaseFirestore firestore,
  _CollectionSlugReport report,
) async {
  const maxBatchSize = 450;
  var batch = firestore.batch();
  var pendingWrites = 0;

  for (final doc in report.safeUpdates) {
    final ref = firestore.collection(report.collectionPath).doc(doc.id);
    batch.update(ref, {'slug': doc.targetSlug});
    pendingWrites++;

    if (pendingWrites == maxBatchSize) {
      await batch.commit();
      batch = firestore.batch();
      pendingWrites = 0;
    }
  }

  if (pendingWrites > 0) {
    await batch.commit();
  }
}

void _printReport(_CollectionSlugReport report) {
  debugPrint('');
  debugPrint(report.label);
  debugPrint('');
  debugPrint('Total encontrados: ${report.total}');
  debugPrint('Ja possuiam slug: ${report.alreadyHadSlug}');
  debugPrint('Slugs criados: ${report.safeUpdates.length}');
  debugPrint('Conflitos encontrados: ${report.conflicts.length}');

  if (report.conflicts.isNotEmpty) {
    debugPrint('');
    debugPrint('Conflitos:');

    for (final entry in report.conflicts.entries) {
      debugPrint('- ${entry.key}');

      for (final doc in entry.value) {
        debugPrint('  - ID: ${doc.id}');
        debugPrint('    name/title: ${doc.title}');
        debugPrint('    slug atual: ${doc.currentSlug}');
      }
    }
  }

  if (report.emptyGeneratedSlugDocs.isNotEmpty) {
    debugPrint('');
    debugPrint('Sem slug geravel:');

    for (final doc in report.emptyGeneratedSlugDocs) {
      debugPrint('- ID: ${doc.id}');
      debugPrint('  name/title: ${doc.title}');
    }
  }
}

class _CollectionSlugReport {
  const _CollectionSlugReport({
    required this.label,
    required this.collectionPath,
    required this.total,
    required this.alreadyHadSlug,
    required this.safeUpdates,
    required this.conflicts,
    required this.emptyGeneratedSlugDocs,
  });

  final String label;
  final String collectionPath;
  final int total;
  final int alreadyHadSlug;
  final List<_SlugDocument> safeUpdates;
  final Map<String, List<_SlugDocument>> conflicts;
  final List<_SlugDocument> emptyGeneratedSlugDocs;
}

class _SlugDocument {
  const _SlugDocument({
    required this.id,
    required this.title,
    required this.currentSlug,
    required this.targetSlug,
  });

  final String id;
  final String title;
  final String currentSlug;
  final String targetSlug;
}
