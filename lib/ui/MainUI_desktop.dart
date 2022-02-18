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
    HamburgerMenuItem('Main', Icons.home, 0),
    HamburgerMenuItem('Sites', Icons.widgets, 1),
    HamburgerMenuItem('Me', Icons.account_circle, 2),
  ];

  int fabStatus = 0;

  int pageIndex = 0;

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
      floatingActionButton: _getFab(context) as FloatingActionButton?,
      hamburgerMenu: HamburgerMenu(
        onClick: (int value) {
          setState(() {
            pageIndex = value;
            if (value == 0) {
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
      body: IndexedStack(
        index: pageIndex,
        children: [
          MainDiscussList(
            AppConf.followSites,
            fabStatueCallBack: (int status) {
              if (fabStatus == status) {
                return;
              }
              setState(() {
                fabStatus = status;
              });
            },
          ),
          Text("1"),
          Text("2")
        ],
      ),
    );
  }

  Widget? _getFab(BuildContext context) {
    bool isExtended = fabStatus == 0;

    switch (fabStatus) {
      case 0:
      case 1:
        return FloatingActionButton.extended(
          heroTag: "main_fab",
          isExtended: isExtended,
          icon: FaIcon(
            FontAwesomeIcons.pencilAlt,
            color: getTextColor(context),
          ),
          label: makeTitleText(context, "Start a Discussion"),
          onPressed: () {},
          backgroundColor: getAppbarBackGroundColor(context),
        );
      case 2:
        return FloatingActionButton.extended(
          onPressed: null,
          isExtended: false,
          icon: SizedBox(
            child: CircularProgressIndicator(),
            width: 24,
            height: 24,
          ),
          backgroundColor: getAppbarBackGroundColor(context),
          label: Text(""),
        );
    }
    return null;
  }
}
