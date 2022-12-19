import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/widgets/loading.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/widgets/protest_information_detailed.dart';

class ProtestInformationScreen extends StatefulWidget {
  final Protest protest;

  ProtestInformationScreen({Key? key, required this.protest}) : super(key: key);

  @override
  State<ProtestInformationScreen> createState() =>
      _ProtestInformationScreenState();
}

class _ProtestInformationScreenState extends State<ProtestInformationScreen> {
  static const imageRatio = CropAspectRatio(ratioX: 16, ratioY: 9);

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
            label: Text('Join'),
            icon: Icon(Icons.person_add),
            onPressed: () {},
          ),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              pinned: true,
              shadowColor: Colors.transparent,
              expandedHeight: 240,
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
                      child: BackButton(
                        color: blue,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: AspectRatio(
                  aspectRatio: imageRatio.ratioX / imageRatio.ratioY,
                  child: FutureBuilder<NetworkImage>(
                    future: protest.image,
                    builder: (builder, snapshot) {
                      if (snapshot.hasError) {
                        return Scaffold(
                            body: Center(
                                child: Text(snapshot.error.toString(),
                                    textDirection: TextDirection.ltr)));
                      }
                      if (snapshot.hasData) {
                        return Ink.image(
                            image: snapshot.requireData, fit: BoxFit.fill);
                      }
                      return const LoadingWidget();
                    },
                  ),
                ),
              ),
            ),
            SliverAppBar(
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
                      Container(child: Center(child: Text('Stories here')))
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
