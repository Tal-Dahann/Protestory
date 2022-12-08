import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/utils/add_spaces.dart';

//import 'package:protestory/constants/colors.dart';
import 'package:protestory/widgets/buttons.dart';
import 'package:protestory/widgets/text_fields.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
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
            Column(
              children: [
                Flexible(
                  flex: 2,
                  child: addVerticalSpace(height: 100),
                ),
                const Flexible(
                  flex: 2,
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
                  child: addVerticalSpace(height: 20),
                ),
                const CustomTextFormField(
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                Flexible(flex: 1, child: addVerticalSpace(height: 20)),
                const CustomTextFormField(
                  label: 'Password',
                  obscureText: true,
                ),
                Flexible(flex: 1, child: addVerticalSpace(height: 40)),
                Flexible(
                  flex: 1,
                  child: CustomButton(
                    onPressed: () {
                      log('Pressed Login Button');
                    },
                    text: 'Login',
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: addVerticalSpace(height: 10),
                ),
                Flexible(
                  flex: 1,
                  child: CustomButton(
                    text: 'Sign Up',
                    onPressed: () {
                      log('Pressed Sign Up Button');
                    },
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: addVerticalSpace(height: 40),
                ),
                Flexible(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: Divider(
                          color: lightGray,
                          thickness: 2.0,
                          height: 20,
                          indent: 40,
                          endIndent: 8,
                        ),
                      ),
                      Text(
                        'sign up via',
                        style: TextStyle(color: darkGray, fontSize: 18),
                      ),
                      Expanded(
                        child: Divider(
                          color: lightGray,
                          thickness: 2.0,
                          height: 20,
                          indent: 8,
                          endIndent: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: addVerticalSpace(height: 50),
                ),
                Flexible(
                  flex: 2,
                  child: CustomButtonWithLogo(
                    text: 'Google',
                    color: white,
                    textColor: black,
                    svgLogoPath: 'assets/icons/google_icon.svg',
                    onPressed: () {
                      log('Clicked sign in with google');
                    },
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
