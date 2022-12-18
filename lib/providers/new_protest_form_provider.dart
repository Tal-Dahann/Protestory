import 'dart:io';

import 'package:flutter/material.dart';

class NewProtestFormNotifier extends ChangeNotifier {
  int currentFormPage = 1;
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final protestTags = <String>[];
  DateTime selectedTime = DateTime(0);
  final selectedTags = <String>[];
  File? protestThumbnail;
  bool showTagsError = false;

  bool finishButtonClicked = false;

  late FocusNode locationFocusNode;
  late FocusNode dateFocusNode;

  NewProtestFormNotifier() {
    timeController.text = '';
    dateController.text = '';
    titleController.text = '';
    locationController.text = '';
    descriptionController.text = '';
    locationFocusNode = FocusNode();
    dateFocusNode = FocusNode();
  }

  void nextPage() {
    currentFormPage++;
    notifyListeners();
  }

  void prevPage() {
    currentFormPage--;
    notifyListeners();
  }

  void clickFinishButton() {
    finishButtonClicked = true;
    notifyListeners();
  }

  void displayTagsError() {
    showTagsError = true;
    notifyListeners();
  }

  void hideTagsError() {
    showTagsError = false;
    notifyListeners();
  }
}
