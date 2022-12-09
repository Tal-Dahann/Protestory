import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:protestory/widgets/buttons.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/providers/new_protest_form_provider.dart';
import 'dart:io';

class FormPageFour extends StatefulWidget {
  const FormPageFour({Key? key}) : super(key: key);

  @override
  State<FormPageFour> createState() => _FormPageFourState();
}

class _FormPageFourState extends State<FormPageFour> {
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
                  final XFile? image =
                      await _picker.pickImage(source: ImageSource.gallery);
                  if (image == null) {
                    //TODO: add error handling
                  } else {
                    setState(() {
                      context.read<NewProtestFormNotifier>().protestThumbnail =
                          image;
                    });
                  }
                },
                child:
                    context.read<NewProtestFormNotifier>().protestThumbnail ==
                            null
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
                                File(context
                                    .read<NewProtestFormNotifier>()
                                    .protestThumbnail!
                                    .path),
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
                          context.read<NewProtestFormNotifier>().prevPage();
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
                      if (context
                              .read<NewProtestFormNotifier>()
                              .protestThumbnail !=
                          null) {
                        context
                            .read<NewProtestFormNotifier>()
                            .clickFinishButton();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
