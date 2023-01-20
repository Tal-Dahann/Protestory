import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewProtestFormNotifier extends ChangeNotifier {
  int currentFormPage = 1;
  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();
  final locationController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime selectedTime = DateTime(0);
  List<String> selectedTags = <String>[];
  File? protestThumbnail;
  NetworkImage? existingProtestThumbnail;
  bool showTagsError = false;
  LatLng? locationLatLng;

  bool finishButtonClicked = false;
  late FocusNode dateFocusNode;

  NewProtestFormNotifier() {
    timeController.text = '';
    dateController.text = '';
    titleController.text = '';
    descriptionController.text = '';
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
