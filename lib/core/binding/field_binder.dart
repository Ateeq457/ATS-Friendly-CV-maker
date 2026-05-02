import 'package:android_cv_maker/core/templates/template_blueprint.dart';
import 'package:android_cv_maker/data/models/cv_data.dart';
import 'package:flutter/material.dart';

class FieldBinder {
  final Map<String, TextEditingController> controllers;
  final CVData cvData;

  FieldBinder({required this.controllers, required this.cvData});

  void bindToBlueprint(TemplateBlueprint blueprint) {
    // Map controller values to CVData
    for (var binding in blueprint.fieldBindings.entries) {
      final controller = controllers[binding.value.controllerName];
      if (controller != null) {
        _setCVDataField(binding.key, controller.text);
      }
    }
  }

  void bindFromCVData(TemplateBlueprint blueprint) {
    // Map CVData to controllers
    for (var binding in blueprint.fieldBindings.entries) {
      final controller = controllers[binding.value.controllerName];
      if (controller != null) {
        controller.text = _getCVDataField(binding.key);
      }
    }
  }

  // ✅ ADDED: Method to set CVData field
  void _setCVDataField(String fieldName, String value) {
    switch (fieldName) {
      case 'fullName':
        cvData.fullName = value;
        break;
      case 'title':
        cvData.title = value;
        break;
      case 'email':
        cvData.email = value;
        break;
      case 'phone':
        cvData.phone = value;
        break;
      case 'location':
        cvData.location = value;
        break;
      case 'linkedin':
        cvData.linkedin = value;
        break;
      case 'github':
        cvData.github = value;
        break;
      case 'summary':
        cvData.summary = value;
        break;
      default:
        debugPrint('Unknown field: $fieldName');
    }
  }

  // ✅ ADDED: Method to get CVData field
  String _getCVDataField(String fieldName) {
    switch (fieldName) {
      case 'fullName':
        return cvData.fullName;
      case 'title':
        return cvData.title;
      case 'email':
        return cvData.email;
      case 'phone':
        return cvData.phone;
      case 'location':
        return cvData.location;
      case 'linkedin':
        return cvData.linkedin;
      case 'github':
        return cvData.github;
      case 'summary':
        return cvData.summary;
      default:
        debugPrint('Unknown field: $fieldName');
        return '';
    }
  }
}
