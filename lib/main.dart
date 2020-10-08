import 'package:blog_app/app_screens/landing_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(BlogApp());

class BlogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Blog App",
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: LandingPage(),
    );
  }
}