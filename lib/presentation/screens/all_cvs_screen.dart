// File: lib/presentation/screens/all_cvs_screen.dart

import 'package:android_cv_maker/data/local/cv_storage.dart';
import 'package:android_cv_maker/data/models/cv_data.dart';
import 'package:android_cv_maker/presentation/screens/create_cv_screen.dart';
import 'package:flutter/material.dart';
import '../../core/constants/design_system.dart';
import '../widgets/shared/animated_card.dart';
import '../widgets/shared/bottom_sheet_item.dart';

class AllCVsScreen extends StatefulWidget {
  const AllCVsScreen({super.key});

  @override
  State<AllCVsScreen> createState() => _AllCVsScreenState();
}

class _AllCVsScreenState extends State<AllCVsScreen> {
  final CVStorage _storage = CVStorage();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<CVModel> _allCVs = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _selectedFilter = 'all';
  String _currentSort = 'lastEditedDesc';

  // ─── Computed ────────────────────────────────

  List<CVModel> get _filteredCVs {
    List<CVModel> result = _allCVs.where((cv) {
      if (_selectedFilter == 'draft') return cv.status == 'draft';
      if (_selectedFilter == 'completed') return cv.status == 'completed';
      return true;
    }).toList();

    if (_searchQuery.isNotEmpty) {
      result = result
          .where(
            (cv) => cv.title.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    return _applySorting(result);
  }

  int get _draftCount => _allCVs.where((cv) => cv.status == 'draft').length;
  int get _completedCount =>
      _allCVs.where((cv) => cv.status == 'completed').length;

  List<CVModel> _applySorting(List<CVModel> cvs) {
    final sorted = [...cvs];
    switch (_currentSort) {
      case 'lastEditedDesc':
        sorted.sort((a, b) => b.lastEdited.compareTo(a.lastEdited));
      case 'lastEditedAsc':
        sorted.sort((a, b) => a.lastEdited.compareTo(b.lastEdited));
      case 'titleAsc':
        sorted.sort((a, b) => a.title.compareTo(b.title));
      case 'titleDesc':
        sorted.sort((a, b) => b.title.compareTo(a.title));
      case 'progressDesc':
        sorted.sort((a, b) => b.progress.compareTo(a.progress));
      case 'progressAsc':
        sorted.sort((a, b) => a.progress.compareTo(b.progress));
    }
    return sorted;
  }

  // ─── Lifecycle ───────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadCVs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  // ─── Data ────────────────────────────────────

  Future<void> _loadCVs() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // ✅ CVStorage.getAllCVs() — correct key filter
      final cvs = await _storage.getAllCVs();
      if (mounted)
        setState(() {
          _allCVs = cvs;
          _isLoading = false;
        });
      debugPrint('✅ AllCVsScreen: Loaded ${cvs.length} CVs');
    } catch (e) {
      debugPrint('❌ AllCVsScreen _loadCVs error: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ─── Actions ─────────────────────────────────

  Future<void> _editCV(CVModel cv) async {
    _dismissKeyboard();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CreateCVScreen(initialCVId: cv.id)),
    );
    if (mounted) _loadCVs(); // ✅ Reload after edit
  }

  Future<void> _createNewCV() async {
    _dismissKeyboard();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CreateCVScreen()),
    );
    if (mounted) _loadCVs(); // ✅ Reload after create
  }

  Future<void> _deleteCV(CVModel cv) async {
    _dismissKeyboard();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete CV'),
        content: Text('Delete "${cv.title}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    // ✅ Optimistic UI update
    setState(() => _allCVs.removeWhere((c) => c.id == cv.id));

    try {
      // ✅ CVStorage.deleteCV — removes BOTH cv_${id} AND cv_data_${id}
      await _storage.deleteCV(cv.id);
      _showSnackBar('"${cv.title}" deleted', color: Colors.red.shade400);
    } catch (e) {
      debugPrint('❌ Delete error: $e');
      _loadCVs(); // Rollback
      _showSnackBar('Failed to delete.', color: Colors.red);
    }
  }

  Future<void> _duplicateCV(CVModel cv) async {
    try {
      // Load original CVData
      final originalData = await _storage.loadCVData(cv.id);
      if (originalData == null) {
        _showSnackBar(
          'Could not duplicate: Original CV not found',
          color: Colors.red,
        );
        return;
      }

      // ✅ Generate smart duplicate name
      final String newTitle = _generateDuplicateTitle(cv.title, _allCVs);
      final String newId = DateTime.now().millisecondsSinceEpoch.toString();

      debugPrint('📝 Duplicating: "${cv.title}" → "$newTitle"');

      // Create new CVModel
      final newCV = CVModel(
        id: newId,
        title: newTitle,
        status: 'draft',
        progress: cv.progress,
        lastEdited: DateTime.now(),
        data: originalData.toJson(),
      );

      // Create new CVData (copy of original)
      final newCVData = CVData(
        fullName: originalData.fullName,
        title: originalData.title,
        email: originalData.email,
        phone: originalData.phone,
        location: originalData.location,
        linkedin: originalData.linkedin,
        github: originalData.github,
        summary: originalData.summary,
        photoBytes: originalData.photoBytes,
        experiences: List.from(originalData.experiences),
        educations: List.from(originalData.educations),
        skills: List.from(originalData.skills),
        projects: List.from(originalData.projects),
        certifications: List.from(originalData.certifications),
        languages: List.from(originalData.languages),
        socialLinks: List.from(originalData.socialLinks),
        customSections: List.from(originalData.customSections),
      );

      // Save to storage
      await _storage.saveCV(newCV);
      await _storage.saveCVData(newCVData, newId);

      // Update UI
      if (mounted) {
        setState(() {
          _allCVs.insert(0, newCV);
        });
        _showSnackBar('Duplicated as "$newTitle"', color: Colors.green);
        await _loadCVs();
      }
    } catch (e) {
      debugPrint('❌ Duplicate error: $e');
      _showSnackBar('Failed to duplicate CV.', color: Colors.red);
      await _loadCVs();
    }
  }

  /// ✅ Smart duplicate name generator - Simple & Reliable
  String _generateDuplicateTitle(
    String originalTitle,
    List<CVModel> existingCVs,
  ) {
    final base = _cleanBaseTitle(originalTitle);

    int maxIndex = 0;

    for (final cv in existingCVs) {
      final title = cv.title;

      if (title == base) {
        maxIndex = maxIndex < 1 ? 1 : maxIndex;
      }

      final regex = RegExp(
        r'^' + RegExp.escape(base) + r' \(Copy(?: (\d+))?\)$',
      );

      final match = regex.firstMatch(title);
      if (match != null) {
        if (match.group(1) != null) {
          final num = int.tryParse(match.group(1)!);
          if (num != null && num > maxIndex) {
            maxIndex = num;
          }
        } else {
          maxIndex = maxIndex < 1 ? 1 : maxIndex;
        }
      }
    }

    if (maxIndex == 0) return '$base (Copy)';
    return '$base (Copy ${maxIndex + 1})';
  }

  String _cleanBaseTitle(String title) {
    return title.replaceAll(RegExp(r' \(Copy(?: \d+)?\)$'), '').trim();
  }

  // ─── Helpers ─────────────────────────────────

  void _dismissKeyboard() {
    if (_searchFocusNode.hasFocus) _searchFocusNode.unfocus();
  }

  void _showSnackBar(
    String message, {
    Color? color,
    Duration duration = const Duration(seconds: 2),
  }) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: duration,
        ),
      );
  }

  void _handleMenuAction(String action, CVModel cv) {
    switch (action) {
      case 'duplicate':
        _duplicateCV(cv);
        break;
      case 'delete':
        _deleteCV(cv);
        break;
    }
  }

  // ─── Build ───────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 12),
                  // ✅ Real counts from _allCVs, not sample data
                  _buildFilterChips(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _loadCVs,
                      child: _filteredCVs.isEmpty
                          ? _buildEmptyState()
                          : _buildCVList(),
                    ),
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _dismissKeyboard();
            _showCreateBottomSheet();
          },
          elevation: 0,
          tooltip: 'Create new CV',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'My CVs',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () {
            _dismissKeyboard();
            _showSortBottomSheet();
          },
        ),
        IconButton(icon: const Icon(Icons.refresh), onPressed: _loadCVs),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.paddingLarge,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(DesignSystem.radiusXLarge),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          textInputAction: TextInputAction.done,
          onEditingComplete: _dismissKeyboard,
          onChanged: (value) => setState(() => _searchQuery = value),
          decoration: InputDecoration(
            hintText: 'Search CVs...',
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[500]),
                    onPressed: () => setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                    }),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    // ✅ Real counts from actual data
    final filters = [
      {'key': 'all', 'label': 'All', 'count': _allCVs.length},
      {'key': 'draft', 'label': 'Drafts', 'count': _draftCount},
      {'key': 'completed', 'label': 'Completed', 'count': _completedCount},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.paddingLarge,
      ),
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter['key'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(filter['label'] as String),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.white.withOpacity(0.2)
                          : Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${filter['count']}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                    ),
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (_) =>
                  setState(() => _selectedFilter = filter['key'] as String),
              backgroundColor: Colors.grey.withOpacity(0.08),
              selectedColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              shape: StadiumBorder(
                side: isSelected
                    ? BorderSide.none
                    : BorderSide(color: Colors.grey.withOpacity(0.3)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCVList() {
    return ListView.builder(
      padding: const EdgeInsets.all(DesignSystem.paddingLarge),
      itemCount: _filteredCVs.length,
      itemBuilder: (context, index) => _buildCVCard(_filteredCVs[index]),
    );
  }

  Widget _buildCVCard(CVModel cv) {
    final isDraft = cv.status == 'draft';
    final statusColor = isDraft ? Colors.orange : Colors.green;

    return AnimatedCard(
      onTap: () => _editCV(cv),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(DesignSystem.paddingMedium),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
          border: Border.all(color: statusColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            // CV thumbnail icon
            Container(
              width: 60,
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    statusColor.withOpacity(0.2),
                    statusColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 8,
                    left: 8,
                    right: 8,
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 8,
                    right: 8,
                    child: Container(
                      height: 3,
                      color: statusColor.withOpacity(0.5),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Icon(
                      Icons.description,
                      size: 16,
                      color: statusColor,
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        isDraft ? 'Draft' : 'Done',
                        style: const TextStyle(
                          fontSize: 7,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Title + meta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cv.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(cv.lastEdited),
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                  if (isDraft) ...[
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: cv.progress,
                      backgroundColor: Colors.grey[200],
                      color: statusColor,
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 3,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(cv.progress * 100).toInt()}% complete',
                      style: TextStyle(fontSize: 9, color: Colors.grey[500]),
                    ),
                  ],
                ],
              ),
            ),

            // ✅ Actions — Edit + Menu (NO share button)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => _editCV(cv),
                  tooltip: 'Edit',
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onSelected: (value) => _handleMenuAction(value, cv),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'duplicate',
                      child: Row(
                        children: [
                          Icon(Icons.copy, size: 18),
                          SizedBox(width: 12),
                          Text('Duplicate'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 12),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final message = _searchQuery.isNotEmpty
        ? 'No CVs match "$_searchQuery"'
        : _selectedFilter == 'draft'
        ? 'No drafts yet'
        : _selectedFilter == 'completed'
        ? 'No completed CVs yet'
        : 'No CVs created yet';

    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _createNewCV,
              icon: const Icon(Icons.add),
              label: const Text('Create New CV'),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Bottom Sheets ───────────────────────────

  void _showCreateBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignSystem.radiusXLarge),
        ),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(DesignSystem.paddingXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            BottomSheetItem(
              icon: Icons.add,
              title: 'Create New CV',
              subtitle: 'Start from scratch',
              color: Theme.of(context).primaryColor,
              onTap: () {
                Navigator.pop(context);
                _createNewCV();
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignSystem.radiusXLarge),
        ),
      ),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.7,
        expand: false,
        builder: (_, scrollController) => Container(
          padding: const EdgeInsets.all(DesignSystem.paddingXLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Sort by',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      _sortOption(
                        'lastEditedDesc',
                        Icons.access_time,
                        'Last edited (Newest)',
                      ),
                      _sortOption(
                        'lastEditedAsc',
                        Icons.access_time,
                        'Last edited (Oldest)',
                      ),
                      const Divider(),
                      _sortOption('titleAsc', Icons.title, 'Title (A-Z)'),
                      _sortOption('titleDesc', Icons.title, 'Title (Z-A)'),
                      const Divider(),
                      _sortOption(
                        'progressDesc',
                        Icons.trending_up,
                        'Progress (High to Low)',
                      ),
                      _sortOption(
                        'progressAsc',
                        Icons.trending_up,
                        'Progress (Low to High)',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sortOption(String value, IconData icon, String title) {
    final isSelected = _currentSort == value;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : null,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).primaryColor)
          : null,
      onTap: () {
        setState(() => _currentSort = value);
        Navigator.pop(context);
      },
    );
  }

  // ─── Utils ───────────────────────────────────

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return '${(diff.inDays / 30).floor()}mo ago';
  }
}
