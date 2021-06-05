import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmman/api/auth_methods.dart';
import 'package:dmman/layouts/home_screen.dart';
import 'package:dmman/layouts/login_screen.dart';
import 'package:dmman/layouts/search_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dmman/provider/user_provider.dart';
import 'package:dmman/provider/image_upload_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthMethods _authMethods = AuthMethods();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ImageUploadProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'DMMan',
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          '/search_screen': (context) => SearchScreen(),
        },
        theme: ThemeData(
          brightness: Brightness.dark,
        ),
        home: FutureBuilder(
          future: _authMethods.getCurrentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasData) {
              return HomeScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
      ),
    );
  }
}
