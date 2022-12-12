import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:protestory/utils/add_spaces.dart';
import 'package:protestory/widgets/text_fields.dart';
import 'package:provider/provider.dart';

import '../constants/colors.dart';
import '../constants/tags.dart';
import '../firebase/data_provider.dart';
import '../firebase/protest.dart';
import '../widgets/paginator.dart';

class SearchScreen extends StatefulWidget {
  final String initDropDownValue;
  const SearchScreen({this.initDropDownValue = 'All', Key? key})
      : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String text = '';

  late String dropDownValue = widget.initDropDownValue;

  @override
  Widget build(BuildContext context) {
    Query<Protest> qry;

    switch (dropDownValue) {
      case 'Most Recent':
        {
          qry = context
              .read<DataProvider>()
              .getProtestCollectionRef
              .orderBy('creation_time', descending: true)
              .where('prefixes_name', arrayContains: text);
        }
        break;
      case 'Most Popular':
        {
          qry = context
              .read<DataProvider>()
              .getProtestCollectionRef
              .orderBy('participants_amount', descending: true)
              .where('prefixes_name', arrayContains: text);
        }
        break;
      default:
        {
          //ALl- sorted by name
          qry = context
              .read<DataProvider>()
              .getProtestCollectionRef
              .orderBy('name', descending: false)
              .where('name', isGreaterThanOrEqualTo: text)
              .where('name', isLessThan: '${text}z');
        }
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search',
            style: TextStyle(color: blue, fontWeight: FontWeight.bold)),
        backgroundColor: white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          addVerticalSpace(height: 15),
          CustomTextFormField(
            icon: const Icon(Icons.search),
            hintText: "Search...",
            onChanged: (searchText) => setState(() {
              text = searchText.toLowerCase();
            }),
            onFieldSubmitted: (searchText) => setState(() {
              text = searchText.toLowerCase();
            }),
          ),
          addVerticalSpace(height: 4),
          DropdownButton<String>(
            // Initial Value
            value: dropDownValue,
            elevation: 10,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: searchFilters.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            // After selecting the desired option,it will
            // change button value to selected value
            onChanged: (String? newValue) {
              setState(() {
                //TODO: when it is null??
                dropDownValue = newValue!;
              });
            },
          ),
          Expanded(child: Paginator(query: qry))
        ],
      ),
    );
    //onFieldSubmitted: ;
  }
}
