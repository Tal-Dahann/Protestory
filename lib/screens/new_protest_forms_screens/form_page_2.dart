import 'package:flutter/material.dart';
import 'package:protestory/widgets/buttons.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/providers/new_protest_form_provider.dart';

class FormPageTwo extends StatefulWidget {
  const FormPageTwo({Key? key}) : super(key: key);

  @override
  State<FormPageTwo> createState() => _FormPageTwoState();
}

class _FormPageTwoState extends State<FormPageTwo> {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              'What\'s the topic that best describes your protest?',
              style: TextStyle(
                  color: blue, fontWeight: FontWeight.bold, fontSize: 24),
              textAlign: TextAlign.left,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: ListView(
            children: [
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
                      bool currSelected = context
                          .read<NewProtestFormNotifier>()
                          .selectedTags
                          .contains(tags[index]);
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
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
                                  ? context
                                      .read<NewProtestFormNotifier>()
                                      .selectedTags
                                      .add(tags[index])
                                  : context
                                      .read<NewProtestFormNotifier>()
                                      .selectedTags
                                      .remove(tags[index]);
                              //log(selectedTags.toString());
                            });
                          },
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
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
          ),
        )
      ],
    );
  }
}
