import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/widgets/buttons.dart';
import 'package:protestory/widgets/text_fields.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:image_picker/image_picker.dart';

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
  XFile? protestThumbnail = null;

  late FocusNode locationFocusNode;
  late FocusNode dateFocusNode;

  @override
  void initState() {
    dateController.text = '';
    titleController.text = '';
    locationController.text = '';
    descriptionController.text = '';
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
    } else if (currentFormPage == 2) {
      return WillPopScope(
        onWillPop: () {
          setState(() {
            currentFormPage--;
          });
          return Future.value(false);
        },
        child: Scaffold(
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
                    'What\'s the topic that best describes your protest?',
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
                child: Wrap(
                  spacing: 7,
                  children: List<Widget>.generate(
                    tags.length,
                    (int index) {
                      bool currSelected = selectedTags.contains(tags[index]);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: ChoiceChip(
                          // shape: const StadiumBorder(
                          //   side: BorderSide(),
                          // ),
                          side: BorderSide(
                              color: currSelected ? darkPurple : lightGray),
                          labelPadding: const EdgeInsets.all(5.0),
                          label: Text(
                            tags[index],
                            style: TextStyle(
                                color: currSelected ? darkPurple : black,
                                fontSize: 18),
                          ),
                          selected: currSelected,
                          selectedColor: transparentPurple,
                          backgroundColor: currSelected ? purple : white,
                          elevation: 2,
                          onSelected: (bool selected) {
                            setState(() {
                              selected
                                  ? selectedTags.add(tags[index])
                                  : selectedTags.remove(tags[index]);
                              log(selectedTags.toString());
                            });
                          },
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: CustomButton(
                            text: 'Previous',
                            textColor: purple,
                            color: white,
                            width: MediaQuery.of(context).size.width * 0.35,
                            onPressed: () {
                              setState(() {
                                currentFormPage--;
                              });
                            }),
                      ),
                      Align(
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
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else if (currentFormPage == 3) {
      return WillPopScope(
        onWillPop: () {
          setState(() {
            currentFormPage--;
          });
          return Future.value(false);
        },
        child: Scaffold(
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
                    'Protest Description',
                    style: TextStyle(
                        color: blue, fontWeight: FontWeight.bold, fontSize: 32),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              addVerticalSpace(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1,
                      right: MediaQuery.of(context).size.width * 0.1),
                  child: Text(
                    'Give a description to your protest.',
                    style: TextStyle(
                        color: blue, fontWeight: FontWeight.w500, fontSize: 20),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              addVerticalSpace(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1,
                      right: MediaQuery.of(context).size.width * 0.1),
                  child: Text(
                    'Tip: a more detailed description is more likely to get more people to support your protest.',
                    style: TextStyle(
                        color: darkGray,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              addVerticalSpace(height: 20),
              Expanded(
                child: CustomTextFormField(
                  height: MediaQuery.of(context).size.height * 0.4,
                  keyboardType: TextInputType.multiline,
                  maxLines: 12,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: CustomButton(
                            text: 'Previous',
                            textColor: purple,
                            color: white,
                            width: MediaQuery.of(context).size.width * 0.35,
                            onPressed: () {
                              setState(() {
                                currentFormPage--;
                              });
                            }),
                      ),
                      Align(
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
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return WillPopScope(
        onWillPop: () {
          setState(() {
            currentFormPage--;
          });
          return Future.value(false);
        },
        child: Scaffold(
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
                    'Choose A Protest Thumbnail',
                    style: TextStyle(
                        color: blue, fontWeight: FontWeight.bold, fontSize: 32),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              addVerticalSpace(height: 40),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.1,
                      right: MediaQuery.of(context).size.width * 0.1),
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: InkWell(
                      onTap: () async {
                        final ImagePicker _picker = ImagePicker();
                        final XFile? image = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (image == null) {
                          //TODO: add error handling
                        } else {
                          setState(() {
                            protestThumbnail = image;
                          });
                        }
                      },
                      child: protestThumbnail == null
                          ? Container(
                              color: lightGray,
                              width: MediaQuery.of(context).size.width * 0.8,
                            )
                          : Container(
                              color: lightGray,
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: FittedBox(
                                fit: BoxFit.fill,
                                child: Image.file(
                                  File(protestThumbnail!.path),
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: CustomButton(
                            text: 'Previous',
                            textColor: purple,
                            color: white,
                            width: MediaQuery.of(context).size.width * 0.35,
                            onPressed: () {
                              setState(() {
                                currentFormPage--;
                              });
                            }),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: CustomButton(
                            text: 'Finish',
                            color: darkPurple,
                            width: MediaQuery.of(context).size.width * 0.3,
                            onPressed: () {
                              setState(() {
                                currentFormPage++;
                              });
                            }),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
