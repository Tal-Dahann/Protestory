import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:protestory/firebase/auth_notifier.dart';
import 'package:protestory/firebase/data_provider.dart';
import 'package:protestory/screens/create_new_protest_screen.dart';
import 'package:protestory/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(FirebaseInit());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var app = MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (context.watch<AuthNotifier>().isAuthenticated())
          ? const MainPage()
          : const LoginPage(),
    );
    if (context.read<AuthNotifier>().isAuthenticated()) {
      return ProxyProvider<AuthNotifier, DataProvider>(
        create: (ctx) => DataProvider(user: ctx.read<AuthNotifier>().user!),
        update: (_, myAuthNotifier, myDataProvider) =>
            (myDataProvider?..updateUser(myAuthNotifier.user)) ??
            DataProvider(user: myAuthNotifier.user!),
        child: app,
      ); // TODO replace
    } else {
      return app;
    }
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // const TestAppDana(),
            ElevatedButton(
              onPressed: context.read<AuthNotifier>().signOut,
              child: Text(
                  "Logout from ${context.read<AuthNotifier>().user?.displayName}"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const NewProtestScreen())),
              child: const Text('Add Protest'),
            ),
          ],
        ),
      ),
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
              create: (_) => AuthNotifier(), child: const App());
        }

        //TODO replace with splash screen
        return Container();
      },
    );
  }
}
