import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/providers/auth_provider.dart';
import 'package:protestory/providers/data_provider.dart';
import 'package:protestory/widgets/paginator.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with TickerProviderStateMixin {
  late final ScrollController _scrollController = ScrollController();
  late final AnimationController _animationController;
  late final Animation _colorTween;
  double appbarHeight = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.hasClients && appbarHeight != 0) {
        _animationController.value = Curves.easeInOutExpo.transform(
            min(appbarHeight, _scrollController.offset) / appbarHeight);
      }
    });
    _animationController = AnimationController(vsync: this);
    _colorTween =
        ColorTween(begin: blue, end: white).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appbarHeight = MediaQuery.of(context).size.height * 0.6;
    User? currUser = context.read<AuthProvider>().user;
    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) => Stack(
                  children: [
                    Opacity(
                      opacity: _animationController.value,
                      child: Container(
                          color: Colors.white,
                          child: const Text(
                            'Created by me',
                          )),
                    ),
                    Opacity(
                      opacity: 1 - _animationController.value,
                      child: Container(
                          color: Colors.white, child: const Text('Profile')),
                    ),
                  ],
                )),
        backgroundColor: white,
        actions: [
          IconButton(
            onPressed: () => context.read<AuthProvider>().signOut(),
            icon: const Icon(Icons.exit_to_app_outlined),
            color: blue,
          )
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 2 * MediaQuery.of(context).size.height / 5,
            child: SvgPicture.asset(
                'assets/background/login_screen_background.svg',
                alignment: Alignment.topCenter,
                // width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height,
                fit: BoxFit.fill),
          ),
          Paginator(
              queryProvider: QueryChangeListener(
                  context.read<DataProvider>().getMyProtests()),
              scrollController: _scrollController,
              header: SliverAppBar(
                backgroundColor: Colors.transparent,
                expandedHeight: appbarHeight,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  centerTitle: true,
                  title: AnimatedBuilder(
                    animation: _colorTween,
                    builder: (context, child) => AutoSizeText(
                      context.read<AuthProvider>().user?.displayName ??
                          'Anonymous',
                      minFontSize: 36,
                      style: TextStyle(
                          color: _colorTween.value,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  background: FutureBuilder(
                    future: context
                        .read<DataProvider>()
                        .getUserById(userId: currUser!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return LayoutBuilder(
                            builder: (context, constraints) => Center(
                                  child: snapshot.requireData.getAvatarWidget(
                                      radius:
                                          MediaQuery.of(context).size.width *
                                              0.25),
                                ));
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
              onEmpty: const SizedBox()),
        ],
      ),
    );
  }
}
