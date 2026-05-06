// // File: lib/presentation/screens/my_cvs_screen.dart

// import 'package:android_cv_maker/data/models/cv_data.dart';
// import 'package:android_cv_maker/data/local/cv_storage.dart';
// import 'package:android_cv_maker/presentation/screens/create_cv_screen.dart';
// import 'package:flutter/material.dart';

// class MyCVsScreen extends StatefulWidget {
//   const MyCVsScreen({super.key});

//   @override
//   State<MyCVsScreen> createState() => _MyCVsScreenState();
// }

// class _MyCVsScreenState extends State<MyCVsScreen> {
//   final CVStorage _storage = CVStorage();

//   List<CVModel> _allCVs = [];
//   bool _isLoading = true;
//   String? _errorMessage;

//   // ─── Lifecycle ───────────────────────────────

//   @override
//   void initState() {
//     super.initState();
//     _loadCVs();
//   }

//   // ─── Data ────────────────────────────────────

//   Future<void> _loadCVs() async {
//     if (!mounted) return;
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       final cvs = await _storage.getAllCVs();
//       if (mounted)
//         setState(() {
//           _allCVs = cvs;
//           _isLoading = false;
//         });
//     } catch (e) {
//       debugPrint('❌ _loadCVs error: $e');
//       if (mounted)
//         setState(() {
//           _isLoading = false;
//           _errorMessage = 'Failed to load CVs.';
//         });
//     }
//   }

//   // ─── Actions ─────────────────────────────────

//   Future<void> _editCV(CVModel cv) async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => CreateCVScreen(initialCVId: cv.id)),
//     );
//     // ✅ Single reload after return — no duplicate
//     if (mounted) _loadCVs();
//   }

//   Future<void> _createNewCV() async {
//     await Navigator.push(
//       context,
//       MaterialPageRoute(builder: (_) => const CreateCVScreen()),
//     );
//     if (mounted) _loadCVs();
//   }

//   Future<void> _deleteCV(CVModel cv) async {
//     final confirm = await showDialog<bool>(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Delete CV'),
//         content: Text('Delete "${cv.title}"? This cannot be undone.'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(ctx, true),
//             style: TextButton.styleFrom(foregroundColor: Colors.red),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//     if (confirm != true) return;

//     // Optimistic remove
//     setState(() => _allCVs.removeWhere((c) => c.id == cv.id));

//     try {
//       await _storage.deleteCV(cv.id);
//       _showSnackBar('"${cv.title}" deleted', color: Colors.red.shade400);
//     } catch (e) {
//       debugPrint('❌ Delete error: $e');
//       _loadCVs(); // Rollback
//       _showSnackBar('Failed to delete.', color: Colors.red);
//     }
//   }

//   Future<void> _duplicateCV(CVModel cv) async {
//     try {
//       final newId = 'dup_${DateTime.now().millisecondsSinceEpoch}';
//       final newCV = cv.copyWith(
//         id: newId,
//         title: '${cv.title} (Copy)',
//         status: 'draft',
//         lastEdited: DateTime.now(),
//       );

//       await _storage.saveCV(newCV);

//       // Copy CVData too
//       final originalData = await _storage.loadCVData(cv.id);
//       if (originalData != null) await _storage.saveCVData(originalData, newId);

//       if (mounted) {
//         setState(() => _allCVs.insert(0, newCV));
//         _showSnackBar('"${cv.title}" duplicated', color: Colors.blue);
//       }
//     } catch (e) {
//       debugPrint('❌ Duplicate error: $e');
//       _showSnackBar('Failed to duplicate.', color: Colors.red);
//     }
//   }

//   // ─── Helpers ─────────────────────────────────

//   void _showSnackBar(String message, {Color? color}) {
//     if (!mounted) return;
//     ScaffoldMessenger.of(context)
//       ..hideCurrentSnackBar()
//       ..showSnackBar(
//         SnackBar(
//           content: Text(message),
//           backgroundColor: color,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//       );
//   }

//   // ─── Build ───────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         title: const Text('My CVs'),
//         centerTitle: false,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             tooltip: 'Refresh',
//             onPressed: _loadCVs,
//           ),
//         ],
//       ),
//       body: _buildBody(),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _createNewCV,
//         icon: const Icon(Icons.add),
//         label: const Text('New CV'),
//       ),
//     );
//   }

//   Widget _buildBody() {
//     if (_isLoading) return const Center(child: CircularProgressIndicator());
//     if (_errorMessage != null) return _buildErrorState();
//     if (_allCVs.isEmpty) return _buildEmptyState();

//     return RefreshIndicator(
//       onRefresh: _loadCVs,
//       child: ListView.builder(
//         padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
//         itemCount: _allCVs.length,
//         itemBuilder: (context, index) => _CVCard(
//           cv: _allCVs[index],
//           onEdit: () => _editCV(_allCVs[index]),
//           onDuplicate: () => _duplicateCV(_allCVs[index]),
//           onDelete: () => _deleteCV(_allCVs[index]),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.description_outlined, size: 72, color: Colors.grey[350]),
//           const SizedBox(height: 20),
//           Text(
//             'No CVs yet',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Tap below to create your first CV',
//             style: TextStyle(fontSize: 14, color: Colors.grey[500]),
//           ),
//           const SizedBox(height: 32),
//           ElevatedButton.icon(
//             onPressed: _createNewCV,
//             icon: const Icon(Icons.add),
//             label: const Text('Create New CV'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildErrorState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.error_outline, size: 64, color: Colors.red),
//           const SizedBox(height: 16),
//           Text(_errorMessage!, textAlign: TextAlign.center),
//           const SizedBox(height: 24),
//           ElevatedButton(onPressed: _loadCVs, child: const Text('Retry')),
//         ],
//       ),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// // CV Card
// // ─────────────────────────────────────────────

// class _CVCard extends StatelessWidget {
//   const _CVCard({
//     required this.cv,
//     required this.onEdit,
//     required this.onDuplicate,
//     required this.onDelete,
//   });

//   final CVModel cv;
//   final VoidCallback onEdit;
//   final VoidCallback onDuplicate;
//   final VoidCallback onDelete;

//   @override
//   Widget build(BuildContext context) {
//     final isDraft = cv.status == 'draft';
//     final statusColor = isDraft ? Colors.orange : Colors.green;

//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 1,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: InkWell(
//         onTap: onEdit,
//         borderRadius: BorderRadius.circular(12),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
//           child: Row(
//             children: [
//               // Icon
//               Container(
//                 width: 44,
//                 height: 44,
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.12),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(Icons.description_rounded, color: statusColor),
//               ),
//               const SizedBox(width: 12),

//               // Title + meta
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       cv.title,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: 15,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         // Status badge
//                         Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 6,
//                             vertical: 2,
//                           ),
//                           decoration: BoxDecoration(
//                             color: statusColor.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(4),
//                           ),
//                           child: Text(
//                             isDraft ? 'Draft' : 'Completed',
//                             style: TextStyle(
//                               fontSize: 11,
//                               fontWeight: FontWeight.w500,
//                               color: statusColor,
//                             ),
//                           ),
//                         ),
//                         if (isDraft) ...[
//                           const SizedBox(width: 6),
//                           Text(
//                             '${(cv.progress * 100).toInt()}%',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[500],
//                             ),
//                           ),
//                         ],
//                         const SizedBox(width: 6),
//                         Flexible(
//                           child: Text(
//                             _formatDate(cv.lastEdited),
//                             style: TextStyle(
//                               fontSize: 11,
//                               color: Colors.grey[400],
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     // Progress bar
//                     if (isDraft) ...[
//                       const SizedBox(height: 6),
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(4),
//                         child: LinearProgressIndicator(
//                           value: cv.progress,
//                           backgroundColor: Colors.grey[200],
//                           color: statusColor,
//                           minHeight: 3,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),

//               // Menu — Edit, Duplicate, Delete only (no share)
//               PopupMenuButton<_CVAction>(
//                 icon: const Icon(Icons.more_vert, size: 20),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 onSelected: (action) {
//                   switch (action) {
//                     case _CVAction.edit:
//                       onEdit();
//                     case _CVAction.duplicate:
//                       onDuplicate();
//                     case _CVAction.delete:
//                       onDelete();
//                   }
//                 },
//                 itemBuilder: (_) => [
//                   _menuItem(_CVAction.edit, Icons.edit_outlined, 'Edit'),
//                   _menuItem(
//                     _CVAction.duplicate,
//                     Icons.copy_outlined,
//                     'Duplicate',
//                   ),
//                   const PopupMenuDivider(),
//                   _menuItem(
//                     _CVAction.delete,
//                     Icons.delete_outline,
//                     'Delete',
//                     isDestructive: true,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   PopupMenuItem<_CVAction> _menuItem(
//     _CVAction action,
//     IconData icon,
//     String label, {
//     bool isDestructive = false,
//   }) {
//     final color = isDestructive ? Colors.red : null;
//     return PopupMenuItem(
//       value: action,
//       child: Row(
//         children: [
//           Icon(icon, size: 18, color: color),
//           const SizedBox(width: 10),
//           Text(label, style: TextStyle(color: color)),
//         ],
//       ),
//     );
//   }

//   String _formatDate(DateTime date) {
//     final diff = DateTime.now().difference(date);
//     if (diff.inMinutes < 1) return 'Just now';
//     if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
//     if (diff.inHours < 24) return '${diff.inHours}h ago';
//     if (diff.inDays == 1) return 'Yesterday';
//     if (diff.inDays < 7) return '${diff.inDays}d ago';
//     return '${date.day}/${date.month}/${date.year}';
//   }
// }

// enum _CVAction { edit, duplicate, delete }
