import 'package:fluam_app/generated/l10n.dart';
import 'package:fluam_app/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class SplashUI extends StatefulWidget {
  @override
  _SplashUIState createState() => _SplashUIState();
}

class _SplashUIState extends State<SplashUI> with TickerProviderStateMixin {
  AnimationController _flutterLogoController;
  AnimationController _appLogoController;
  FlutterLogoStyle _flutterLogoStyle = FlutterLogoStyle.markOnly;
  int flutterLogoDuration = 0;
  Animation<Offset> flutterLogoAnimation;
  bool showPowerByText = false;
  GlobalKey<ScaffoldState> _scaffold = GlobalKey();

  @override
  void initState() {
    /// do sth for app init
    _flutterLogoController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    _appLogoController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);

    flutterLogoAnimation = Tween(begin: Offset.zero, end: Offset(0, 3.4))
        .animate(_flutterLogoController);

    _flutterLogoController.addListener(() {
      if (_flutterLogoController.status == AnimationStatus.completed) {
        setState(() {
          showPowerByText = true;
        });
      }
    });

    initData();

    super.initState();
  }

  void initData() {
    Future.delayed(Duration(seconds: 1)).then((_) async {
      int waitTime = 3000;
      if (true) {
        flutterLogoDuration = 1000;
        setState(() {
          _flutterLogoStyle = FlutterLogoStyle.horizontal;
        });
        _flutterLogoController.duration = Duration(milliseconds: 300);
        _appLogoController.duration = Duration(milliseconds: 500);
        await Future.delayed(Duration(milliseconds: 500));
      } else {
        waitTime = 300;
        setState(() {
          _flutterLogoStyle = FlutterLogoStyle.horizontal;
        });
        setState(() {
          showPowerByText = true;
        });
      }
      _flutterLogoController.forward();
      _appLogoController.forward();
      await Future.delayed(Duration(milliseconds: waitTime));

      ///AppRoute.goMainAndRemoveUntil(_scaffold.currentContext);

      AppRoute.goAddSiteUIAndRemoveUntil(_scaffold.currentContext,
          firstSite: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      title: "Fluam",
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        S.delegate
      ],
      supportedLocales: [const Locale('en'), const Locale('zh', 'CN')],
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            key: _scaffold,
            body: Stack(
              children: [
                Center(
                  child: SlideTransition(
                    position: flutterLogoAnimation,
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: FlutterLogo(
                            style: _flutterLogoStyle,
                            duration:
                                Duration(milliseconds: flutterLogoDuration),
                            curve: Curves.easeInExpo,
                          ),
                        ),
                        Positioned(
                          child: showPowerByText
                              ? Center(
                                  child: Text(
                                    "Powered By",
                                    style: TextStyle(fontSize: 9),
                                  ),
                                )
                              : SizedBox(),
                          top: 25,
                          left: 0,
                          right: 40,
                        )
                      ],
                    ),
                  ),
                ),
                Center(
                  child: FadeTransition(
                    opacity: _appLogoController,
                    child: SizedBox(
                      height: 100,
                      child: Image.asset("assets/icon.png"),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _flutterLogoController.dispose();
    _appLogoController.dispose();
    super.dispose();
  }
}
