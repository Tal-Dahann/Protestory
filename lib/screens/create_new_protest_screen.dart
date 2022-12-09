import 'package:flutter/material.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/firebase/data_provider.dart';
import 'package:protestory/providers/new_protest_form_provider.dart';
import 'package:protestory/screens/new_protest_forms_screens//form_page_1.dart';
import 'package:protestory/screens/new_protest_forms_screens/form_page_2.dart';
import 'package:protestory/screens/new_protest_forms_screens/form_page_3.dart';
import 'package:protestory/screens/new_protest_forms_screens/form_page_4.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:protestory/widgets/buttons.dart';

////////////////////////////////////////
// Example usage of a form page:
// Wrap it with ChangeNotifierProvider that uses the NewProtestFormNotifier() like this:
////////////////////////////////////////
// child: ChangeNotifierProvider(
//            create: (context) => NewProtestFormNotifier(),
//            child: const NewProtestScreen(),
//            )
////////////////////////////////////////

class NewProtestScreen extends StatefulWidget {
  const NewProtestScreen({Key? key}) : super(key: key);

  @override
  State<NewProtestScreen> createState() => _NewProtestScreenState();
}

class _NewProtestScreenState extends State<NewProtestScreen> {
  void _handleFinishButton() async {
    //TODO: Upload image to firestore storage

    //Upload Protest
    await processDataAndUploadNewProtest();

    // TODO: Return to protest view after uploading protest
  }

  Future<void> processDataAndUploadNewProtest() async {
    //creator = context.read<AuthProvider>.user or something like that
    String name = context.read<NewProtestFormNotifier>().titleController.text;
    //Timestamp date = Timestamp.fromDate(selectedTime);
    String description =
        context.read<NewProtestFormNotifier>().descriptionController.text;
    String location =
        context.read<NewProtestFormNotifier>().locationController.text;
    //Tag list = tags
    //TODO: add addProtest() once the ProxyProvider is merged.
    await context.read<DataProvider>().addProtest(
        name: name,
        date: context.read<NewProtestFormNotifier>().selectedTime,
        contactInfo: 'test@test.test',
        description: description,
        location: location,
        tags: context.read<NewProtestFormNotifier>().selectedTags);
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<NewProtestFormNotifier>().finishButtonClicked == true) {
      _handleFinishButton();
    }
    int currPageNum = context.watch<NewProtestFormNotifier>().currentFormPage;
    Widget? currPageToDisplay;
    switch (currPageNum) {
      case 1:
        currPageToDisplay = const FormPageOne();
        break;
      case 2:
        currPageToDisplay = const FormPageTwo();
        break;
      case 3:
        currPageToDisplay = const FormPageThree();
        break;
      case 4:
        currPageToDisplay = const FormPageFour();
        break;
      default:
        currPageToDisplay = const Text('Error Occurred....');
    }
    Widget? scaffoldToDisplay = Scaffold(
      appBar: AppBar(
        title: const Text('New Protest',
            style: TextStyle(color: blue, fontWeight: FontWeight.bold)),
        backgroundColor: white,
      ),
      body: Column(
        children: [
          StepProgressIndicator(
            totalSteps: 4,
            selectedColor: purple,
            currentStep: context.read<NewProtestFormNotifier>().currentFormPage,
            size: 7,
          ),
          Expanded(
              flex: 4,
              child: Form(
                  key: context.read<NewProtestFormNotifier>().formKey,
                  child: currPageToDisplay)),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  context.read<NewProtestFormNotifier>().currentFormPage > 1
                      ? Align(
                          alignment: Alignment.bottomLeft,
                          child: CustomButton(
                              text: 'Previous',
                              textColor: purple,
                              color: white,
                              width: MediaQuery.of(context).size.width * 0.35,
                              onPressed: () {
                                setState(() {
                                  context
                                      .read<NewProtestFormNotifier>()
                                      .prevPage();
                                });
                              }),
                        )
                      : const SizedBox(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: CustomButton(
                        text: currPageNum != 4 ? 'Continue' : 'Finish',
                        color: darkPurple,
                        width: MediaQuery.of(context).size.width * 0.4,
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          GlobalKey<FormState> formKey =
                              context.read<NewProtestFormNotifier>().formKey;
                          bool valid = false;
                          switch (currPageNum) {
                            case 1:
                              valid = formKey.currentState!.validate();
                              break;
                            case 2:
                              if (context
                                  .read<NewProtestFormNotifier>()
                                  .selectedTags
                                  .isNotEmpty) {
                                valid = true;
                              } else {
                                context
                                    .read<NewProtestFormNotifier>()
                                    .displayTagsError();
                              }
                              break;
                            case 3:
                              valid = formKey.currentState!.validate();
                              break;
                            case 4:
                              if (context
                                      .read<NewProtestFormNotifier>()
                                      .protestThumbnail !=
                                  null) {
                                valid = true;
                              }
                              break;
                          }
                          if (valid) {
                            setState(() {
                              context.read<NewProtestFormNotifier>().nextPage();
                            });
                          } else {
                            //TODO: display validation error
                          }
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (currPageNum != 1) {
      //WillPopScope makes it so when you click the "back" button (in the phone toolbar)- it will go to the previous form page :)
      return WillPopScope(
          onWillPop: () {
            setState(() {
              context.read<NewProtestFormNotifier>().prevPage();
            });
            return Future.value(false);
          },
          child: scaffoldToDisplay);
    }
    return scaffoldToDisplay;
  }
}
