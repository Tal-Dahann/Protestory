import 'package:flutter/material.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/widgets/loading.dart';
import 'package:protestory/widgets/navigation.dart';

class UploadingProtestScreen extends StatefulWidget {
  const UploadingProtestScreen({Key? key}) : super(key: key);

  @override
  State<UploadingProtestScreen> createState() => _UploadingProtestScreenState();
}

class _UploadingProtestScreenState extends State<UploadingProtestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        title: const Text('New Protest - Uploading...', style: navTitleStyle),
        backgroundColor: white,
        centerTitle: true,
      ),
      body: const Align(alignment: Alignment.center, child: LoadingWidget()),
    );
  }
}
