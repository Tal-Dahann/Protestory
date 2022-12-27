import 'package:flutter/material.dart';
import 'package:protestory/providers/data_provider.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:protestory/utils/exceptions.dart';
import 'package:protestory/widgets/buttons.dart';
import 'package:protestory/widgets/text_fields.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../firebase/protest.dart';
import '../widgets/navigation.dart';

class UploadStoryScreen extends StatefulWidget {
  final TextEditingController storyController;
  final Protest protest;

  const UploadStoryScreen(
      {Key? key, required this.storyController, required this.protest})
      : super(key: key);

  @override
  State<UploadStoryScreen> createState() => _UploadStoryScreenState();
}

class _UploadStoryScreenState extends State<UploadStoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: const BackButton(
            color: blue,
          ),
          title: const Text(
            'Write A Story',
            style: navTitleStyle,
          ),
          backgroundColor: white,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            addVerticalSpace(height: 20),
            const Text('Explain why this protest is important to you.',
                style: TextStyle(color: darkGray, fontSize: 16)),
            addVerticalSpace(height: 20),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 8.0, top: 15),
                  child: CustomTextFormField(
                    height: MediaQuery.of(context).size.height * 0.5,
                    hintText: 'Write your story here',
                    controller: widget.storyController,
                    maxLines: 6,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomButton(
                      text: 'Upload',
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (widget.storyController.text == '') {
                          ProtestoryException.showExceptionSnackBar(context,
                              message: 'Can\'t upload empty story.');
                        } else {
                          context.read<DataProvider>().addStory(
                              widget.protest, widget.storyController.text);
                          Navigator.of(context).pop();
                        }
                      }),
                  addVerticalSpace(height: 15),
                  CustomButton(
                    text: 'Cancel',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: white,
                    textColor: blue,
                  ),
                ],
              ),
            ),
            addVerticalSpace(height: 30),
          ],
        ));
  }
}
