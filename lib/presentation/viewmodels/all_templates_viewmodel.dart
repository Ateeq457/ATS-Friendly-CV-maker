import 'package:flutter/material.dart';
import '../../data/repositories/template_repository.dart';
import '../../data/models/template_model.dart';

class AllTemplatesViewModel extends ChangeNotifier {
  final TemplateRepository _repository = TemplateRepository();

  List<TemplateModel> _templates = [];
  List<TemplateModel> _filteredTemplates = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _errorMessage = '';

  List<TemplateModel> get templates => _filteredTemplates;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String get errorMessage => _errorMessage;

  AllTemplatesViewModel() {
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _templates = await _repository.loadAllTemplates();
      _applyFilters();
    } catch (e) {
      _errorMessage = e.toString();
      _templates = [];
      _filteredTemplates = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _applyFilters() {
    _filteredTemplates = List.from(_templates);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      _filteredTemplates = _filteredTemplates
          .where(
            (t) => t.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void clearSearch() {
    _searchQuery = '';
    _applyFilters();
  }
}
