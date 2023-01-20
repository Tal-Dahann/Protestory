import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/providers/auth_provider.dart';
import 'package:protestory/providers/data_provider.dart';
import 'package:protestory/providers/search_provider.dart';
import 'package:protestory/screens/login_screen.dart';
import 'package:protestory/widgets/navigation.dart';
import 'package:provider/provider.dart';

import 'firebase/protest.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

int numOfNotifications = 0;

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('icon');
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );
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
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
              foregroundColor: blue,
              backgroundColor: Colors.white,
              titleTextStyle: navTitleStyle)),
      debugShowCheckedModeBanner: false,
      home: (context.watch<AuthProvider>().isAuthenticated())
          ? const MainNavigation()
          : const LoginPage(),
    );
    if (context.read<AuthProvider>().isReady()) {
      FlutterNativeSplash.remove();
    }
    if (context.read<AuthProvider>().isAuthenticated()) {
      return ProxyProvider<AuthProvider, DataProvider>(
        create: (ctx) => DataProvider(ctx.read<AuthProvider>().user!),
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
          //TODO: Added
          FirebaseMessaging.instance.getInitialMessage();
          FirebaseMessaging.onBackgroundMessage(_localNotificationHandler);
          FirebaseMessaging.instance.requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );
          FirebaseMessaging.onMessage.listen(_localNotificationHandler);
          return ChangeNotifierProvider(
              create: (_) => AuthProvider(), child: const App());
        }
        return const SizedBox();
      },
    );
  }
}

Future<void> _localNotificationHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log('Handling a background msg: ${message.messageId}');

  String protestId = message.data["protest_id"];

  Protest protest = await DataProvider.getProtestById(protestId: protestId);

  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
          "com.technion.android.protestory", "Protestory",
          importance: Importance.max,
          priority: Priority.high,
          setAsGroupSummary: true,
          groupKey: protestId);
  NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(numOfNotifications++, protest.name,
      'Update: ${message.data["update_content"]}', notificationDetails);
}
