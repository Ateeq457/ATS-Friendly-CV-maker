import 'package:android_cv_maker/core/templates/template_blueprint.dart';
import 'package:android_cv_maker/models/cv_data.dart';
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
}
