import 'package:flutter/material.dart';
import 'package:protestory/firebase/protest.dart';

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
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    protest.name,
                    style: const TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                    ),
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
                  Padding(padding: EdgeInsets.all(5.0))
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
