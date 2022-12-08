import 'package:flutter/material.dart';

import '../constants/colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: blue));
  }
}

class BusyChildWidget extends StatelessWidget {
  final Widget child;
  final Widget loadingWidget;
  final bool loading;

  const BusyChildWidget({
    Key? key,
    required this.child,
    required this.loading,
    Widget? loadingWidget,
  })  : loadingWidget = loadingWidget ?? const LoadingWidget(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: loading ? 0.8 : 1.0,
          child: AbsorbPointer(
            absorbing: loading,
            child: child,
          ),
        ),
        Opacity(
          opacity: loading ? 1.0 : 0,
          child: loadingWidget,
        ),
      ],
    );
  }
}
