import 'package:flutter/material.dart';

import 'package:protestory/widgets/buttons.dart';
import 'package:protestory/widgets/text_fields.dart';
import 'package:intl/intl.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/providers/new_protest_form_provider.dart';

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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StepProgressIndicator(
          totalSteps: 4,
          selectedColor: purple,
          currentStep: context.read<NewProtestFormNotifier>().currentFormPage,
          size: 7,
        ),
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
            controller: context.read<NewProtestFormNotifier>().titleController,
            key: context.read<NewProtestFormNotifier>().titleFormKey,
            validator: (value) {
              if (value == null || value.length > 25) {
                return 'The title must be 1-25 characters long.';
              }
              if (value.contains(RegExp(r'^[a-zA-Z]+$'))) {
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
            controller:
                context.read<NewProtestFormNotifier>().locationController,
            focusNode: context.read<NewProtestFormNotifier>().locationFocusNode,
            onFieldSubmitted: (String value) {
              context
                  .read<NewProtestFormNotifier>()
                  .dateFocusNode
                  .requestFocus();
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
                    //TODO: add validator for title.
                    //if (selectedTime != DateTime(0)) {
                    setState(() {
                      context.read<NewProtestFormNotifier>().nextPage();
                    });
                    //}
                  }),
            ),
          ),
        )
      ],
    );
  }
}
