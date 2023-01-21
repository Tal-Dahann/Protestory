import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:protestory/providers/editors_provider.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:provider/provider.dart';

import '../firebase/user.dart';
import '../providers/data_provider.dart';

class PaginatorUsers extends StatefulWidget {
  final Widget? header;
  final Widget onEmpty;
  final QueryChangeListener<PUser> queryProvider;
  final ScrollController? scrollController;
  final DataProvider dataProvider;

  const PaginatorUsers(
      {required this.queryProvider,
      Key? key,
      required this.header,
      required this.onEmpty,
      this.scrollController,
      required this.dataProvider})
      : super(key: key);

  @override
  State<PaginatorUsers> createState() => _PaginatorUsersState();
}

class _PaginatorUsersState extends State<PaginatorUsers> {
  @override
  Widget build(BuildContext context) {
    var editorsArray = context.read<EditorsProvider>().editorsArray;
    var creator = context.read<EditorsProvider>().creator;
    log(editorsArray.toString());
    return PaginateFirestore(
      header: widget.header,
      onEmpty: widget.onEmpty,
      queryProvider: widget.queryProvider,
      isLive: true,
      scrollController: widget.scrollController,
      itemBuilder: (context, documentSnapshots, index) {
        final data = documentSnapshots[index].data() as PUser;
        if (creator == data.id) {
          return SizedBox();
        }
        bool currUserIsEditor = false;
        if (editorsArray.contains(data.id)) {
          currUserIsEditor = true;
        }
        return Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  if (currUserIsEditor) {
                    context.read<EditorsProvider>().editorsArray.remove(data.id);
                  } else {
                    context.read<EditorsProvider>().editorsArray.add(data.id);
                  }
                  setState(() {
                    currUserIsEditor = !currUserIsEditor;
                  });
                },
                child: Row(
                  children: [
                    Icon(currUserIsEditor ? Icons.check_box_outlined : Icons.check_box_outline_blank),
                    addHorizontalSpace(width: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        FutureBuilder(
                            future: context
                                .read<DataProvider>()
                                .getUserById(userId: data.id),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return snapshot.requireData.getAvatarWidget(radius: 20);
                              }
                              return PUser.getAvatarLoadingWidget(radius: 20);
                            }),
                        addHorizontalSpace(width: 10),
                        Container(
                          alignment: Alignment.center,
                          constraints: const BoxConstraints(minHeight: 50),
                          child: AutoSizeText(
                            data.username,
                            minFontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              addVerticalSpace(height: 10),
            ],
          ),
        );
      },
    );
  }
}
