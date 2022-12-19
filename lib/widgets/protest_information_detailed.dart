import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/utils/add_spaces.dart';

class ProtestInformationDetailed extends StatelessWidget {
  final Protest protest;

  ProtestInformationDetailed({Key? key, required this.protest})
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
            style: TextStyle(
              color: blue,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          addVerticalSpace(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.grey[800]),
                      Text(' ' + protest.location,
                          style: TextStyle(color: Colors.grey[800]))
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.watch_later, color: Colors.grey[800]),
                      Text(
                          ' ' +
                              DateFormat('dd/MM/yyyy kk:mm')
                                  .format(protest.date.toDate()),
                          style: TextStyle(color: Colors.grey[800]))
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.people, color: Colors.grey[800]),
                      protest.participantsAmount != 0
                          ? Text(
                              protest.participantsAmount.toString() +
                                  ' people already joined!',
                              style: TextStyle(color: Colors.grey[800]))
                          : Text(' no participants yet',
                              style: TextStyle(color: Colors.grey[800]))
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.email, color: Colors.grey[800]),
                      Text(' ' + protest.contactInfo,
                          style: TextStyle(color: Colors.grey[800]))
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                  ),
                  //TODO: insert protest creator name here:
                  Text('Insert Name'),
                ],
              )
            ],
          ),
          addVerticalSpace(height: 10),
          Divider(
            thickness: 2,
          ),
          addVerticalSpace(height: 10),
          Text(
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
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      protest.description,
                      style: TextStyle(fontSize: 18, color: darkGray),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
