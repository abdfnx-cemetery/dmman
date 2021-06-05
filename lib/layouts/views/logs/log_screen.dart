import 'package:flutter/material.dart';
import 'widgets/log_list_container.dart';
import 'package:dmman/widgets/dmman_appBar.dart';
import 'package:dmman/utils/universal_variables.dart';
import 'package:dmman/layouts/call/pickup/pickup_layout.dart';
import 'package:dmman/layouts/views/logs/widgets/floating_column.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.black,
        appBar: DMManAppBar(
          title: "Calls",
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pushNamed(context, "/search_screen"),
            ),
          ],
        ),
        floatingActionButton: FloatingColumn(),
        body: Padding(
          padding: EdgeInsets.only(left: 15),
          child: LogListContainer(),
        ),
      ),
    );
  }
}