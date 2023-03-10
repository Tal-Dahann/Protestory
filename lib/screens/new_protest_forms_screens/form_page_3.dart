import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/providers/new_protest_form_provider.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:protestory/widgets/text_fields.dart';
import 'package:provider/provider.dart';

class FormPageThree extends StatefulWidget {
  const FormPageThree({Key? key}) : super(key: key);

  @override
  State<FormPageThree> createState() => _FormPageThreeState();
}

class _FormPageThreeState extends State<FormPageThree> {
  @override
  Widget build(BuildContext context) {
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
                    color: darkGray, fontWeight: FontWeight.w400, fontSize: 14),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description can\'t be empty';
                }
                return null;
              },
              controller:
                  context.read<NewProtestFormNotifier>().descriptionController,
              height: MediaQuery.of(context).size.height * 0.4,
              keyboardType: TextInputType.multiline,
              maxLines: 12,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength: 1000,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              autofocus: true,
            ),
          )
        ],
      ),
    );
  }
}
