import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/screens/protest_information_screen.dart';

import '../utils/add_spaces.dart';

enum ProtestCardTypes { mainScreen, wholeScreen }

class ProtestCard extends StatelessWidget {
  final Protest protest;
  late final ShapeBorder? shape;
  late final double cardRatio;

  ProtestCard(
      {super.key, required this.protest, required ProtestCardTypes type}) {
    switch (type) {
      case ProtestCardTypes.mainScreen:
        cardRatio = 15 / 16;
        shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
        break;
      case ProtestCardTypes.wholeScreen:
        cardRatio = 1 / 1;
        shape = null;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: cardRatio,
      child: InkWell(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
          //Navigator.push(context, MaterialPageRoute(builder: (ctx) => ProtestInformationScreen(protest: protest)));
          PersistentNavBarNavigator.pushNewScreen(context,
              screen: ProtestInformationScreen(protest: protest),
              pageTransitionAnimation: PageTransitionAnimation.slideUp);
          // p.push(
          //   PageTransition(
          //       type: PageTransitionType.fade,
          //       duration: const Duration(milliseconds: 400),
          //       reverseDuration: const Duration(milliseconds: 300),
          //       child: ProtestInformationScreen(protest: protest)),
          // );
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
            elevation: 2,
            clipBehavior: Clip.antiAlias,
            shape: shape,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    protest.getImageWidget(),
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 5.0, right: 5.0, top: 5.0),
                        child: AutoSizeText(
                          protest.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Column(
                          children: [
                            // Location:
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.location_on,
                                      color: Colors.grey[800]),
                                  addHorizontalSpace(width: 4),
                                  Expanded(
                                    child: AutoSizeText(protest.location,
                                        minFontSize: 15.0,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            TextStyle(color: Colors.grey[800])),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.watch_later_outlined,
                                      color: Colors.grey[800]),
                                  addHorizontalSpace(width: 4),
                                  Expanded(
                                    child: AutoSizeText(protest.dateAndTime(),
                                        minFontSize: 15.0,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style:
                                            TextStyle(color: Colors.grey[800])),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(protest.participantsAmount.toString(),
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.grey,
                                      )),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 2.0, right: 8.0),
                                    child: Icon(Icons.people),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
