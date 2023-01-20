import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:protestory/utils/exceptions.dart';
import 'package:protestory/widgets/buttons.dart';
import 'package:protestory/widgets/loading.dart';
import 'package:protestory/widgets/text_fields.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  static const _invalidEmailMessage = 'Invalid email';

  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _displayNameErrorMessage;
  String? _emailErrorMessage;
  String? _passwordErrorMessage;
  bool _loading = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleGoogleLogin(BuildContext context) async {
    try {
      setState(() {
        _loading = true;
      });
      await context.read<AuthProvider>().signInGoogle();
    } on FirebaseAuthException {
      ProtestoryException.showExceptionSnackBar(context);
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _handleSignUp(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    try {
      setState(() {
        _loading = true;
      });
      await context.read<AuthProvider>().signUp(_emailController.text,
          _passwordController.text, _displayNameController.text);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          setState(() {
            _emailErrorMessage = _invalidEmailMessage;
          });
          break;
        case 'email-already-in-use':
          setState(() {
            _emailErrorMessage = 'Email already used, try another one';
          });
          break;
        case 'weak-password':
          setState(() {
            _passwordErrorMessage = 'Weak password';
          });
          break;
        case 'network-request-failed':
          setState(() {
            _emailErrorMessage = 'Network error. Try later';
          });
          break;
        default:
          ProtestoryException.showExceptionSnackBar(context);
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
                    'assets/background/signup_screen_background.svg',
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
                        flex: 20,
                        child: Column(
                          children: [
                            Flexible(
                                flex: 3,
                                child: Column(
                                  children: const [
                                    Expanded(
                                      flex: 3,
                                      child: SizedBox(),
                                    ),
                                    Flexible(
                                      flex: 3,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 25.0),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Hero(
                                              tag: 'title',
                                              child: Material(
                                                color: Colors.transparent,
                                                child: Text('Sign Up',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 50,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            )),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: SizedBox(),
                                    ),
                                  ],
                                )),
                            Flexible(
                                flex: 7,
                                child: Column(
                                  children: [
                                    CustomTextFormField(
                                      label: 'Display Name',
                                      hintText: 'Hadar Muhtar',
                                      errorText: _displayNameErrorMessage,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      textInputAction: TextInputAction.next,
                                      controller: _displayNameController,
                                      validator: (displayName) {
                                        if (displayName == null ||
                                            displayName.isEmpty) {
                                          return 'Name is required';
                                        }
                                        return null;
                                      },
                                      maxLength: 20,
                                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                      onChanged: (_) => setState(() {
                                        _displayNameErrorMessage = null;
                                      }),
                                    ),
                                    addVerticalSpace(height: 5),
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
                                          textInputAction: TextInputAction.next,
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
                                          textInputAction: TextInputAction.next,
                                          controller: _passwordController,
                                          validator: (password) {
                                            if (password == null ||
                                                password == '') {
                                              return 'Enter password';
                                            }
                                            return null;
                                          },
                                          obscureText: true,
                                          onChanged: (_) => setState(() {
                                            _passwordErrorMessage = null;
                                          }),
                                        ),
                                      ),
                                    ),
                                    addVerticalSpace(height: 5),
                                    CustomTextFormField(
                                      label: 'Confirm password',
                                      hintText: 'Re-Enter Password',
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      textInputAction: TextInputAction.done,
                                      validator: (confirm) {
                                        if (confirm !=
                                            _passwordController.text) {
                                          return "Passwords don't match";
                                        }
                                        return null;
                                      },
                                      obscureText: true,
                                      onFieldSubmitted: (_) =>
                                          _handleSignUp(context),
                                    ),
                                  ],
                                )),
                            Flexible(
                              flex: 1,
                              child: Hero(
                                tag: 'signup_button',
                                child: CustomButton(
                                    text: 'Sign Up',
                                    onPressed: () => _handleSignUp(context)),
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
                              style: TextStyle(color: darkGray, fontSize: 18),
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
                                  svgLogoPath: 'assets/icons/google_icon.svg',
                                  onPressed: () => _handleGoogleLogin(context),
                                ),
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
