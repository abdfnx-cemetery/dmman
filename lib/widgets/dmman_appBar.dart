import 'package:flutter/material.dart';
import 'package:dmman/widgets/appBar.dart';
import 'package:dmman/layouts/views/chats/widgets/user_circle.dart';

class DMManAppBar extends StatelessWidget implements PreferredSizeWidget {
  final title;
  final List<Widget> actions;

  const DMManAppBar({
    Key key,
    @required this.title,
    @required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.notifications,
          color: Colors.white,
        ),
        onPressed: () {},
      ),
      title: (title is String)
          ? Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          : title,
      centerTitle: true,
      actions: actions,
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}