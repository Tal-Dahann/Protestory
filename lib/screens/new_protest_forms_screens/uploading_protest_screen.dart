import 'package:flutter/material.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/widgets/loading.dart';

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
        title: const Text('New Protest - Uploading...',
            style: TextStyle(color: blue, fontWeight: FontWeight.bold)),
        backgroundColor: white,
        centerTitle: true,
      ),
      body: const Align(alignment: Alignment.center ,child: LoadingWidget()),
    );
  }
}
