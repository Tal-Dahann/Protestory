import 'package:flutter/material.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/providers/new_protest_form_provider.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:provider/provider.dart';

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
    bool showError = context.watch<NewProtestFormNotifier>().showTagsError;
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
          Column(
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
                              if (context
                                  .read<NewProtestFormNotifier>()
                                  .selectedTags
                                  .isNotEmpty) {
                                context
                                    .read<NewProtestFormNotifier>()
                                    .showTagsError = false;
                              } else {
                                context
                                    .read<NewProtestFormNotifier>()
                                    .showTagsError = true;
                              }
                            });
                          },
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              addVerticalSpace(height: 15),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
                height: !showError ? 0 : 18,
                child: const Text(
                  'Please pick at least one tag for your protest.',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
