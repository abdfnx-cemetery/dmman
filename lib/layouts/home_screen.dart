import 'package:dmman/layouts/views/logs/log_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:dmman/api/auth_methods.dart';
import 'package:dmman/contents/user_state.dart';
import 'package:dmman/provider/user_provider.dart';
import 'package:dmman/utils/universal_variables.dart';
import 'package:dmman/api/local_db/repo/log_repo.dart';
import 'package:dmman/layouts/call/pickup/pickup_layout.dart';
import 'package:dmman/layouts/views/chats/chat_list_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController;
  int _page = 0;

  final AuthMethods _authMethods = AuthMethods();

  UserProvider userProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);

      await userProvider.refreshUser();

      _authMethods.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.ONLINE,
      );

      LogRepo.init(
        isHive: false,
        dbName: userProvider.getUser.uid,
      );
    });

    WidgetsBinding.instance.addObserver(this);

    pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
        (userProvider != null && userProvider.getUser != null)
            ? userProvider.getUser.uid
            : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.ONLINE)
            : print("resume state");
        break;

      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.OFFLINE)
            : print("inactive state");
        break;

      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.WAITING)
            : print("paused state");
        break;

      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
                userId: currentUserId, userState: UserState.OFFLINE)
            : print("detached state");
        break;
    }
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: UniversalVariables.black,
        body: Center(
          child: PageView(
            children: <Widget>[
              ChatListView(),
              LogScreen(),
              Center(
                child: Text(
                  "Contact Screen",
                  style: TextStyle(fontFamily: "Sen", color: Colors.white),
                ),
              ),
            ],
            controller: pageController,
            onPageChanged: onPageChanged,
            // physics: NeverScrollableScrollPhysics(),
          ),
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.all(7),
            child: CupertinoTabBar(
              backgroundColor: UniversalVariables.black,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.chat,
                      color: (_page == 0)
                          ? UniversalVariables.pc
                          : UniversalVariables.grey,
                    ),
                    title: Text(
                      "Chats",
                      style: TextStyle(
                          fontFamily: "Sen",
                          fontSize: 11,
                          color: (_page == 0)
                              ? UniversalVariables.blue
                              : UniversalVariables.grey),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.call,
                      color: (_page == 1)
                          ? UniversalVariables.pc
                          : UniversalVariables.grey,
                    ),
                    title: Text(
                      "Calls",
                      style: TextStyle(
                          fontFamily: "Sen",
                          fontSize: 11,
                          color: (_page == 1)
                              ? UniversalVariables.blue
                              : UniversalVariables.grey),
                    )),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.contact_phone,
                      color: (_page == 2)
                          ? UniversalVariables.pc
                          : UniversalVariables.grey,
                    ),
                    title: Text(
                      "Contacts",
                      style: TextStyle(
                          fontFamily: "Sen",
                          fontSize: 11,
                          color: (_page == 2)
                              ? UniversalVariables.blue
                              : UniversalVariables.grey),
                    )),
              ],
              onTap: navTapped,
              currentIndex: _page,
            ),
          ),
        ),
      ),
    );
  }
}
