import 'package:flutter/material.dart';
import 'package:markdown_editor_plus/widgets/markdown_parse.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:provider/provider.dart';

import '../firebase/data_provider.dart';
import '../firebase/user.dart';

class ProtestInformationDetailed extends StatelessWidget {
  final Protest protest;

  const ProtestInformationDetailed({Key? key, required this.protest})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          addVerticalSpace(height: 20),
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
                        const SizedBox(height: 5),
                        Text(creator.username),
                      ],
                    );
                  }
                  return Container();
                },
              )
            ],
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
          Expanded(
            flex: 3,
            child: Material(
                elevation: 4,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MarkdownParse(
                      data: protest.description,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
