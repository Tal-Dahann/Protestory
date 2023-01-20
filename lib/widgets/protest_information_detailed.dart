import 'dart:math';

import 'package:favicon/favicon.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/screens/protest_information_screen.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:protestory/utils/permissions_helper.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../firebase/user.dart';
import '../providers/data_provider.dart';

class ProtestInformationDetailed extends StatelessWidget {
  final Protest protest;
  final bool isCreator;
  final ProtestHolder protestHolder;

  const ProtestInformationDetailed({Key? key, required this.protest, required this.isCreator, required this.protestHolder})
      : super(key: key);

  Widget _getLocationMap(
      {bool userControl = true, ArgumentCallback<LatLng>? onTap}) {
    return GoogleMap(
        compassEnabled: userControl,
        mapToolbarEnabled: userControl,
        rotateGesturesEnabled: userControl,
        scrollGesturesEnabled: userControl,
        zoomControlsEnabled: userControl,
        zoomGesturesEnabled: userControl,
        myLocationEnabled: userControl,
        onTap: onTap,
        initialCameraPosition:
            CameraPosition(target: protest.locationLatLng, zoom: 11.0),
        markers: {
          Marker(
              markerId: MarkerId(protest.name),
              position: protest.locationLatLng,
              consumeTapEvents: onTap != null,
              onTap: () {
                if (onTap != null) {
                  onTap(protest.locationLatLng);
                }
              },
              infoWindow: InfoWindow(
                  title: protest.locationName,
                  snippet: 'The protest will be right here!'))
        });
  }

  Widget _getExternalUrlsWidget(DataProvider dataProvider) {
    if (protest.links.isEmpty) {
      return const SizedBox();
    }
    var links = <Widget>[];
    for (var url in protest.links) {
      links.add(Padding(
        padding: const EdgeInsets.only(right: 6.0),
        child: SizedBox(
          width: 40,
          height: 40,
          child: FutureBuilder(
              future: FaviconFinder.getBest(url),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return InkWell(
                      onTap: () => launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication),
                      onLongPress: () async {
                        if (!isCreator) {
                          return;
                        }
                        bool? confirmed =
                            await showDialog<bool>(
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
                                    Navigator.pop(
                                        context, false);
                                  },
                                  style: TextButton.styleFrom(
                                      foregroundColor: purple),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(
                                        context, true);
                                  },
                                  style: TextButton.styleFrom(
                                      foregroundColor: purple),
                                  child: const Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                        confirmed ??= false;
                        if (confirmed) {
                          dataProvider.removeExternalLink(protestHolder, url);
                        }
                      },
                      child: Image.network(snapshot.requireData!.url));
                }
                return const Icon(Icons.link);
              }),
        ),
      ));
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: links,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: ListView(
        children: [
          SelectableText(
            protest.name,
            style: const TextStyle(
              color: blue,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          addVerticalSpace(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Colors.grey[800]),
                        addHorizontalSpace(width: 3),
                        Expanded(
                          child: SelectableText(protest.locationName,
                              style: TextStyle(color: Colors.grey[800])),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.watch_later, color: Colors.grey[800]),
                        addHorizontalSpace(width: 3),
                        Expanded(
                          child: SelectableText(protest.dateAndTime(),
                              style: TextStyle(color: Colors.grey[800])),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.people, color: Colors.grey[800]),
                        addHorizontalSpace(width: 3),
                        Expanded(
                          child: Text(
                              (protest.participantsAmount == 0)
                                  ? 'no participants yet'
                                  : '${protest.participantsAmount} ${protest.participantsAmount == 1 ? 'person' : 'people'} already joined!',
                              style: TextStyle(color: Colors.grey[800])),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.email, color: Colors.grey[800]),
                        addHorizontalSpace(width: 3),
                        Expanded(
                          child: SelectableText(protest.contactInfo,
                              style: TextStyle(color: Colors.grey[800])),
                        )
                      ],
                    ),
                    _getExternalUrlsWidget(context.read<DataProvider>())
                  ],
                ),
              ),
              FutureBuilder(
                future: context
                    .read<DataProvider>()
                    .getUserById(userId: protest.creator),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    PUser creator = snapshot.requireData;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        creator.getAvatarWidget(radius: 35),
                        addVerticalSpace(height: 5),
                        SelectableText(creator.username),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              )
            ],
          ),
          addVerticalSpace(height: 10),
          const Divider(
            thickness: 2,
          ),
          addVerticalSpace(height: 20),
          const Text(
            'Tags',
            style: TextStyle(
              color: purple,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          addVerticalSpace(height: 10),
          Wrap(
            spacing: 7,
            children: List<Widget>.generate(
              protest.tags.length,
              (int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  child: Chip(
                    side: const BorderSide(color: lightGray),
                    labelPadding: const EdgeInsets.all(3.0),
                    label: SelectableText(
                      protest.tags[index],
                      style: const TextStyle(color: black, fontSize: 14),
                    ),
                    backgroundColor: white,
                    elevation: 2,
                  ),
                );
              },
            ).toList(),
          ),
          addVerticalSpace(height: 10),
          const Divider(
            thickness: 2,
          ),
          addVerticalSpace(height: 10),
          const Text(
            'Location',
            style: TextStyle(
              color: purple,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          addVerticalSpace(height: 10),
          SizedBox(
            height: min(200.0, MediaQuery.of(context).size.height * 0.2),
            child: _getLocationMap(
                userControl: false,
                onTap: (_) {
                  PersistentNavBarNavigator.pushDynamicScreen(
                    context,
                    withNavBar: false,
                    screen: MaterialPageRoute(
                      builder: (context) => Scaffold(
                        appBar: AppBar(
                          title: Text(
                            '${protest.name} Location',
                          ),
                        ),
                        body: FutureBuilder<void>(
                          future: requestLocationPermission(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return _getLocationMap();
                            }
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                  );
                }),
          ),
          addVerticalSpace(height: 10),
          const Divider(
            thickness: 2,
          ),
          addVerticalSpace(height: 10),
          const Text(
            'Description',
            style: TextStyle(
              color: purple,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          addVerticalSpace(height: 20),
          Material(
              elevation: 4,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SelectableText(
                    protest.description,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              )),
          addVerticalSpace(height: 60),
        ],
      ),
    );
  }
}
