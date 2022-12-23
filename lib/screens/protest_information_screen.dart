import 'package:flutter/material.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/widgets/protest_information_detailed.dart';

class ProtestInformationScreen extends StatefulWidget {
  final Protest protest;

  const ProtestInformationScreen({Key? key, required this.protest})
      : super(key: key);

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
  Widget build(BuildContext context) {
    Protest protest = widget.protest;
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
