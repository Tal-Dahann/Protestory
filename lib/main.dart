import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:protestory/firebase/auth_notifier.dart';
import 'package:protestory/firebase/data_provider.dart';
import 'package:protestory/screens/create_new_protest_screen.dart';
import 'package:protestory/screens/login_page.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class PreMainScreen extends StatelessWidget {
  const PreMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthNotifier>().isAuthenticated()) {
      return ProxyProvider<AuthNotifier, DataProvider>(
        create: (ctx) => DataProvider(user: ctx.read<AuthNotifier>().user!),
        update: (_, myAuthNotifier, myDataProvider) =>
            (myDataProvider?..updateUser(myAuthNotifier.user)) ??
            DataProvider(user: myAuthNotifier.user!),
        child: Scaffold(
          body: Column(children: [
            // const TestAppDana(),
            ElevatedButton(
                onPressed: context.read<AuthNotifier>().signOut,
                child: const Text("Logout")),
          ]),
        ),
      ); // TODO replace
    } else {
      return const NewProtestScreen();
    }
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseInit(),
    );
  }
}

class FirebaseInit extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  FirebaseInit({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text(snapshot.error.toString(),
                      textDirection: TextDirection.ltr)));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
              create: (_) => AuthNotifier(), child: const PreMainScreen());
        }

        //TODO replace with splash screen
        return Container();
      },
    );
  }
}
