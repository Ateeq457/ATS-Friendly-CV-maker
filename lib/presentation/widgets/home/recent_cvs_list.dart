import 'package:flutter/material.dart';
import '../../../core/constants/design_system.dart';
import '../../../data/models/cv_model.dart';
import '../../widgets/shared/animated_card.dart';

class RecentCVsList extends StatelessWidget {
  final List<CVModel> recentCVs;
  final Function(CVModel) onCVTap;
  final Function(CVModel) onEdit;
  final Function(CVModel) onDelete;

  const RecentCVsList({
    super.key,
    required this.recentCVs,
    required this.onCVTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Sort CVs by lastEdited date (newest first)
    final sortedCVs = List<CVModel>.from(recentCVs)
      ..sort((a, b) => b.lastEdited.compareTo(a.lastEdited));

    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: sortedCVs.length,
        itemBuilder: (context, index) {
          final cv = sortedCVs[index];
          return AnimatedCard(
            onTap: () => onCVTap(cv),
            child: Container(
              width: 280,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(DesignSystem.paddingMedium),
              decoration: DesignSystem.cardDecoration(context),
              child: Row(
                children: [
                  // ========== CV PREVIEW THUMBNAIL ==========
                  Container(
                    width: 60,
                    height: 75,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _getStatusColor(cv.status).withOpacity(0.2),
                          _getStatusColor(cv.status).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(
                        DesignSystem.radiusMedium,
                      ),
                      border: Border.all(
                        color: _getStatusColor(cv.status).withOpacity(0.3),
                        width: 1,
                      ),
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
                              color: _getStatusColor(cv.status),
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
                            color: _getStatusColor(cv.status).withOpacity(0.5),
                          ),
                        ),
                        Positioned(
                          top: 22,
                          left: 8,
                          right: 8,
                          child: Container(
                            height: 3,
                            color: _getStatusColor(cv.status).withOpacity(0.3),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Icon(
                            Icons.description,
                            size: 16,
                            color: _getStatusColor(cv.status),
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
                              color: _getStatusColor(cv.status),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              cv.status == 'draft' ? 'Draft' : 'Done',
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
                  const SizedBox(width: 12),
                  // ========== CV DETAILS ==========
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          cv.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 10,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(cv.lastEdited),
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        if (cv.status == 'draft') ...[
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: cv.progress,
                            backgroundColor: Colors.grey[200],
                            color: _getStatusColor(cv.status),
                            borderRadius: BorderRadius.circular(4),
                            minHeight: 3,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${(cv.progress * 100).toInt()}% complete',
                            style: TextStyle(
                              fontSize: 8,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // ========== THREE DOTS MENU ==========
                  // ========== THREE DOTS MENU ==========
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit(cv);
                          break;
                        case 'delete':
                          onDelete(cv); // ✅ Direct call, no dialog here
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 12),
                            Text('Edit'),
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
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, CVModel cv) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete CV'),
        content: Text('Are you sure you want to delete "${cv.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog first
              onDelete(cv); // Then call delete
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'draft':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else {
      return '${(difference.inDays / 30).floor()} months ago';
    }
  }
}
