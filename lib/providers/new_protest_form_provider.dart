import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class NewProtestFormNotifier extends ChangeNotifier {
  int currentFormPage = 1;
  final currentFormPageController = TextEditingController();
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final descriptionController = TextEditingController();
  final titleFormKey = GlobalKey<FormState>();
  final protestTags = <String>[];
  DateTime selectedTime = DateTime(0);

  final tagsColors = <Color>[];
  final selectedTags = <String>[];
  XFile? protestThumbnail;

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
}
