import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/firebase/auth_notifier.dart';
import 'package:protestory/firebase/data_provider.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/providers/navigation_provider.dart';
import 'package:protestory/screens/create_new_protest_screen.dart';
import 'package:protestory/widgets/protest_information_detailed.dart';
import 'package:provider/provider.dart';

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

class _ProtestInformationScreenState extends State<ProtestInformationScreen> {
  static const tabs = TabBar(
    labelColor: purple,
    unselectedLabelColor: blue,
    indicatorColor: purple,
    tabs: [
      Tab(
        text: 'Details',
      ),
      Tab(
        text: 'Stories',
      )
    ],
  );

  @override
  void initState() {
    widget.protestHolder.addListener(() => setState(() {}));
    widget.protestHolder.initIsAttending(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider dataProvider = context.read<DataProvider>();
    Protest protest = widget.protestHolder.protest;
    bool isCreator = context.read<AuthNotifier>().user?.uid == protest.creator;
    // final Future<bool> isAttending =
    //     dataProvider.isAlreadyAttending(protest.id);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: (widget.protestHolder.isAttending ==
                AttendingStatus.unKnown)
            ? Container()
            : (widget.protestHolder.isAttending != AttendingStatus.notAttending)
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FloatingActionButton.extended(
                      backgroundColor: purple,
                      label: const Text('Leave'),
                      icon: const Icon(Icons.person_remove),
                      onPressed: widget.protestHolder.isAttending ==
                          AttendingStatus.attending ? () async {
                        widget.protestHolder.isAttending =
                            AttendingStatus.leaving;
                        await dataProvider.leaveProtest(
                            protest.id, widget.protestHolder);
                        widget.protestHolder.isAttending =
                            AttendingStatus.notAttending;
                        Future.delayed(
                            Duration.zero,
                            () => context
                                .read<NavigationProvider>()
                                .notifyScreens());
                      } : () => {},
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FloatingActionButton.extended(
                      backgroundColor: purple,
                      label: const Text('Join'),
                      icon: const Icon(Icons.person_add),
                      onPressed: widget.protestHolder.isAttending ==
                          AttendingStatus.notAttending ? () async {
                        widget.protestHolder.isAttending =
                            AttendingStatus.joining;
                        await dataProvider.joinToProtest(
                            protest.id, widget.protestHolder);
                        widget.protestHolder.isAttending =
                            AttendingStatus.attending;
                        Future.delayed(
                            Duration.zero,
                            () => context
                                .read<NavigationProvider>()
                                .notifyScreens());
                      } : () => {},
                    ),
                  ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              shadowColor: Colors.transparent,
              expandedHeight: MediaQuery.of(context).size.width /
                  Protest.imageRatio.ratioX *
                  Protest.imageRatio.ratioY,
              floating: true,
              toolbarHeight: MediaQuery.of(context).size.height * 0.1,
              leadingWidth: MediaQuery.of(context).size.width,
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
                                            ProtestHolder>(
                                          create: (_) => widget.protestHolder,
                                          child: NewProtestScreen(
                                            formStatus: FormStatus.editing,
                                            protest: protest,
                                          ),
                                        ),
                                        withNavBar: false,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.slideRight,
                                      ).then((value) => context
                                          .read<NavigationProvider>()
                                          .notifyScreens());
                                      break;
                                    case 1:
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
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    const PopupMenuItem(
                                      value: 0,
                                      child: Text('Edit'),
                                    ),
                                    PopupMenuItem(
                                      value: 1,
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
                preferredSize: tabs.preferredSize,
                child: const ColoredBox(
                    color: Colors.white,
                    child: TabBar(
                      labelColor: purple,
                      unselectedLabelColor: blue,
                      indicatorColor: purple,
                      tabs: [
                        Tab(
                          text: 'Details',
                        ),
                        Tab(
                          text: 'Stories',
                        )
                      ],
                    )),
              ),
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: protest.getImageWidget(),
              ),
            ),
            SliverFillRemaining(
              fillOverscroll: true,
              child: Column(
                children: [
                  Expanded(
                    child: TabBarView(children: [
                      ProtestInformationDetailed(protest: protest),
                      const Center(child: Text('Stories here'))
                    ]),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
