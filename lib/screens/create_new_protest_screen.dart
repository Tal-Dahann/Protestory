import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/firebase/auth_notifier.dart';
import 'package:protestory/firebase/data_provider.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/providers/new_protest_form_provider.dart';
import 'package:protestory/screens/new_protest_forms_screens//form_page_1.dart';
import 'package:protestory/screens/new_protest_forms_screens/form_page_2.dart';
import 'package:protestory/screens/new_protest_forms_screens/form_page_3.dart';
import 'package:protestory/screens/new_protest_forms_screens/form_page_4.dart';
import 'package:protestory/screens/new_protest_forms_screens/uploading_protest_screen.dart';
import 'package:protestory/screens/protest_information_screen.dart';
import 'package:protestory/widgets/buttons.dart';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

import '../widgets/discard_changes.dart';
import '../widgets/navigation.dart';

class NewProtestScreen extends StatefulWidget {
  const NewProtestScreen({Key? key}) : super(key: key);

  @override
  State<NewProtestScreen> createState() => _NewProtestScreenState();
}

class _NewProtestScreenState extends State<NewProtestScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero);
    return DiscardChanges(
      child: ChangeNotifierProvider(
        create: (context) => NewProtestFormNotifier(),
        child: const NewProtestForm(),
      ),
    );
  }
}

class NewProtestForm extends StatefulWidget {
  const NewProtestForm({Key? key}) : super(key: key);

  @override
  State<NewProtestForm> createState() => _NewProtestFormState();
}

class _NewProtestFormState extends State<NewProtestForm> {
  void _handleFinishButton(BuildContext context) async {
    Future.delayed(Duration.zero, () {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const UploadingProtestScreen()));
    });
    //Upload Protest
    Protest protest = await processDataAndUploadNewProtest();
    Future.delayed(Duration.zero, () {
      //Function to navigate to protest page after successful upload!
      Navigator.of(context).popUntil(ModalRoute.withName("/"));
      PersistentNavBarNavigator.pushNewScreen(context,
          screen: ProtestInformationScreen(protest: protest),
          pageTransitionAnimation: PageTransitionAnimation.slideUp);
    });
  }

  Future<Protest> processDataAndUploadNewProtest() async {
    String name = context.read<NewProtestFormNotifier>().titleController.text;
    String description =
        context.read<NewProtestFormNotifier>().descriptionController.text;
    String location =
        context.read<NewProtestFormNotifier>().locationController.text;
    String? contactInfo = context.read<AuthNotifier>().user!.email;
    contactInfo ??= 'No contact info provided';
    return context.read<DataProvider>().addProtest(
        name: name,
        date: context.read<NewProtestFormNotifier>().selectedTime,
        contactInfo: contactInfo,
        description: description,
        location: location,
        tags: context.read<NewProtestFormNotifier>().selectedTags,
        image: context.read<NewProtestFormNotifier>().protestThumbnail!);
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<NewProtestFormNotifier>().finishButtonClicked == true) {
      _handleFinishButton(context);
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
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const BackButton(
          color: blue,
        ),
        title: const Text('New Protest', style: navTitleStyle),
        backgroundColor: white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              children: [
                StepProgressIndicator(
                  totalSteps: 4,
                  selectedColor: purple,
                  currentStep:
                      context.read<NewProtestFormNotifier>().currentFormPage,
                  size: 7,
                ),
                Flexible(
                  child: Form(
                      key: context.read<NewProtestFormNotifier>().formKey,
                      child: currPageToDisplay),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
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
                                bool showTagError = context
                                    .read<NewProtestFormNotifier>()
                                    .showTagsError;
                                setState(() {
                                  if (showTagError) {
                                    context
                                        .read<NewProtestFormNotifier>()
                                        .hideTagsError();
                                  }
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
                          if (valid && currPageNum != 4) {
                            setState(() {
                              context.read<NewProtestFormNotifier>().nextPage();
                            });
                          } else if (valid) {
                            context
                                .read<NewProtestFormNotifier>()
                                .clickFinishButton();
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
