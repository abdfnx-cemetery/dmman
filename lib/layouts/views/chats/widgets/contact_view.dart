import 'last_msg_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmman/models/user.dart';
import 'package:dmman/widgets/tile.dart';
import 'package:dmman/models/contact.dart';
import 'package:dmman/utils/progress.dart';
import 'package:dmman/api/auth_methods.dart';
import 'package:dmman/api/chat_methods.dart';
import 'package:dmman/widgets/cached_image.dart';
import 'package:dmman/provider/user_provider.dart';
import 'package:dmman/layouts/chat/chat_screen.dart';
import 'package:dmman/layouts/views/chats/widgets/online_dot_indicator.dart';

class ContactView extends StatelessWidget {
  final Contact contact;
  final AuthMethods _authMethods = AuthMethods();

  ContactView(this.contact);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: _authMethods.getUserDetailsById(contact.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;

          return ViewLayout(
            contact: user,
          );
        }

        return Center(
          child: circularProgress(),
        );
      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final User contact;
  final ChatMethods _chatMethods = ChatMethods();

  ViewLayout({@required this.contact});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(
                    rec: contact,
                  ))),
      title: Text(
        contact?.name ?? "..",
        style: TextStyle(fontFamily: "Inter", fontSize: 19),
      ),
      subtitle: LastMsgContainer(
        stream: _chatMethods.fetchLastMsgBetween(
            senId: userProvider.getUser.uid, recId: contact.uid),
      ),
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(
              uid: contact.uid,
            ),
          ],
        ),
      ),
    );
  }
}
