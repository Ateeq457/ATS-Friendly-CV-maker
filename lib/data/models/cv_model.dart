class CVModel {
  final String id;
  final String title;
  final String? previewImage;
  final String status;
  final double progress;
  final DateTime lastEdited;
  final String templateId;

  CVModel({
    required this.id,
    required this.title,
    this.previewImage,
    required this.status,
    required this.progress,
    required this.lastEdited,
    required this.templateId,
  });

  static List<CVModel> _sampleCVs = [
    CVModel(
      id: '1',
      title: 'Software Engineer CV',
      previewImage: null,
      status: 'draft',
      progress: 0.65,
      lastEdited: DateTime.now().subtract(const Duration(days: 2)),
      templateId: 'usa_classic',
    ),
    CVModel(
      id: '2',
      title: 'Product Manager CV',
      previewImage: null,
      status: 'draft',
      progress: 0.40,
      lastEdited: DateTime.now().subtract(const Duration(days: 5)),
      templateId: 'modern_executive',
    ),
    CVModel(
      id: '3',
      title: 'Frontend Developer CV',
      previewImage: null,
      status: 'completed',
      progress: 1.0,
      lastEdited: DateTime.now().subtract(const Duration(days: 10)),
      templateId: 'freshers_one_page',
    ),
  ];

  static List<CVModel> getSampleCVs() {
    // Professional sorting: first by date (newest), then by ID (newest ID = newer)
    return List<CVModel>.from(_sampleCVs)..sort((a, b) {
      // First compare by lastEdited date
      final dateCompare = b.lastEdited.compareTo(a.lastEdited);
      if (dateCompare != 0) return dateCompare;
      // If dates are equal, compare by ID (newer ID = larger number)
      return b.id.compareTo(a.id);
    });
  }

  static void deleteCV(String id) {
    _sampleCVs.removeWhere((cv) => cv.id == id);
  }

  static void duplicateCV(CVModel original) {
    final now = DateTime.now();
    final newId = _generateUniqueId(); // ✅ Unique ID with timestamp

    final newCV = CVModel(
      id: newId,
      title: _generateDuplicateTitle(original.title, _sampleCVs),
      previewImage: original.previewImage,
      status: original.status,
      progress: original.status == 'completed' ? 1.0 : original.progress,
      lastEdited: now,
      templateId: original.templateId,
    );
    _sampleCVs.add(newCV);
  }

  // ✅ Generate unique ID with timestamp + random
  static String _generateUniqueId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecondsSinceEpoch % 10000;
    return '$timestamp$random';
  }

  // ✅ Generate proper title with count (Copy 1, Copy 2, etc.)
  static String _generateDuplicateTitle(
    String originalTitle,
    List<CVModel> existingCVs,
  ) {
    // Find all duplicates of this CV
    final baseTitle = originalTitle.replaceAll(
      RegExp(r'\s*\(Copy\s*\d*\)$'),
      '',
    );
    final copies = existingCVs
        .where(
          (cv) => cv.title.startsWith(baseTitle) && cv.title.contains('(Copy'),
        )
        .toList();

    final copyCount = copies.length + 1;
    return '$baseTitle (Copy $copyCount)';
  }

  static void updateCV(CVModel updatedCV) {
    final index = _sampleCVs.indexWhere((cv) => cv.id == updatedCV.id);
    if (index != -1) {
      _sampleCVs[index] = updatedCV;
    }
  }
}
