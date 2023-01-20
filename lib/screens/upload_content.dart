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

enum UploadMode { story, update }

class UploadContentScreen extends StatefulWidget {
  final TextEditingController contentController;
  final Protest protest;
  final UploadMode uploadMode;

  const UploadContentScreen(
      {Key? key,
      required this.contentController,
      required this.protest,
      required this.uploadMode})
      : super(key: key);

  @override
  State<UploadContentScreen> createState() => _UploadContentScreenState();
}

class _UploadContentScreenState extends State<UploadContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: const BackButton(
            color: blue,
          ),
          title: Text(
            widget.uploadMode == UploadMode.story
                ? 'Write A Story'
                : 'Post An Update',
            style: navTitleStyle,
          ),
          backgroundColor: white,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            addVerticalSpace(height: 20),
            widget.uploadMode == UploadMode.story
                ? const Text('Explain why this protest is important to you.',
                    style: TextStyle(color: darkGray, fontSize: 16))
                : const SizedBox(),
            addVerticalSpace(height: 20),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 8.0, top: 15),
                  child: CustomTextFormField(
                    height: MediaQuery.of(context).size.height * 0.5,
                    hintText: widget.uploadMode == UploadMode.story
                        ? 'Write your story here'
                        : 'Write the update here',
                    controller: widget.contentController,
                    maxLines: 6,
                    autofocus: true,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomButton(
                      text: widget.uploadMode == UploadMode.story
                          ? 'Upload'
                          : 'Post',
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (widget.contentController.text == '') {
                          if (widget.uploadMode == UploadMode.story) {
                            ProtestoryException.showExceptionSnackBar(context,
                                message: 'Can\'t upload an empty story.');
                          } else {
                            ProtestoryException.showExceptionSnackBar(context,
                                message: 'Can\'t post an empty update.');
                          }
                        } else {
                          if (widget.uploadMode == UploadMode.story) {
                            context.read<DataProvider>().addStory(
                                widget.protest, widget.contentController.text);
                          } else {
                            context.read<DataProvider>().addUpdate(
                                widget.protest, widget.contentController.text);
                          }
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
