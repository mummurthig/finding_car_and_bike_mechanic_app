import 'package:userend/app/pages/login_page.dart';
import 'package:userend/app/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:userend/app/pages/login_page.dart';


class AuthFlow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
	    title: 'Service App',
      theme: new ThemeData(
        primaryColor: Colors.deepOrange,
        textSelectionColor: Colors.deepOrange,
        buttonColor: Colors.deepOrange,
	      accentColor: Colors.deepOrange,
	      bottomAppBarColor: Colors.white
      ),
      home: new LoginPage(),
	    routes: {
      	HomePage.routeName: (BuildContext context) => new HomePage()
	    },
    );
  }
}