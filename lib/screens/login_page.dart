import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/utils/add_spaces.dart';
//import 'package:protestory/constants/colors.dart';
import 'package:protestory/widgets/buttons.dart';
import 'package:protestory/widgets/loading.dart';
import 'package:protestory/widgets/text_fields.dart';
import 'package:provider/provider.dart';

import '../firebase/auth_notifier.dart';

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
              Form(
                key: _formKey,
                child: Column(
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
                      child: addVerticalSpace(height: 40),
                    ),
                    CustomTextFormField(
                      label: 'Email',
                      hintText: 'user@example.com',
                      errorText: _emailErrorMessage,
                      keyboardType: TextInputType.emailAddress,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      controller: _emailController,
                      validator: (email) {
                        if (email == null || !EmailValidator.validate(email)) {
                          return _invalidEmailMessage;
                        }
                        return null;
                      },
                      onChanged: (_) => setState(() {
                        _emailErrorMessage = null;
                      }),
                    ),
                    Flexible(flex: 1, child: addVerticalSpace(height: 20)),
                    CustomTextFormField(
                      label: 'Password',
                      hintText: 'Password',
                      errorText: _passwordErrorMessage,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.done,
                      controller: _passwordController,
                      validator: (password) {
                        if (password == null || password == "") {
                          return "Enter password";
                        }
                        return null;
                      },
                      obscureText: true,
                      onFieldSubmitted: (_) => _handleEmailLogin(context),
                      onChanged: (_) => setState(() {
                        _passwordErrorMessage = null;
                      }),
                    ),
                    Flexible(flex: 1, child: addVerticalSpace(height: 40)),
                    Flexible(
                      flex: 1,
                      child: CustomButton(
                        onPressed: () => _handleEmailLogin(context),
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
                          Text(
                            'sign in via',
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
                        onPressed: () => _handleGoogleLogin(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
