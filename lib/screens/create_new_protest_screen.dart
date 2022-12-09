import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/widgets/buttons.dart';
import 'package:protestory/widgets/text_fields.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';


class NewProtestScreen extends StatefulWidget {
  const NewProtestScreen({Key? key}) : super(key: key);

  @override
  State<NewProtestScreen> createState() => _NewProtestScreenState();
}

class _NewProtestScreenState extends State<NewProtestScreen> {
  int currentFormPage = 1;
  final titleController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();
  final protestTags = <String>[];
  final tags = [
    'Animals',
    'Business and Brands',
    'Criminal Justice',
    'Environment',
    'Education',
    'Economic justice',
    'Entertainment',
    'Criminals',
    'Food',
    'Health',
    'Human Rights',
    'Politics',
    'Emigration',
    'LGBTQ+',
    'Women\'s rights',
    'Other',
  ];
  final tagsColors = <Color>[];
  final selectedTags = <String>[];

  late FocusNode titleFocusNode;
  late FocusNode locationFocusNode;
  late FocusNode dateFocusNode;

  @override
  void initState() {
    dateController.text = '';
    titleController.text = '';
    locationController.text = '';
    descriptionController.text = '';
    titleFocusNode = FocusNode();
    locationFocusNode = FocusNode();
    dateFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    locationController.dispose();
    dateController.dispose();
    descriptionController.dispose();
    titleFocusNode.dispose();
    locationFocusNode.dispose();
    dateFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (currentFormPage == 1) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('New Protest',
              style: TextStyle(color: blue, fontWeight: FontWeight.bold)),
          backgroundColor: white,
        ),
        body: Column(
          children: [
            StepProgressIndicator(
              totalSteps: 4,
              selectedColor: purple,
              currentStep: currentFormPage,
              size: 7,
            ),
            addVerticalSpace(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.1,
                    right: MediaQuery.of(context).size.width * 0.1),
                child: Text(
                  'Enter your protest title:',
                  style: TextStyle(
                      color: blue, fontWeight: FontWeight.bold, fontSize: 24),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            addVerticalSpace(height: 15),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1),
              child: CustomTextFormField(
                controller: titleController,
                focusNode: titleFocusNode,
                onFieldSubmitted: (String value) {
                  locationFocusNode.requestFocus();
                },
                label: 'Title',
                icon: Icons.edit,
              ),
            ),
            addVerticalSpace(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.1,
                    right: MediaQuery.of(context).size.width * 0.1),
                child: Text(
                  'Pick a location:',
                  style: TextStyle(
                      color: blue, fontWeight: FontWeight.bold, fontSize: 24),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            addVerticalSpace(height: 15),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1),
              child: CustomTextFormField(
                controller: locationController,
                focusNode: locationFocusNode,
                onFieldSubmitted: (String value) {
                  dateFocusNode.requestFocus();
                },
                label: 'Location',
                icon: Icons.location_on,
              ),
            ),
            addVerticalSpace(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.1,
                    right: MediaQuery.of(context).size.width * 0.1),
                child: Text(
                  'Pick a date:',
                  style: TextStyle(
                      color: blue, fontWeight: FontWeight.bold, fontSize: 24),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            addVerticalSpace(height: 15),
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1),
              child: CustomTextFormField(
                controller: dateController,
                label: 'Date',
                focusNode: dateFocusNode,
                icon: Icons.calendar_month,
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedDate != null && pickedTime != null) {
                    String formattedDate =
                        DateFormat('dd/MM/yyyy').format(pickedDate);
                    //String formattedDate = DateFormat.yMMMEd().format(pickedDate);
                    log('$formattedDate, ${pickedTime.format(context)}');
                    setState(
                      () {
                        //dateController.text = '$formattedDate - ${pickedTime.format(context)}';
                        dateController.text =
                            '$formattedDate, ${pickedTime.format(context)}';
                      },
                    );
                  } else {
                    //TODO: SHOW ERROR maybe?
                  }
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CustomButton(
                      text: 'Continue',
                      color: darkPurple,
                      width: MediaQuery.of(context).size.width * 0.4,
                      onPressed: () {
                        setState(() {
                          currentFormPage++;
                        });
                      }),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Scaffold();
    }
  }
}
