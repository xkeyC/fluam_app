import 'package:fluam_app/api.dart';
import 'package:fluam_app/data/app/FlarumSiteInfo.dart';
import 'package:fluam_app/ui/widgets.dart';
import 'package:fluam_app/ui/widgets/cache_image/cache_image.dart';
import 'package:fluam_app/util/StringUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef void SiteInfoCallBack(FlarumSiteInfo info);

class AddSiteUI extends StatefulWidget {
  final bool firstSite;

  const AddSiteUI({Key key, this.firstSite = false}) : super(key: key);

  @override
  _AddSiteUIState createState() => _AddSiteUIState();
}

class _AddSiteUIState extends State<AddSiteUI> {
  PageController controller = PageController();
  FlarumSiteInfo siteInfo;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
      controller: controller,
      physics: NeverScrollableScrollPhysics(),
      children: [
        _AddSiteMainPage(
          true,
          siteInfoCallBack: (info) async {
            setState(() {
              siteInfo = info;
            });
            await Future.delayed(Duration(milliseconds: 300));
            controller.animateToPage(1,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOutQuint);
          },
        ),
        _CheckSiteInfoPage(
          siteInfo,
          widget.firstSite,
          onBack: () {
            controller.animateToPage(0,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOutQuint);
          },
        )
      ],
    ));
  }
}

/// Checking info Page
class _CheckSiteInfoPage extends StatefulWidget {
  final FlarumSiteInfo info;
  final bool firstSite;
  final VoidCallback onBack;

  const _CheckSiteInfoPage(this.info, this.firstSite, {Key key, this.onBack})
      : super(key: key);

  @override
  _CheckSiteInfoPageState createState() => _CheckSiteInfoPageState();
}

class _CheckSiteInfoPageState extends State<_CheckSiteInfoPage> {
  bool isSpeedChecking = false;
  FlarumSiteInfo info;

  void _checkSpeed() async {
    setState(() {
      isSpeedChecking = true;
    });
    try {
      final i = await AppWebApi.getFlarumSiteData(info.data.baseUrl);
      if (i != null) {
        info = i;
      }
    } catch (e) {}
    if (mounted) {
      setState(() {
        isSpeedChecking = false;
      });
    }
  }

  @override
  void initState() {
    info = widget.info;
    _checkSpeed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (info == null) {
      info = widget.info;
    }
    return info == null
        ? SizedBox()
        : Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// site LOGO
                  CacheImage(info.data.faviconUrl),

                  /// site Title
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      info.data.title,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),

                  /// Welcome Info
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              info.data.welcomeTitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              StringUtil.getHtmlAllText(
                                  info.data.welcomeMessage),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Site Conf
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(
                                "Conf",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            ListTile(
                              title: RichText(
                                text: TextSpan(
                                    text: "SPEED LEVEL:  ",
                                    style: TextStyle(
                                      color: getTextColor(context),
                                      fontSize: 18,
                                    ),
                                    children: [
                                      WidgetSpan(
                                        child: RatingBarIndicator(
                                          itemBuilder: (BuildContext context,
                                                  int index) =>
                                              Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          itemCount: 5,
                                          direction: Axis.horizontal,
                                          rating: 5.00 -
                                              info.siteConnectionSpeedLevel,
                                          itemSize: 28,
                                        ),
                                      )
                                    ]),
                              ),
                              subtitle: Text(
                                  "A good connection speed will improve your experience."),
                              trailing: IconButton(
                                onPressed: isSpeedChecking ? null : _checkSpeed,
                                icon: isSpeedChecking
                                    ? CircularProgressIndicator()
                                    : Icon(Icons.refresh),
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "Follow This Site",
                              ),
                              subtitle:
                                  Text("This site will show on your Home Page"),
                              leading: Checkbox(
                                onChanged: (bool value) {},
                                value: false,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// bottom bar
            bottomNavigationBar: ButtonBar(
              alignment: MainAxisAlignment.center,
              buttonPadding: EdgeInsets.only(left: 20, right: 20),
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.grey,
                  mini: true,
                  onPressed: widget.onBack,
                  child: Icon(Icons.close),
                ),
                FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: () {},
                  child: Icon(Icons.check),
                ),
                FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.grey,
                  onPressed: () {},
                  child: FaIcon(FontAwesomeIcons.chrome),
                )
              ],
            ),
          );
  }
}

/// Main page, check Url and get Info
class _AddSiteMainPage extends StatefulWidget {
  final bool firstSite;
  final SiteInfoCallBack siteInfoCallBack;

  const _AddSiteMainPage(this.firstSite, {Key key, this.siteInfoCallBack})
      : super(key: key);

  @override
  _AddSiteMainPageState createState() => _AddSiteMainPageState();
}

class _AddSiteMainPageState extends State<_AddSiteMainPage> {
  /// -2,ERROR -1,not URL 0,URL ok 1,loading 2,http ok
  int loadStatus = -1;
  TextEditingController urlTextController = TextEditingController();

  @override
  void initState() {
    urlTextController.text = "https://";
    super.initState();
  }

  void _addSite(BuildContext context) async {
    /// set Loading
    setState(() {
      loadStatus = 1;
    });

    try {
      final site = await AppWebApi.getFlarumSiteData(urlTextController.text);

      /// set Ok
      setState(() {
        loadStatus = 2;
      });
      widget.siteInfoCallBack(site);
    } catch (e) {
      /// set Error
      setState(() {
        loadStatus = -2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.firstSite
                ? "Welcome! \nAdd Your First Flarum Site:"
                : "Add Flarum Site:",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * .15,
                right: MediaQuery.of(context).size.width * .15,
                bottom: 40),
            child: TextFormField(
              enabled: loadStatus != 1,
              controller: urlTextController,
              decoration: InputDecoration(
                  labelText: "flarum site URL,must use https",
                  errorText: loadStatus == -2
                      ? "ERROR! please check network and URL"
                      : null),
              onChanged: (String text) {
                if (StringUtil.isHTTPSUrl(text)) {
                  if (loadStatus != 1 && loadStatus != 0) {
                    setState(() {
                      loadStatus = 0;
                    });
                  }
                } else {
                  if (loadStatus != 1 && loadStatus != -1) {
                    setState(() {
                      loadStatus = -1;
                    });
                  }
                }
              },
            ),
          ),
          SizedBox(
            height: 48,
            width: 48,
            child: Builder(
              builder: (BuildContext context) {
                if (loadStatus == -2) {
                  return FloatingActionButton(
                    backgroundColor: Colors.red,
                    elevation: 3,
                    onPressed: null,
                    child: Icon(
                      Icons.error,
                      color: Colors.white,
                    ),
                  );
                }
                if (loadStatus == 1 || loadStatus == 2) {
                  return FloatingActionButton(
                    heroTag: loadStatus == 2 ? "check_button" : null,
                    backgroundColor:
                        loadStatus == 1 ? Colors.grey : Colors.green,
                    elevation: 3,
                    onPressed: null,
                    child: loadStatus == 1
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                  );
                } else {
                  return FloatingActionButton(
                    backgroundColor:
                        loadStatus == 0 ? Colors.blueAccent : Colors.grey,
                    elevation: 3,
                    onPressed: loadStatus == 0
                        ? () {
                            _addSite(context);
                          }
                        : null,
                    child: Icon(Icons.navigate_next),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
