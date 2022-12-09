import 'package:flutter/material.dart';
import 'package:protestory/widgets/buttons.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/providers/new_protest_form_provider.dart';
import 'package:protestory/widgets/text_fields.dart';

class FormPageThree extends StatefulWidget {
  const FormPageThree({Key? key}) : super(key: key);

  @override
  State<FormPageThree> createState() => _FormPageThreeState();
}

class _FormPageThreeState extends State<FormPageThree> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StepProgressIndicator(
          totalSteps: 4,
          selectedColor: purple,
          currentStep: context.read<NewProtestFormNotifier>().currentFormPage,
          size: 7,
        ),
        ListView(
          children: [
            addVerticalSpace(height: 30),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.1,
                    right: MediaQuery.of(context).size.width * 0.1),
                child: const Text(
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
                child: const Text(
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
                child: const Text(
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
            Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1),
              child: CustomTextFormField(
                controller: context
                    .read<NewProtestFormNotifier>()
                    .descriptionController,
                height: MediaQuery.of(context).size.height * 0.4,
                keyboardType: TextInputType.multiline,
                maxLines: 12,
              ),
            ),
          ],
        ),
        Padding(
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
                        context.read<NewProtestFormNotifier>().prevPage();
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
                        context.read<NewProtestFormNotifier>().nextPage();
                      });
                    }),
              ),
            ],
          ),
        )
      ],
    );
  }
}
