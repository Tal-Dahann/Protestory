import 'package:flutter/material.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:provider/provider.dart';

import '../firebase/user.dart';
import '../providers/data_provider.dart';

class ProtestInformationDetailed extends StatelessWidget {
  final Protest protest;

  const ProtestInformationDetailed({Key? key, required this.protest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: ListView(
        children: [
          Text(
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
                          child: Text(protest.location,
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
                          child: Text(protest.dateAndTime(),
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
                        protest.participantsAmount != 0
                            ? Expanded(
                                child: Text(
                                    '${protest.participantsAmount} people already joined!',
                                    style: TextStyle(color: Colors.grey[800])),
                              )
                            : Expanded(
                                child: Text('no participants yet',
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
                          child: Text(protest.contactInfo,
                              style: TextStyle(color: Colors.grey[800])),
                        )
                      ],
                    ),
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
                        Text(creator.username),
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
                    label: Text(
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
                  child: Text(
                    protest.description,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              )),
          addVerticalSpace(height: 60),
        ],
      ),
    );
  }
}
