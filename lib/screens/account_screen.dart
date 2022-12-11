import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase/auth_notifier.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      onPressed: context.read<AuthNotifier>().signOut,
      child:
          Text("Logout from ${context.read<AuthNotifier>().user?.displayName}"),
    ));
  }
}
