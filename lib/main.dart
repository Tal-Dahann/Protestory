import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:protestory/firebase/auth_notifier.dart';
import 'package:protestory/firebase/data_provider.dart';
import 'package:protestory/providers/search_provider.dart';
import 'package:protestory/screens/login_screen.dart';
import 'package:protestory/widgets/navigation.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(FirebaseInit());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var app = MaterialApp(
      title: 'Protestory',
      theme: ThemeData(appBarTheme: const AppBarTheme(color: Colors.white)),
      debugShowCheckedModeBanner: false,
      home: (context.watch<AuthNotifier>().isAuthenticated())
          ? const MainNavigation()
          : const LoginPage(),
    );
    if (context.read<AuthNotifier>().isReady()) {
      FlutterNativeSplash.remove();
    }
    if (context.read<AuthNotifier>().isAuthenticated()) {
      return ProxyProvider<AuthNotifier, DataProvider>(
        create: (ctx) => DataProvider(ctx.read<AuthNotifier>().user!),
        update: (_, myAuthNotifier, myDataProvider) =>
            (myDataProvider?..updateUser(myAuthNotifier.user)) ??
            DataProvider(myAuthNotifier.user!),
        child: ChangeNotifierProvider<SearchPresetsProvider>(
            create: (BuildContext context) => SearchPresetsProvider(),
            child: app),
      );
    } else {
      return app;
    }
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
