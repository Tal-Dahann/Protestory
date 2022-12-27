import 'package:flutter/material.dart';
import 'package:protestory/providers/data_provider.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:protestory/widgets/buttons.dart';
import 'package:protestory/widgets/text_fields.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../firebase/protest.dart';
import '../widgets/navigation.dart';

class UploadStoryScreen extends StatefulWidget {
  final TextEditingController storyController;
  final Protest protest;

  const UploadStoryScreen({Key? key, required this.storyController, required this.protest})
      : super(key: key);

  @override
  State<UploadStoryScreen> createState() => _UploadStoryScreenState();
}

class _UploadStoryScreenState extends State<UploadStoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: blue,
          ),
          title: Text(
            'Write Story',
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: CustomButton(
                        text: 'Cancel',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: white,
                        textColor: blue,
                      )),
                  Align(
                      alignment: Alignment.topCenter,
                      child: CustomButton(
                          text: 'Upload',
                          onPressed: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            await Future.delayed(Duration(milliseconds: 500));
                            if (widget.storyController.text == '') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Can\'t upload empty story.'),
                                behavior: SnackBarBehavior.floating,
                              ));
                            } else {
                              context.read<DataProvider>().addStory(widget.protest, widget.storyController.text);
                              Navigator.of(context).pop();
                            }
                          })),
                ],
              ),
            ),
            addVerticalSpace(height: 30),
          ],
        ));
  }
}
