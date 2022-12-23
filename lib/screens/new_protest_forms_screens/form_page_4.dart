import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/providers/new_protest_form_provider.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:provider/provider.dart';

class FormPageFour extends StatefulWidget {
  const FormPageFour({Key? key}) : super(key: key);

  @override
  State<FormPageFour> createState() => _FormPageFourState();
}

class _FormPageFourState extends State<FormPageFour> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
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
                aspectRatio:
                    Protest.imageRatio.ratioX / Protest.imageRatio.ratioY,
                child: InkWell(
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (image == null) {
                      return;
                    }
                    final croppedImage = await ImageCropper().cropImage(
                        aspectRatio: Protest.imageRatio,
                        sourcePath: image.path,
                        uiSettings: [
                          AndroidUiSettings(
                              toolbarWidgetColor: blue,
                              activeControlsWidgetColor: purple,
                              hideBottomControls: true)
                        ]);
                    if (croppedImage == null) {
                      return;
                    }
                    setState(() {
                      context.read<NewProtestFormNotifier>().protestThumbnail =
                          File(croppedImage.path);
                    });
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
                              child: Image.file(
                                context
                                    .read<NewProtestFormNotifier>()
                                    .protestThumbnail!,
                              ),
                            ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
