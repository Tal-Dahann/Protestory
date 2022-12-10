import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/providers/new_protest_form_provider.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:protestory/widgets/text_fields.dart';
import 'package:provider/provider.dart';

class FormPageOne extends StatefulWidget {
  // final TextEditingController currentFormPageController;
  // final TextEditingController titleController;
  // final TextEditingController locationController;
  // final TextEditingController dateController;
  // final TextEditingController timeController;
  // final FocusNode locationFocusNode;
  // final FocusNode dateFocusNode;
  // final GlobalKey<FormState> titleFormKey;

  const FormPageOne({super.key});

  @override
  State<FormPageOne> createState() => _FormPageOneState();
}

class _FormPageOneState extends State<FormPageOne> {
  Widget themeBuilder(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: blue,
          onPrimary: white,
          onSurface: darkBlue,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              backgroundColor: lightBlue, foregroundColor: white),
        ),
      ),
      child: child!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          addVerticalSpace(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1),
              child: const Text(
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
              controller:
                  context.read<NewProtestFormNotifier>().titleController,
              validator: (value) {
                if (value == null || value.length > 25 || value.isEmpty) {
                  return 'The title must be 1-25 characters long.';
                }
                if (value.contains(RegExp(r'^[a-zA-Z ]+$'))) {
                  return null;
                } else {
                  return 'The title can only contain letters';
                }
              },
              onChanged: (_) {},
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onFieldSubmitted: (String value) {
                context
                    .read<NewProtestFormNotifier>()
                    .locationFocusNode
                    .requestFocus();
              },
              label: 'Title',
              icon: const Icon(
                Icons.edit,
                color: blue,
              ),
            ),
          ),
          addVerticalSpace(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1),
              child: const Text(
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller:
                  context.read<NewProtestFormNotifier>().locationController,
              focusNode:
                  context.read<NewProtestFormNotifier>().locationFocusNode,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please specify a location.';
                }
                return null;
              },
              onFieldSubmitted: (String value) {
                FocusScope.of(context).requestFocus(
                    context.read<NewProtestFormNotifier>().dateFocusNode);
              },
              label: 'Location',
              icon: const Icon(
                Icons.location_on,
                color: blue,
              ),
            ),
          ),
          addVerticalSpace(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1),
              child: const Text(
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
              controller: context.read<NewProtestFormNotifier>().dateController,
              label: 'Date',
              focusNode: context.read<NewProtestFormNotifier>().dateFocusNode,
              icon: const Icon(
                Icons.calendar_month,
                color: blue,
              ),
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Must select a date and time';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                  builder: themeBuilder,
                );
                if (!mounted) {
                  return;
                }
                if (pickedDate == null) {
                  FocusScope.of(context).unfocus();
                  context.read<NewProtestFormNotifier>().dateController.clear();
                  return;
                }
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: themeBuilder,
                );
                if (!mounted) {
                  return;
                }
                if (pickedTime == null) {
                  FocusScope.of(context).unfocus();
                  context.read<NewProtestFormNotifier>().timeController.clear();
                  context.read<NewProtestFormNotifier>().dateController.clear();
                  return;
                }
                context.read<NewProtestFormNotifier>().selectedTime = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute);
                String formattedDate =
                    DateFormat('dd/MM/yyyy').format(pickedDate);
                //String formattedDate = DateFormat.yMMMEd().format(pickedDate);
                //log('$formattedDate, ${pickedTime.format(context)}');
                setState(
                  () {
                    context.read<NewProtestFormNotifier>().timeController.text =
                        pickedTime.format(context);
                    //dateController.text = '$formattedDate - ${pickedTime.format(context)}';
                    context.read<NewProtestFormNotifier>().dateController.text =
                        '$formattedDate, ${pickedTime.format(context)}';
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
