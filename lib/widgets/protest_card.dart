import 'package:flutter/material.dart';
import 'package:protestory/firebase/protest.dart';

final roundedProtestCardBorder =
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));

class ProtestCard extends StatelessWidget {
  static const ratio = 1;
  final Protest protest;
  final ShapeBorder? shape;
  final double height;
  final double width;

  const ProtestCard(
      {super.key,
      required this.protest,
      this.shape,
      required this.height,
      required this.width});

  const ProtestCard.byHeight(
      {super.key, required this.protest, this.shape, required this.height})
      : width = height * ratio;

  const ProtestCard.byWidth(
      {super.key, required this.protest, this.shape, required this.width})
      : height = width * (1 / ratio);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: shape,
        child: InkWell(
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
                        image: const AssetImage(
                            'assets/images/tree-736885__480.jpg'),

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
                  leading: const Icon(Icons.place),
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
                  leading: const Icon(Icons.access_time_rounded),
                  title: Text(protest.dateAndTime(),
                      style: const TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey,
                      )),
                ),
              ),
              Flexible(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(protest.participantsAmount.toString(),
                        style: const TextStyle(
                          fontSize: 15.0,
                          color: Colors.grey,
                        )),
                    const Padding(
                      padding: EdgeInsets.only(right: 10.0, bottom: 10),
                      child: Icon(Icons.people),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
