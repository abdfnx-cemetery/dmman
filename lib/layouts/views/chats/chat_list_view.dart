import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './widgets/new_chat_button.dart';
import 'package:dmman/utils/progress.dart';
import 'package:dmman/models/contact.dart';
import 'package:dmman/api/chat_methods.dart';
import 'package:dmman/widgets/quiet_box.dart';
import 'package:dmman/widgets/dmman_appBar.dart';
import 'package:dmman/provider/user_provider.dart';
import 'package:dmman/utils/universal_variables.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dmman/layouts/call/pickup/pickup_layout.dart';
import 'package:dmman/layouts/views/chats/widgets/user_circle.dart';
import 'package:dmman/layouts/views/chats/widgets/contact_view.dart';

class ChatListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.black,
        appBar: DMManAppBar(
          title: UserCircle(),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/search_screen");
              },
            ),
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
        floatingActionButton: NewChatButton(),
        body: ChatListContainer(),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      color: UniversalVariables.black,
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(userId: userProvider.getUser.uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.documents;

              if (docList.isEmpty) {
                return QuietBox();
              }

              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data);

                  return ContactView(contact);
                },
              );
            }

            return Center(child: circularProgress());
          }),
    );
  }
}
