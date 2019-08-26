import 'package:flutter/widgets.dart';
import 'package:kinship_mobile/pages/home-page/home-page.dart';
import 'package:kinship_mobile/pages/introduction-page/introduction-page.dart';
import 'package:kinship_mobile/pages/login-page/login-page.dart';

final appRoutes = <String, WidgetBuilder>{
    LoginPage.tag: (context) => LoginPage(),
    HomePage.tag: (context) => HomePage(),
    IntroductionPage.tag: (context) => IntroductionPage(),
};