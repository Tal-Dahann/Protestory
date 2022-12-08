import 'package:flutter/material.dart';
import 'package:protestory/widgets/protest_list_home.dart';

class TestAppDana extends StatelessWidget {
  const TestAppDana({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // DataProvider dp = DataProvider();
    //
    // List<Protest> pl = [];
    // User newUser = User(id: "123", username: "username");
    // await dp.userCollectionRef.doc("123").set(newUser);
    // for (int i = 0; i < 5; i++) {
    //   dp.addProtest(
    //       name: "Protest Name" + "${i}",
    //       date: DateTime.now(),
    //       userCreator: newUser,
    //       contactInfo: "",
    //       description: "",
    //       location: "location",
    //       tags: []);
    // }

    return ProtestListHome(protestList: [], maxLengthList: 5);
  }
}
