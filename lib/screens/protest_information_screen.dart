import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/providers/auth_provider.dart';
import 'package:protestory/providers/data_provider.dart';
import 'package:protestory/providers/editors_provider.dart';
import 'package:protestory/providers/navigation_provider.dart';
import 'package:protestory/screens/create_new_protest_screen.dart';
import 'package:protestory/screens/upload_content.dart';
import 'package:protestory/widgets/buttons.dart';
import 'package:protestory/widgets/protest_information_detailed.dart';
import 'package:protestory/widgets/text_fields.dart';
import 'package:protestory/widgets/user_search.dart';
import 'package:provider/provider.dart';

import '../widgets/protest_stories.dart';
import '../widgets/protest_updates.dart';

enum AttendingStatus { unKnown, attending, notAttending, joining, leaving }

class ProtestHolder extends ChangeNotifier {
  Protest _protest;
  AttendingStatus _isAttending = AttendingStatus.unKnown;

  ProtestHolder(Protest protest) : _protest = protest;

  Protest get protest {
    return _protest;
  }

  AttendingStatus get isAttending {
    return _isAttending;
  }

  set protest(Protest protest) {
    _protest = protest;
    notifyListeners();
  }

  set isAttending(AttendingStatus attStatues) {
    _isAttending = attStatues;
    notifyListeners();
  }

  void initIsAttending(BuildContext context) async {
    if (await context.read<DataProvider>().isAlreadyAttending(protest.id)) {
      isAttending = AttendingStatus.attending;
    } else {
      isAttending = AttendingStatus.notAttending;
    }
  }
}

class ProtestInformationScreen extends StatefulWidget {
  final ProtestHolder protestHolder;

  ProtestInformationScreen({Key? key, required protest})
      : protestHolder = ProtestHolder(protest),
        super(key: key);

  @override
  State<ProtestInformationScreen> createState() =>
      _ProtestInformationScreenState();
}

class _ProtestInformationScreenState extends State<ProtestInformationScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final TextEditingController _contentController;

  late final TabBar _tabs;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _tabs = TabBar(
      controller: _tabController,
      labelColor: purple,
      unselectedLabelColor: blue,
      indicatorColor: purple,
      tabs: const [
        Tab(
          text: 'Details',
        ),
        Tab(
          text: 'Stories',
        ),
        Tab(
          text: 'Updates',
        )
      ],
    );
    _contentController = TextEditingController();
    widget.protestHolder.addListener(() => setState(() {}));
    widget.protestHolder.initIsAttending(context);
  }

  @override
  void dispose() {
    _contentController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var dataProvider = context.read<DataProvider>();
    var protest = widget.protestHolder.protest;
    var isCreator = protest.isCreator(context
        .read<AuthProvider>()
        .user
        ?.uid);
    return Scaffold(
      floatingActionButton: _tabController.index == 0
          ? isCreator
          ? null
          : (widget.protestHolder.isAttending == AttendingStatus.unKnown)
          ? const SizedBox()
          : (widget.protestHolder.isAttending !=
          AttendingStatus.notAttending)
          ? Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton.extended(
          backgroundColor: purple,
          label: const Text('Leave'),
          icon: const Icon(Icons.person_remove),
          onPressed: widget.protestHolder.isAttending ==
              AttendingStatus.attending
              ? () async {
            widget.protestHolder.isAttending =
                AttendingStatus.leaving;
            await dataProvider.leaveProtest(
                protest.id, widget.protestHolder);
            widget.protestHolder.isAttending =
                AttendingStatus.notAttending;
            //Unsubscribe to the topic
            FirebaseMessaging.instance
                .unsubscribeFromTopic(widget
                .protestHolder.protest.id
                .toString());
            Future.delayed(
                Duration.zero,
                    () =>
                    context
                        .read<NavigationProvider>()
                        .notifyScreens());
          }
              : () => {},
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton.extended(
          backgroundColor: purple,
          label: const Text('Join'),
          icon: const Icon(Icons.person_add),
          onPressed: widget.protestHolder.isAttending ==
              AttendingStatus.notAttending
              ? () async {
            widget.protestHolder.isAttending =
                AttendingStatus.joining;
            await dataProvider.joinToProtest(
                protest.id, widget.protestHolder);
            widget.protestHolder.isAttending =
                AttendingStatus.attending;
            //subscribe to the topic
            FirebaseMessaging.instance.subscribeToTopic(
                widget.protestHolder.protest.id
                    .toString());
            Future.delayed(
                Duration.zero,
                    () =>
                    context
                        .read<NavigationProvider>()
                        .notifyScreens());
          }
              : () => {},
        ),
      )
          : _tabController.index == 1
          ? Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton.extended(
          backgroundColor: purple,
          label: const Text('Add Story'),
          icon: const Icon(Icons.person_add),
          onPressed: () async {
            PersistentNavBarNavigator.pushNewScreen(context,
                screen: UploadContentScreen(
                  protest: protest,
                  contentController: _contentController,
                  uploadMode: UploadMode.story,
                ),
                pageTransitionAnimation:
                PageTransitionAnimation.slideRight,
                withNavBar: false);
            if (_contentController.text != '') {
              _contentController.text = '';
              setState(() {});
            }
          },
        ),
      )
          : isCreator
          ? Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton.extended(
          backgroundColor: purple,
          label: const Text('Post Update'),
          icon: const Icon(Icons.person_add),
          onPressed: () async {
            PersistentNavBarNavigator.pushNewScreen(context,
                screen: UploadContentScreen(
                  protest: protest,
                  contentController: _contentController,
                  uploadMode: UploadMode.update,
                ),
                pageTransitionAnimation:
                PageTransitionAnimation.slideRight,
                withNavBar: false);
            if (_contentController.text != '') {
              _contentController.text = '';
              setState(() {});
            }
          },
        ),
      )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              shadowColor: Colors.transparent,
              expandedHeight: MediaQuery
                  .of(context)
                  .size
                  .width /
                  Protest.imageRatio.ratioX *
                  Protest.imageRatio.ratioY,
              floating: true,
              toolbarHeight: MediaQuery
                  .of(context)
                  .size
                  .height * 0.1,
              leadingWidth: MediaQuery
                  .of(context)
                  .size
                  .width,
              leading: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white70,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child: const BackButton(
                        color: blue,
                      ),
                    ),
                  ),
                ],
              ),
              actions: isCreator
                  ? [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 10.0,
                      ),
                      child: Container(
                        decoration: (BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white70)),
                        child: PopupMenuButton(
                          onSelected: (index) async {
                            switch (index) {
                              case 0:
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: ChangeNotifierProvider<
                                      ProtestHolder>.value(
                                    value: widget.protestHolder,
                                    child: NewProtestScreen(
                                      formStatus: FormStatus.editing,
                                      protest: protest,
                                    ),
                                  ),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                  PageTransitionAnimation.slideRight,
                                ).then((value) =>
                                    context
                                        .read<NavigationProvider>()
                                        .notifyScreens());
                                break;
                              case 1:
                                final formKey = GlobalKey<FormState>();
                                final urlTextController =
                                TextEditingController();
                                showModalBottomSheet<String>(
                                  isScrollControlled: true,
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30.0),
                                        topRight: Radius.circular(30.0)),
                                  ),
                                  builder: (BuildContext context) {
                                    return Form(
                                      key: formKey,
                                      child: Padding(
                                        padding: MediaQuery
                                            .of(context)
                                            .viewInsets,
                                        child: Container(
                                          padding:
                                          const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            children: <Widget>[
                                              CustomTextFormField(
                                                controller:
                                                urlTextController,
                                                keyboardType:
                                                TextInputType.url,
                                                hintText:
                                                'https://www.google.com',
                                                label: 'Link',
                                                autofocus: true,
                                                validator: (value) {
                                                  if (value == null ||
                                                      !Uri
                                                          .parse(value)
                                                          .isAbsolute) {
                                                    return 'Please enter correct url';
                                                  }
                                                  return null;
                                                },
                                                onFieldSubmitted: (_) {
                                                  if (formKey
                                                      .currentState!
                                                      .validate()) {
                                                    var result =
                                                        urlTextController
                                                            .text;
                                                    Navigator.of(context)
                                                        .pop(result);
                                                  }
                                                },
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(
                                                    16.0),
                                                child: CustomButton(
                                                  onPressed: () {
                                                    if (formKey
                                                        .currentState!
                                                        .validate()) {
                                                      var result =
                                                          urlTextController
                                                              .text;
                                                      Navigator.of(
                                                          context)
                                                          .pop(result);
                                                    }
                                                  },
                                                  text: 'Submit',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ).then((value) {
                                  if (value != null) {
                                    dataProvider.addExternalLink(
                                        widget.protestHolder, value);
                                  }
                                });
                                break;
                              case 2:
                                bool? confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                          'Are you sure you want to delete?'),
                                      actionsAlignment:
                                      MainAxisAlignment.end,
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          style: TextButton.styleFrom(
                                              foregroundColor: purple),
                                          child: const Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          style: TextButton.styleFrom(
                                              foregroundColor: purple),
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (confirmed ?? false) {
                                  await dataProvider
                                      .deleteProtest(protest);
                                  Future.delayed(const Duration(), () {
                                    context
                                        .read<NavigationProvider>()
                                        .notifyScreens();
                                    Navigator.of(context).pop();
                                  });
                                }
                                break;
                            // add organizers case:
                              case 3:
                                PersistentNavBarNavigator.pushNewScreen(
                                  context,
                                  screen: Provider<EditorsProvider>(
                                      create: (context) => EditorsProvider(editorsArray: protest.editors, creator: protest.creator, protestId: protest.id),
                                      child: UserSearch(
                                        dataProvider: dataProvider,)),
                                  withNavBar: false,
                                  pageTransitionAnimation:
                                  PageTransitionAnimation.slideRight,
                                ).then((value) =>
                                    context
                                        .read<NavigationProvider>()
                                        .notifyScreens());
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem(
                                value: 0,
                                child: Text('Edit Protest'),
                              ),
                              const PopupMenuItem(
                                value: 3,
                                child: Text('Add Organizers'),
                              ),
                              PopupMenuItem(
                                value: 1,
                                enabled: protest.links.length < 5,
                                child: const Text('Add Link'),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text('Delete',
                                    style: TextStyle(
                                        color: Colors.red[900])),
                              ),
                            ];
                          },
                          icon: const Icon(Icons.more_vert, color: blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ]
                  : null,
              bottom: PreferredSize(
                preferredSize: _tabs.preferredSize,
                child: ColoredBox(color: Colors.white, child: _tabs),
              ),
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: protest.getImageWidget(),
              ),
            ),
          ];
        },
        body: Column(
          children: [
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  ProtestInformationDetailed(
                    protest: protest,
                    isCreator: isCreator,
                    protestHolder: widget.protestHolder,
                  ),
                  ProtestStories(
                    protest: protest,
                    dataProvider: context.read<DataProvider>(),
                    isCreator: isCreator,
                  ),
                  ProtestUpdates(
                    protest: protest,
                    dataProvider: context.read<DataProvider>(),
                    isCreator: isCreator,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
