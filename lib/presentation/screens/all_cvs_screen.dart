import 'package:android_cv_maker/data/models/cv_model.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  String _selectedFilter = 'all';
  String _currentSort = 'lastEditedDesc';

  List<CVModel> get _filteredCVs {
    final allCVs = CVModel.getSampleCVs();

    List<CVModel> filtered = allCVs.where((cv) {
      if (_selectedFilter == 'all') return true;
      if (_selectedFilter == 'draft') return cv.status == 'draft';
      if (_selectedFilter == 'completed') return cv.status == 'completed';
      return true;
    }).toList();

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (cv) => cv.title.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    filtered = _applySorting(filtered);
    return filtered;
  }

  List<CVModel> _applySorting(List<CVModel> cvs) {
    switch (_currentSort) {
      case 'lastEditedDesc':
        return [...cvs]..sort((a, b) => b.lastEdited.compareTo(a.lastEdited));
      case 'lastEditedAsc':
        return [...cvs]..sort((a, b) => a.lastEdited.compareTo(b.lastEdited));
      case 'titleAsc':
        return [...cvs]..sort((a, b) => a.title.compareTo(b.title));
      case 'titleDesc':
        return [...cvs]..sort((a, b) => b.title.compareTo(a.title));
      case 'progressDesc':
        return [...cvs]..sort((a, b) => b.progress.compareTo(a.progress));
      case 'progressAsc':
        return [...cvs]..sort((a, b) => a.progress.compareTo(b.progress));
      default:
        return cvs;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _dismissKeyboard() {
    if (_searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredCVs = _filteredCVs;
    final allCVs = CVModel.getSampleCVs();

    final draftCount = allCVs.where((cv) => cv.status == 'draft').length;
    final completedCount = allCVs
        .where((cv) => cv.status == 'completed')
        .length;

    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            _buildSearchBar(context),
            const SizedBox(height: 12),
            _buildFilterChips(context, draftCount, completedCount),
            const SizedBox(height: 16),
            Expanded(
              child: filteredCVs.isEmpty
                  ? _buildEmptyState(context)
                  : _buildCVList(context, filteredCVs),
            ),
          ],
        ),
        floatingActionButton: _buildCreateFAB(context),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
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
            _showSortBottomSheet(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _dismissKeyboard();
            _showMoreOptions(context);
          },
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
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
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search CVs...',
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[500]),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                        _searchController.clear();
                      });
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(
    BuildContext context,
    int draftCount,
    int completedCount,
  ) {
    final filters = [
      {'key': 'all', 'label': 'All', 'count': draftCount + completedCount},
      {'key': 'draft', 'label': 'Drafts', 'count': draftCount},
      {'key': 'completed', 'label': 'Completed', 'count': completedCount},
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
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter['key'] as String;
                });
              },
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

  Widget _buildCVList(BuildContext context, List<CVModel> cvs) {
    return ListView.builder(
      padding: const EdgeInsets.all(DesignSystem.paddingLarge),
      itemCount: cvs.length,
      itemBuilder: (context, index) {
        final cv = cvs[index];
        return _buildCVCard(context, cv);
      },
    );
  }

  Widget _buildCVCard(BuildContext context, CVModel cv) {
    final isDraft = cv.status == 'draft';
    final statusColor = isDraft ? Colors.orange : Colors.green;

    return AnimatedCard(
      onTap: () {
        _dismissKeyboard();
        _editCV(context, cv);
      },
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
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    size: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    _dismissKeyboard();
                    _editCV(context, cv);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.share, size: 20, color: Colors.grey[600]),
                  onPressed: () {
                    _dismissKeyboard();
                    _shareCV(context, cv);
                  },
                ),
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    size: 20,
                    color: Colors.grey[600],
                  ),
                  itemBuilder: (context) => [
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
                  onSelected: (value) => _handleMenuAction(context, value, cv),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    String message = _searchQuery.isNotEmpty
        ? 'No CVs match "$_searchQuery"'
        : _selectedFilter == 'draft'
        ? 'No drafts yet'
        : _selectedFilter == 'completed'
        ? 'No completed CVs yet'
        : 'No CVs created yet';

    return Center(
      child: Column(
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
            onPressed: () {
              _dismissKeyboard();
              _showCreateBottomSheet(context);
            },
            icon: const Icon(Icons.add),
            label: const Text('Create New CV'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  DesignSystem.radiusCircular,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        _dismissKeyboard();
        _showCreateBottomSheet(context);
      },
      child: const Icon(Icons.add),
      elevation: 0,
      tooltip: 'Create new CV',
    );
  }

  void _showCreateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignSystem.radiusXLarge),
        ),
      ),
      builder: (context) {
        return Container(
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
                  _createNewCV(context);
                },
              ),
              BottomSheetItem(
                icon: Icons.grid_view,
                title: 'Choose Template',
                subtitle: 'Browse all templates',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  _navigateToTemplates(context);
                },
              ),
              BottomSheetItem(
                icon: Icons.upload_file,
                title: 'Import CV',
                subtitle: 'Edit existing CV',
                color: Colors.orange,
                onTap: () {
                  Navigator.pop(context);
                  _importCV(context);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignSystem.radiusXLarge),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.7,
          expand: false,
          builder: (context, scrollController) {
            return Container(
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildSortOption(
                            context: context,
                            icon: Icons.access_time,
                            title: 'Last edited (Newest)',
                            value: 'lastEditedDesc',
                            currentSort: _currentSort,
                            onTap: () {
                              setState(() {
                                _currentSort = 'lastEditedDesc';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          _buildSortOption(
                            context: context,
                            icon: Icons.access_time,
                            title: 'Last edited (Oldest)',
                            value: 'lastEditedAsc',
                            currentSort: _currentSort,
                            onTap: () {
                              setState(() {
                                _currentSort = 'lastEditedAsc';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          const Divider(),
                          _buildSortOption(
                            context: context,
                            icon: Icons.title,
                            title: 'Title (A-Z)',
                            value: 'titleAsc',
                            currentSort: _currentSort,
                            onTap: () {
                              setState(() {
                                _currentSort = 'titleAsc';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          _buildSortOption(
                            context: context,
                            icon: Icons.title,
                            title: 'Title (Z-A)',
                            value: 'titleDesc',
                            currentSort: _currentSort,
                            onTap: () {
                              setState(() {
                                _currentSort = 'titleDesc';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          const Divider(),
                          _buildSortOption(
                            context: context,
                            icon: Icons.trending_up,
                            title: 'Progress (High to Low)',
                            value: 'progressDesc',
                            currentSort: _currentSort,
                            onTap: () {
                              setState(() {
                                _currentSort = 'progressDesc';
                              });
                              Navigator.pop(context);
                            },
                          ),
                          _buildSortOption(
                            context: context,
                            icon: Icons.trending_up,
                            title: 'Progress (Low to High)',
                            value: 'progressAsc',
                            currentSort: _currentSort,
                            onTap: () {
                              setState(() {
                                _currentSort = 'progressAsc';
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required String currentSort,
    required VoidCallback onTap,
  }) {
    final isSelected = currentSort == value;
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
      onTap: onTap,
    );
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignSystem.radiusXLarge),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(DesignSystem.paddingXLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.select_all),
                title: const Text('Select All'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(Icons.delete_sweep),
                title: const Text('Delete All Drafts'),
                textColor: Colors.red,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) return 'today';
    if (difference.inDays == 1) return 'yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    if (difference.inDays < 30)
      return '${(difference.inDays / 7).floor()} weeks ago';
    return '${(difference.inDays / 30).floor()} months ago';
  }

  void _createNewCV(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Create CV coming soon!')));
  }

  void _editCV(BuildContext context, CVModel cv) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit ${cv.title} coming soon!')));
  }

  void _shareCV(BuildContext context, CVModel cv) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Share ${cv.title} coming soon!')));
  }

  void _navigateToTemplates(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('All templates coming soon!')));
  }

  void _importCV(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Import CV coming soon!')));
  }

  void _handleMenuAction(BuildContext context, String action, CVModel cv) {
    switch (action) {
      case 'duplicate':
        _duplicateCV(context, cv);
        break;
      case 'delete':
        _deleteCV(context, cv);
        break;
    }
  }

  void _deleteCV(BuildContext context, CVModel cv) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete CV'),
        content: Text('Are you sure you want to delete "${cv.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        CVModel.deleteCV(cv.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${cv.title}" deleted successfully'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _duplicateCV(BuildContext context, CVModel cv) {
    setState(() {
      CVModel.duplicateCV(cv);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${cv.title}" duplicated successfully'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
