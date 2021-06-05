import 'package:flutter/material.dart';
import 'package:dmman/models/user.dart';
import 'package:dmman/widgets/tile.dart';
import 'package:dmman/api/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dmman/layouts/chat/chat_screen.dart';
import 'package:dmman/utils/universal_variables.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AuthMethods _authMethods = AuthMethods();
  List<User> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _authMethods.getCurrentUser().then((FirebaseUser user) {
      _authMethods.fetchAllUsers(user).then((List<User> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    return GradientAppBar(
      gradient: LinearGradient(
        colors: [
          UniversalVariables.pc,
          UniversalVariables.pc,
        ],
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: UniversalVariables.black,
            autofocus: true,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 35,
                fontFamily: "OS"),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.cleaning_services, color: Colors.white),
                onPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Color(0x88ffffff),
                  fontFamily: "Sen"),
            ),
          ),
        ),
      ),
    );
  }

  buildSuggs(String query) {
    final List<User> suggestionList = query.isEmpty
        ? []
        : userList.where((User user) {
            String _getUsername = user.username.toLowerCase();
            String _query = query.toLowerCase();
            String _getName = user.name.toLowerCase();
            bool matchesUsername = _getUsername.contains(_query);
            bool matchesName = _getName.contains(_query);

            return (matchesUsername || matchesName);

            // (User user) => (user.username.toLowerCase().contains(query.toLowerCase()) ||
            //     (user.name.toLowerCase().contains(query.toLowerCase()))),
          }).toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: ((context, index) {
        User searchedUser = User(
            uid: suggestionList[index].uid,
            profilePhoto: suggestionList[index].profilePhoto,
            name: suggestionList[index].name,
            username: suggestionList[index].username);

        return CustomTile(
          mini: false,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatScreen(
                          rec: searchedUser,
                        )));
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(searchedUser.profilePhoto),
            backgroundColor: Colors.grey,
          ),
          title: Text(
            searchedUser.username,
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Sen",
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            searchedUser.name,
            style: TextStyle(color: UniversalVariables.grey, fontFamily: "Sen"),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggs(query),
      ),
    );
  }
}
