import 'package:fluam_app/api.dart';
import 'package:fluam_app/data/app/FlarumSite.dart';
import 'package:fluam_app/generated/l10n.dart';
import 'package:fluam_app/route.dart';
import 'package:fluam_app/ui/widgets.dart';
import 'package:fluam_app/ui/widgets/cache_image/cache_image.dart';
import 'package:fluam_app/util/StringUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../conf.dart';

typedef void SiteInfoCallBack(FlarumSiteInfo info);

class AddSiteUI extends StatefulWidget {
  final bool firstSite;

  const AddSiteUI({Key? key, this.firstSite = false}) : super(key: key);

  @override
  _AddSiteUIState createState() => _AddSiteUIState();
}

class _AddSiteUIState extends State<AddSiteUI> {
  PageController controller = PageController();
  FlarumSiteInfo? siteInfo;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: widget.firstSite
              ? null
              : IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: getTextColor(context),
                  )),
        ),
        body: PageView(
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            /// check Url page
            _AddSiteMainPage(
              widget.firstSite,
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

            /// info Page
            siteInfo == null
                ? SizedBox()
                : _CheckSiteInfoPage(
                    siteInfo,
                    widget.firstSite,
                    onBack: () {
                      setState(() {
                        siteInfo = null;
                      });
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
  final FlarumSiteInfo? info;
  final bool firstSite;
  final VoidCallback? onBack;

  const _CheckSiteInfoPage(this.info, this.firstSite, {Key? key, this.onBack})
      : super(key: key);

  @override
  _CheckSiteInfoPageState createState() => _CheckSiteInfoPageState();
}

class _CheckSiteInfoPageState extends State<_CheckSiteInfoPage> {
  bool isSpeedChecking = false;
  bool? follow = false;
  FlarumSiteInfo? info;

  void _checkSpeed() async {
    setState(() {
      isSpeedChecking = true;
    });
    try {
      final i = await AppWebApi.getFlarumSiteData(info!.data.baseUrl!);
      info = i;
      follow = i.siteConnectionSpeedLevel! < 2;
    } catch (e) {}
    if (mounted) {
      setState(() {
        isSpeedChecking = false;
      });
    }
  }

  void _followSite(bool? value) {
    if (value!) {
      /// if site speed not good
      if (!(info!.siteConnectionSpeedLevel! < 2)) {
        /// show Dialog
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(S.of(context).title_warning),
                content: Text(S.of(context).c_site_speed_warning),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          follow = true;
                        });
                      },
                      child: Text(S.of(context).title_yes)),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _checkSpeed();
                      },
                      child: Text(S.of(context).title_retest_speed)),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(S.of(context).title_no))
                ],
              );
            });
        return;
      }
    }
    setState(() {
      follow = value;
    });
  }

  /// add Site Info to siteList
  void _addSite() async {
    info!.following = follow;
    await info!.saveSite();
    await AppConf.updateSiteList();
    AppRoute.goMainAndRemoveUntil(context);
  }

  String? _getIconUrl() {
    if (info!.data.logoUrl != null) {
      return info!.data.logoUrl;
    } else if (info!.data.faviconUrl != null) {
      return info!.data.faviconUrl;
    } else {
      return "https://discuss.flarum.org/assets/logo-y6hlll2o.png";
    }
  }

  @override
  void initState() {
    info = widget.info;
    if (info!.siteConnectionSpeedLevel! < 2) {
      follow = true;
    }
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
                  CacheImage(
                    _getIconUrl(),
                    loaderSize: 48,
                  ),

                  /// site Title
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      info!.data.title!,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),

                  /// Welcome Info
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              info!.data.welcomeTitle!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              StringUtil.getHtmlAllText(
                                  info!.data.welcomeMessage),
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
                                S.of(context).title_site_conf,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),

                            /// SPEED LEVEL
                            ListTile(
                              title: RichText(
                                text: TextSpan(
                                    text: S.of(context).title_SPEED_LEVEL,
                                    style: TextStyle(
                                      color: getTextColor(context),
                                      fontSize: 18,
                                    ),
                                    children: [
                                      WidgetSpan(
                                        child: RatingBarIndicator(
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            Color c = Colors.amber;
                                            if (info!
                                                    .siteConnectionSpeedLevel! <=
                                                1) {
                                              c = Colors.green;
                                            } else if (info!
                                                    .siteConnectionSpeedLevel! <=
                                                2) {
                                              c = Colors.amber;
                                            } else {
                                              c = Colors.red;
                                            }
                                            return Icon(
                                              Icons.star,
                                              color: c,
                                            );
                                          },
                                          itemCount: 5,
                                          direction: Axis.horizontal,
                                          rating: 5.00 -
                                              info!.siteConnectionSpeedLevel!,
                                          itemSize: 28,
                                        ),
                                      )
                                    ]),
                              ),
                              subtitle: Text(S.of(context).c_site_speed_level),
                              trailing: IconButton(
                                onPressed: isSpeedChecking ? null : _checkSpeed,
                                icon: isSpeedChecking
                                    ? CircularProgressIndicator()
                                    : Icon(Icons.refresh),
                              ),
                            ),

                            /// Site Follow
                            ListTile(
                              title: Text(
                                S.of(context).title_site_follow,
                              ),
                              subtitle: Text(S.of(context).c_site_follow),
                              leading: Checkbox(
                                onChanged: _followSite,
                                value: follow,
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
                  heroTag: UniqueKey(),
                  backgroundColor: Colors.grey,
                  mini: true,
                  onPressed: widget.onBack,
                  child: Icon(Icons.close),
                ),
                FloatingActionButton(
                  heroTag: "main_fab",
                  backgroundColor: Colors.green,
                  onPressed: _addSite,
                  child: Icon(Icons.check),
                ),
                FloatingActionButton(
                  heroTag: UniqueKey(),
                  mini: true,
                  backgroundColor: Colors.grey,
                  onPressed: () {
                    /// open Url
                    // url_launcher.launch(info!.data.baseUrl!);
                  },
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
  final SiteInfoCallBack? siteInfoCallBack;

  const _AddSiteMainPage(this.firstSite, {Key? key, this.siteInfoCallBack})
      : super(key: key);

  @override
  _AddSiteMainPageState createState() => _AddSiteMainPageState();
}

class _AddSiteMainPageState extends State<_AddSiteMainPage> {
  /// -2,ERROR -1,not URL 0,URL ok 1,loading 2,http ok -3,site added
  int loadStatus = -1;
  TextEditingController urlTextController = TextEditingController();

  @override
  void initState() {
    urlTextController.text = "https://";
    super.initState();
  }

  void _addSite(BuildContext context) async {
    final String url = urlTextController.text;

    /// set Loading
    setState(() {
      loadStatus = 1;
    });

    try {
      if (await FlarumSiteInfo.hasSite(url)) {
        setState(() {
          loadStatus = -3;
        });
        return;
      }
      final site = await AppWebApi.getFlarumSiteData(url);

      /// set Ok
      setState(() {
        loadStatus = 2;
      });
      widget.siteInfoCallBack!(site);
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
                ? S.of(context).title_add_site_first
                : S.of(context).title_add_site,
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
                  labelText: S.of(context).c_site_url_label,
                  errorText: loadStatus == -2
                      ? S.of(context).c_site_url_label_error
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
