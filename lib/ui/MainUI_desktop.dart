import 'package:fluam_app/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../conf.dart';
import 'lists/main_discuss_list.dart';
import 'widgets/hamburger_scaffold/flutter_hamburger_scaffold.dart';

class MainUIDesktop extends StatefulWidget {
  @override
  _MainUIDesktopState createState() => _MainUIDesktopState();
}

class _MainUIDesktopState extends State<MainUIDesktop> {
  List<HamburgerMenuItem> _menuItems = [
    HamburgerMenuItem('Main', Icons.home, "_main"),
    HamburgerMenuItem('Sites', Icons.apps, "_sites"),
    HamburgerMenuItem('Me', Icons.account_circle, "_me"),
  ];

  int fabStatus = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return HamburgerScaffold(
      backgroundColor: getScaffoldBackground(context),
      appBarTitle: makeTitleText(context, "Fluam"),
      centerTitle: false,
      floatingActionButton: _getFab(context),
      hamburgerMenu: HamburgerMenu(
        onClick: (String value) {
          setState(() {
            if (value == "_main") {
              fabStatus = 0;
            } else {
              fabStatus = -1;
            }
          });
        },
        selectedColor: Colors.blue,
        unselectedColor: Colors.black,
        indicatorColor: Colors.white,
        children: _menuItems,
      ),
      body: MainDiscussList(AppConf.followSites),
    );
  }

  Widget _getFab(BuildContext context) {
    switch (fabStatus) {
      case 0:
        return FloatingActionButton.extended(
          heroTag: "main_fab",
          icon: FaIcon(
            FontAwesomeIcons.pencilAlt,
            color: getTextColor(context),
          ),
          label: makeTitleText(context, "Start a Discussion"),
          onPressed: () {},
          backgroundColor: getAppbarBackGroundColor(context),
        );
      case 1:
        return FloatingActionButton(
          heroTag: "main_fab",
          child: FaIcon(
            FontAwesomeIcons.pencilAlt,
            color: getTextColor(context),
          ),
          onPressed: () {},
          backgroundColor: getAppbarBackGroundColor(context),
        );
      default:
        return null;
    }
  }
}
