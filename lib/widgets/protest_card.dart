import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protestory/firebase/protest.dart';

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //protest just for testing

    var protesTest = Protest(
        id: "2",
        name: "name of protest",
        date: Timestamp.now(),
        creator: "creator",
        creationTime: Timestamp.now(),
        participantsAmount: 0,
        contactInfo: "contactInfo",
        description: "description",
        location: "location",
        tags: []);

    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: ListView.separated(
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) => Divider(
          color: Colors.white60,
        ),
        itemBuilder: (BuildContext context, int index) {
          return ProtestCard(protest: protesTest);
        },
      ),
    );
  }
}

class ProtestCard extends StatelessWidget {
  Protest protest;

  ProtestCard({required this.protest, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = protest.date.toDate();
    return Container(
      //   height: MediaQuery.of(context).size.height * 0.35,
      width: MediaQuery.of(context).size.width * 0.6,
      child: Card(
        elevation: 14,
        // shadowColor: Colors.black,
        // color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: InkWell(
          onTap: () {
            //print("t");
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 8,
                //fit: ,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Ink.image(
                        image: AssetImage('assets/images/tree-736885__480.jpg'),

                        //height: MediaQuery.of(context).size.height * 0.2,
                        fit: BoxFit.fill),
                  ],
                ),
              ),
              Flexible(
                flex: 3,
                child: Text(
                  protest.name,
                  style: const TextStyle(
                    fontSize: 25.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: ListTile(
                  leading: Icon(Icons.place),
                  title: Text(
                    protest.location,
                    style: const TextStyle(
                      fontSize: 15.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: ListTile(
                  leading: Icon(Icons.access_time_rounded),
                  title: Text(protest.dateAndTime(),
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      )),
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Text(protest.participantsAmount.toString(),
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.grey,
                      )),
                  Icon(Icons.people),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
