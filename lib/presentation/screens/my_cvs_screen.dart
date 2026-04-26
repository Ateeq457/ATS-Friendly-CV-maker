import 'package:flutter/material.dart';
import '../../core/constants/design_system.dart';
import '../../data/models/cv_model.dart';

class MyCVsScreen extends StatelessWidget {
  const MyCVsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userCVs = CVModel.getSampleCVs();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'My CVs',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [IconButton(icon: const Icon(Icons.search), onPressed: () {})],
      ),
      body: userCVs.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(DesignSystem.paddingLarge),
              itemCount: userCVs.length,
              itemBuilder: (context, index) {
                final cv = userCVs[index];
                return _buildCVCard(context, cv);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewCV(context),
        child: const Icon(Icons.add),
        elevation: 0,
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No CVs yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first CV',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildCVCard(BuildContext context, CVModel cv) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: cv.status == 'draft'
                ? Colors.orange.withOpacity(0.1)
                : Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(DesignSystem.radiusMedium),
          ),
          child: Icon(
            Icons.description,
            color: cv.status == 'draft' ? Colors.orange : Colors.green,
          ),
        ),
        title: Text(
          cv.title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          cv.status == 'draft'
              ? 'Draft • ${(cv.progress * 100).toInt()}%'
              : 'Completed',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _editCV(context, cv),
        ),
        onTap: () => _editCV(context, cv),
      ),
    );
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
}
