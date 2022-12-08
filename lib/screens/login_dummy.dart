import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:protestory/firebase/auth_notifier.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  static const _invalidEmailMessage = "Invalid email";

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _emailErrorMessage;
  String? _passwordErrorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _processLogin(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await context
          .read<AuthNotifier>()
          .login(_emailController.text, _passwordController.text);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          setState(() {
            _emailErrorMessage = _invalidEmailMessage;
          });
          break;
        case "user-disabled":
          setState(() {
            _emailErrorMessage = "User is disabled";
          });
          break;
        case "user-not-found":
          setState(() {
            _emailErrorMessage = "User not found. Sign up?";
          });
          break;
        case "wrong-password":
          setState(() {
            _passwordErrorMessage = "Wrong password";
          });
          break;
        case "network-request-failed":
          setState(() {
            _emailErrorMessage = "Network error. Try later";
          });
          break;
        default:
          // TODO replace with snackbar?
          print(e);
          setState(() {
            _emailErrorMessage = "Unknown error. Try later";
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: InputDecoration(
                labelText: "Email",
                hintText: "user@example.com",
                errorText: _emailErrorMessage),
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
          TextFormField(
              decoration: InputDecoration(
                  labelText: "Password", errorText: _passwordErrorMessage),
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
              onFieldSubmitted: (_) => _processLogin(context),
              onChanged: (_) => setState(() {
                    _passwordErrorMessage = null;
                  })),
          ElevatedButton(
              onPressed: () => _processLogin(context),
              child: const Text("Login")),
        ],
      ),
    );
  }
}
