import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:protestory/utils/add_spaces.dart';
//import 'package:protestory/constants/colors.dart';
import 'package:protestory/widgets/buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 2 * MediaQuery
                  .of(context)
                  .size
                  .height / 5,
              child:
              SvgPicture.asset('assets/background/login_screen_background.svg',
                  alignment: Alignment.topCenter,
                  // width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height,
                  fit: BoxFit.fill),
            ),
            Column(
              children: [
                Flexible(
                  flex: 2,
                  child: addVerticalSpace(
                    height: 100),
                ),
                const Flexible(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 25.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Login',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 50,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: CustomButton(
                    label: 'Login',
                    onPressed: () {
                      log('Pressed Login Button');
                    },
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: addVerticalSpace(
                    height: 10),
                ),
                Flexible(
                  flex: 1,
                  child: CustomButton(
                    label: 'Sign Up',
                    onPressed: () {
                      log('Pressed Sign Up Button');
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
