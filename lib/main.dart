import 'package:flutter/material.dart';
import 'colors.dart';

import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AppColors appColors = new AppColors();



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: AppColors.appColor,
      ),
      home: HomePage()
    );
  }
}
