import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/firebase/auth_notifier.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:protestory/widgets/buttons.dart';
import 'package:protestory/widgets/navigation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:protestory/firebase/data_provider.dart';
import 'package:protestory/firebase/user.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    User? currUser = context.read<AuthNotifier>().user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: navTitleStyle),
        backgroundColor: white,
      ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 2 * MediaQuery.of(context).size.height / 5,
            child: SvgPicture.asset(
                'assets/background/login_screen_background.svg',
                alignment: Alignment.topCenter,
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: context
                      .read<DataProvider>()
                      .getUserById(userId: currUser!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      PUser creator = snapshot.requireData;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          addVerticalSpace(height: 40),
                          creator.getAvatarWidget(
                              radius: MediaQuery.of(context).size.width * 0.25),
                          addVerticalSpace(height: 20),
                          AutoSizeText(
                            creator.username,
                            minFontSize: 36,
                            style: const TextStyle(
                                color: blue, fontWeight: FontWeight.bold),
                          ),
                          addVerticalSpace(height: 50),
                          CustomButton(
                            color: Colors.white,
                            textColor: purple,
                            width: MediaQuery.of(context).size.width * 0.8,
                            text: 'Logout from ${currUser.displayName}',
                            onPressed: context.read<AuthNotifier>().signOut,
                          )
                        ],
                      );
                    }
                    return Container();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
    //   Center(
    //     child: ElevatedButton(
    //   onPressed: context.read<AuthNotifier>().signOut,
    //   child:
    //       Text("Logout from ${context.read<AuthNotifier>().user?.displayName}"),
    // ));
  }
}
