import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/widgets/place_picker.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/providers/new_protest_form_provider.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:protestory/widgets/text_fields.dart';
import 'package:provider/provider.dart';

class FormPageOne extends StatefulWidget {
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

  _fetchLocation(NewProtestFormNotifier notifier) async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              'AIzaSyCo-uZ1Sbqmdvi0qhYilL_yZ82CodRViEQ',
            )));
    if (result.name != null) {
      notifier.locationController.text = result.name!;
    } else if (result.formattedAddress != null) {
      notifier.locationController.text = result.formattedAddress!;
    }
    notifier.locationLatLng = result.latLng;
  }

  _fetchDate(NewProtestFormNotifier notifier) async {
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
      notifier.dateController.clear();
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
      notifier.timeController.clear();
      notifier.dateController.clear();
      return;
    }
    notifier.selectedTime = DateTime(pickedDate.year, pickedDate.month,
        pickedDate.day, pickedTime.hour, pickedTime.minute);
    //String formattedDate = DateFormat.yMMMEd().format(pickedDate);
    //log('$formattedDate, ${pickedTime.format(context)}');
    setState(
      () {
        notifier.timeController.text = pickedTime.format(context);
        //dateController.text = '$formattedDate - ${pickedTime.format(context)}';
        notifier.dateController.text = Protest.dateFormatter
            .format(context.read<NewProtestFormNotifier>().selectedTime);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.read<NewProtestFormNotifier>();
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
              controller: notifier.titleController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'The title must be not empty';
                }
                if (value.contains(RegExp(r"^[a-zA-Z '\d]+$"))) {
                  return null;
                } else {
                  return 'The title can only contain letters and numbers';
                }
              },
              onChanged: (_) {},
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onFieldSubmitted: (_) async {
                await _fetchLocation(notifier);
                await _fetchDate(notifier);
              },
              label: 'Title',
              icon: const Icon(
                Icons.edit,
                color: blue,
              ),
              maxLength: 25,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              autofocus: true,
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
              controller: notifier.locationController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please specify a location.';
                }
                return null;
              },
              onFieldSubmitted: (String value) {
                FocusScope.of(context).requestFocus(notifier.dateFocusNode);
              },
              label: 'Location',
              icon: const Icon(
                Icons.location_on,
                color: blue,
              ),
              readOnly: true,
              onTap: () => _fetchLocation(notifier),
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
              controller: notifier.dateController,
              label: 'Date',
              focusNode: notifier.dateFocusNode,
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
              onTap: () => _fetchDate(notifier),
            ),
          ),
        ],
      ),
    );
  }
}
