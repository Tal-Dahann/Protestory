import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/screens/protest_information_screen.dart';
import 'package:protestory/widgets/loading.dart';

enum ProtestCardTypes { mainScreen, wholeScreen }

class ProtestCard extends StatelessWidget {
  static const imageRatio = CropAspectRatio(ratioX: 16, ratioY: 9);
  final Protest protest;
  late final ShapeBorder? shape;
  late final double cardRatio;

  ProtestCard(
      {super.key, required this.protest, required ProtestCardTypes type}) {
    switch (type) {
      case ProtestCardTypes.mainScreen:
        cardRatio = 3 / 4;
        shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
        break;
      case ProtestCardTypes.wholeScreen:
        cardRatio = 1 / 1;
        shape = null;
        break;
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: cardRatio,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => ProtestInformationScreen(protest: protest)));
        },
        child: Card(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          shape: shape,
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Stack(alignment: AlignmentDirectional.bottomEnd, children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
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
                        child: Column(
                          children: [
                            Flexible(
                              flex: 1,
                              child: ListTile(
                                leading: const Icon(Icons.place),
                                title: AutoSizeText(
                                  protest.location,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.grey,
                                  ),
                                  minFontSize: 15.0,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: ListTile(
                                leading: const Icon(Icons.access_time_rounded),
                                title: Text(protest.dateAndTime(),
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                    )),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 8.0,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(protest.participantsAmount.toString(),
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        )),
                    const Padding(
                      padding: EdgeInsets.only(left: 2.0, right: 8.0),
                      child: Icon(Icons.people),
                    )
                  ],
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
