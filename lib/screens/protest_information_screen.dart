import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/firebase/auth_notifier.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/screens/create_new_protest_screen.dart';
import 'package:protestory/widgets/protest_information_detailed.dart';
import 'package:provider/provider.dart';

class ProtestInformationScreen extends StatefulWidget {
  final Protest protest;

  const ProtestInformationScreen({Key? key, required this.protest})
      : super(key: key);

  @override
  State<ProtestInformationScreen> createState() =>
      _ProtestInformationScreenState();
}

class _ProtestInformationScreenState extends State<ProtestInformationScreen> {
  @override
  Widget build(BuildContext context) {
    Protest protest = widget.protest;
    bool isCreator = context.read<AuthNotifier>().user?.uid == protest.creator;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FloatingActionButton.extended(
            backgroundColor: purple,
            label: const Text('Join'),
            icon: const Icon(Icons.person_add),
            onPressed: () {},
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
                                onSelected: (index) {
                                  switch (index) {
                                    case 0:
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: NewProtestScreen(
                                          formStatus:
                                          FormStatus.editing,
                                          protest: protest,
                                        ),
                                        withNavBar: false,
                                        pageTransitionAnimation: PageTransitionAnimation.slideRight,
                                      );
                                      break;
                                    case 1:
                                      //TODO: ADD DELETE PROTEST HERE
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
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: protest.getImageWidget(),
              ),
            ),
            const SliverAppBar(
              pinned: true,
              primary: false,
              automaticallyImplyLeading: false,
              elevation: 8,
              backgroundColor: white,
              title: Align(
                alignment: AlignmentDirectional.center,
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
                ),
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
