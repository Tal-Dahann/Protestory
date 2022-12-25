import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/firebase/auth_notifier.dart';
import 'package:protestory/screens/signup_screen.dart';
import 'package:protestory/utils/add_spaces.dart';
//import 'package:protestory/constants/colors.dart';
import 'package:protestory/widgets/buttons.dart';
import 'package:protestory/widgets/loading.dart';
import 'package:protestory/widgets/text_fields.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const _invalidEmailMessage = 'Invalid email';

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailErrorMessage;
  String? _passwordErrorMessage;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleLogin(BuildContext context) async {
    try {
      setState(() {
        _loading = true;
      });
      await context.read<AuthNotifier>().signInGoogle();
    } on FirebaseAuthException catch (e) {
      // TODO replace with snackbar?
      log(e.message ?? "Unknown error");
      setState(() {
        _emailErrorMessage = 'Unknown error. Try later';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _handleEmailLogin(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    try {
      setState(() {
        _loading = true;
      });
      await context
          .read<AuthNotifier>()
          .signInEmailPassword(_emailController.text, _passwordController.text);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          setState(() {
            _emailErrorMessage = _invalidEmailMessage;
          });
          break;
        case 'user-disabled':
          setState(() {
            _emailErrorMessage = 'User is disabled';
          });
          break;
        case 'user-not-found':
          setState(() {
            _emailErrorMessage = 'User not found. Sign up?';
          });
          break;
        case 'wrong-password':
          setState(() {
            _passwordErrorMessage = 'Wrong password';
          });
          break;
        case 'network-request-failed':
          setState(() {
            _emailErrorMessage = 'Network error. Try later';
          });
          break;
        default:
          // TODO replace with snackbar?
          log(e.message ?? "Unknown error");
          setState(() {
            _emailErrorMessage = 'Unknown error. Try later';
          });
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: BusyChildWidget(
          loading: _loading,
          child: Stack(
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
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, right: 16.0),
                        child: IconButton(
                            icon: const Icon(Icons.info, color: Colors.white),
                            onPressed: () {
                              showAboutDialog(
                                  context: context,
                                  applicationName: 'Protestory',
                                  applicationVersion: '1.0.0',
                                  applicationLegalese:
                                      'Protestory is a convenient and user-friendly app for searching and creating protests around the world.');
                            }),
                      )
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Flexible(
                            flex: 20,
                            child: Column(
                              children: [
                                Flexible(
                                    flex: 4,
                                    child: Column(
                                      children: const [
                                        Expanded(
                                          flex: 3,
                                          child: SizedBox(),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Padding(
                                            padding:
                                                EdgeInsets.only(left: 25.0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Hero(
                                                tag: 'title',
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: Text(
                                                      'Login     ', // we need these spaces.
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 50,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: SizedBox(),
                                        ),
                                      ],
                                    )),
                                Flexible(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        Hero(
                                          tag: 'email_field',
                                          child: Material(
                                            color: Colors.transparent,
                                            child: CustomTextFormField(
                                              label: 'Email',
                                              hintText: 'user@example.com',
                                              errorText: _emailErrorMessage,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              textInputAction:
                                                  TextInputAction.next,
                                              controller: _emailController,
                                              validator: (email) {
                                                if (email == null ||
                                                    !EmailValidator.validate(
                                                        email)) {
                                                  return _invalidEmailMessage;
                                                }
                                                return null;
                                              },
                                              onChanged: (_) => setState(() {
                                                _emailErrorMessage = null;
                                              }),
                                            ),
                                          ),
                                        ),
                                        addVerticalSpace(height: 5),
                                        Hero(
                                          tag: 'password_field',
                                          child: Material(
                                            color: Colors.transparent,
                                            child: CustomTextFormField(
                                              label: 'Password',
                                              hintText: 'Password',
                                              errorText: _passwordErrorMessage,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              textInputAction:
                                                  TextInputAction.done,
                                              controller: _passwordController,
                                              validator: (password) {
                                                if (password == null ||
                                                    password == "") {
                                                  return "Enter password";
                                                }
                                                return null;
                                              },
                                              obscureText: true,
                                              onFieldSubmitted: (_) =>
                                                  _handleEmailLogin(context),
                                              onChanged: (_) => setState(() {
                                                _passwordErrorMessage = null;
                                              }),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                Flexible(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      CustomButton(
                                        onPressed: () =>
                                            _handleEmailLogin(context),
                                        text: 'Login',
                                      ),
                                      addVerticalSpace(height: 10),
                                      Hero(
                                        tag: "signup_button",
                                        child: CustomButton(
                                            text: 'Sign Up',
                                            onPressed: () => Navigator.of(
                                                    context)
                                                .push(PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    duration: const Duration(
                                                        milliseconds: 400),
                                                    reverseDuration:
                                                        const Duration(
                                                            milliseconds: 300),
                                                    child:
                                                        const SignUpPage()))),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        Hero(
                          tag: 'divider',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Expanded(
                                child: Divider(
                                  color: lightGray,
                                  thickness: 2.0,
                                  height: 20,
                                  indent: 40,
                                  endIndent: 8,
                                ),
                              ),
                              Material(
                                child: Text(
                                  'sign in via',
                                  style:
                                      TextStyle(color: darkGray, fontSize: 18),
                                ),
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
                            flex: 6,
                            child: Column(
                              children: [
                                const Expanded(flex: 1, child: SizedBox()),
                                Flexible(
                                  flex: 3,
                                  child: Hero(
                                    tag: 'google_button',
                                    child: CustomButtonWithLogo(
                                      text: 'Google',
                                      color: white,
                                      textColor: black,
                                      svgLogoPath:
                                          'assets/icons/google_icon.svg',
                                      onPressed: () =>
                                          _handleGoogleLogin(context),
                                    ),
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
