import 'package:fluam_app/api.dart';
import 'package:fluam_app/conf.dart';
import 'package:fluam_app/data/app/Flarum.dart';
import 'package:fluam_app/data/app/FlarumSite.dart';
import 'package:fluam_app/data/decoder/flarum/flarum.dart';
import 'package:fluam_app/route.dart';
import 'package:fluam_app/ui/widgets.dart';
import 'package:fluam_app/ui/widgets/cache_image/cache_image.dart';
import 'package:fluam_app/ui/widgets/desktop_scroll/desktop_scroll.dart';
import 'package:fluam_app/ui/widgets/flarum_html_content.dart';
import 'package:fluam_app/ui/widgets/flarum_user_avatar.dart';
import 'package:fluam_app/util/StringUtil.dart';
import 'package:fluam_app/util/color.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

typedef SiteIndexCallBack(int index);
typedef FabStatueCallBack(int index);

class MainDiscussList extends StatefulWidget {
  final List<FlarumSiteInfo> sites;
  final FabStatueCallBack fabStatueCallBack;

  const MainDiscussList(this.sites, {Key key, this.fabStatueCallBack})
      : assert(fabStatueCallBack != null),
        super(key: key);

  @override
  _MainDiscussListState createState() => _MainDiscussListState();
}

class _MainDiscussListState extends State<MainDiscussList>
    with TickerProviderStateMixin {
  int pageIndex = 0;
  List<Widget> widgets = [];
  ScrollController scrollController = ScrollController();

  bool pageHaveNext = false;
  String singleSiteNextPageUrl = "";
  int siteIndex = -1;

  bool isLoading = false;

  /// siteConf id,pageIndex
  static Map<String, int> sitePageMap;

  @override
  void initState() {
    /// init sitePageMap
    scrollController.addListener(() {
      if (scrollController.offset == 0) {
        /// show All fab
        widget.fabStatueCallBack(0);
      } else if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        /// show Loading or hide fab
        if (pageHaveNext) {
          widget.fabStatueCallBack(2);
          _pageGONext();
          return;
        }
        widget.fabStatueCallBack(-1);
      } else {
        /// show mini fab
        widget.fabStatueCallBack(1);
      }
    });
    _loadData(siteIndex, 0);
    super.initState();
  }

  _loadData(int siteIndex, int page) async {
    print("siteIndex:$siteIndex pageIndex:$page");
    isLoading = true;
    pageHaveNext = false;
    if (page == 0) {
      setState(() {
        widgets = [];
        sitePageMap = {};
      });
    }
    if (siteIndex == -1) {
      /// load All Site
      if (!sitePageMap.containsKey("_lastPageIndex")) {
        sitePageMap.addAll({"_lastPageIndex": 0});
      }
      final r = _splitSites(sitePageMap["_lastPageIndex"]);
      List<Future<FlarumDiscussionsInfo>> getTask = [];
      r.forEach((s) {
        getTask.add(AppWebApi.getDiscussionsList(s.info, s.index));
      });
      try {
        final List<FlarumDiscussionsInfo> result = await (Future.wait(getTask));
        for (int i = 0; i < 20; i++) {
          for (var info in result) {
            if (!info.data.discussionsList.asMap().containsKey(i)) {
              break;
            }
            final d = info.data.discussionsList[i];
            if (!pageHaveNext &&
                d.links != null &&
                d.links.next != null &&
                d.links.next != "") {
              pageHaveNext = true;
            }
            widgets.add(_DiscussCard(
              info.site.data,
              d,
              shoeSiteBanner: true,
            ));
          }
        }
        setState(() {});
      } catch (e) {}
    } else {
      await _loadSite(widget.sites[siteIndex]);
    }
    isLoading = false;
  }

  _loadSite(FlarumSiteInfo site, {String url = ""}) async {
    isLoading = true;
    FlarumDiscussionsInfo info;
    if (url == "") {
      info = await AppWebApi.getDiscussionsList(widget.sites[siteIndex], 0);
    } else {
      info = await AppWebApi.getDiscussionsListWithUrl(site, url);
    }
    info.data.discussionsList.forEach((d) {
      if (!pageHaveNext &&
          d.links != null &&
          d.links.next != null &&
          d.links.next != "") {
        singleSiteNextPageUrl = d.links.next;
        pageHaveNext = true;
      }
      widgets.add(_DiscussCard(widget.sites[siteIndex].data, d));
    });
    setState(() {});
    isLoading = false;
  }

  void _pageGONext() async {
    pageIndex++;
    if (isLoading) {
      return;
    }
    if (siteIndex == -1) {
      await _loadData(siteIndex, pageIndex);
    } else {
      await _loadSite(widget.sites[siteIndex], url: singleSiteNextPageUrl);
    }
    widget.fabStatueCallBack(1);
    scrollController.animateTo(scrollController.offset + 200,
        duration: Duration(milliseconds: 500), curve: Curves.fastOutSlowIn);
  }

  /// addFollow
  void _addFollowSite(BuildContext context) {
    /// TODO
    ///

    ///
    /// 👇 for debug
    AppRoute.goAddSiteUI(context);
  }

  List<FlarumSitePageIndex> _splitSites(int index) {
    List<FlarumSitePageIndex> siteIndex = [];
    final followSites = AppConf.followSites;
    int getCount = 5;
    if (followSites.length < 5) {
      getCount = followSites.length;
    }
    while (getCount > 0) {
      if (!(followSites.length > index)) {
        index = 0;
      }
      final site = followSites[index];
      if (!sitePageMap.containsKey(site.id)) {
        sitePageMap.addAll({site.id: 0});
      }
      int pageIndex = sitePageMap[site.id];
      siteIndex.add((FlarumSitePageIndex(site, pageIndex)));
      getCount--;
      index++;
      sitePageMap[site.id]++;
    }

    sitePageMap.addAll({"_lastPageIndex": index});

    return siteIndex;
  }

  void _updateCurrentSite(BuildContext context, int index) {
    pageIndex = 0;
    if (index == 0) {
      /// All site
      siteIndex = -1;
    } else {
      siteIndex = index - 1;
    }
    _loadData(siteIndex, pageIndex);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sites == null || widget.sites.length == 0) {
      return Center(
        child: Text("no followSites"),
      );
    } else {
      final view = CustomScrollView(
        controller: scrollController,
        semanticChildCount: widgets.length,
        physics: AppConf.isDesktop ? NeverScrollableScrollPhysics() : null,
        slivers: [
          SliverToBoxAdapter(
              child: SitesHorizonList(
            widget.sites,
            siteIndexCallBack: (index) {
              final i = index - 1;
              if (i == -2) {
                _addFollowSite(context);
                return;
              }
              _updateCurrentSite(context, index);
            },
          )),
          (widgets == null || widgets.length == 0)
              ? SliverWaterfallFlow.count(
                  crossAxisCount: 1,
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          CircularProgressIndicator()
                        ],
                      ),
                    )
                  ],
                )
              : SliverWaterfallFlow(
                  gridDelegate:
                      SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                    crossAxisCount: AppConf.isDesktop ? 3 : 1,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                  ),
                  delegate:
                      SliverChildBuilderDelegate((BuildContext c, int index) {
                    return widgets[index];
                  }, childCount: widgets.length),
                )
        ],
      );
      final v = Scrollbar(
          controller: scrollController,
          isAlwaysShown: AppConf.isDesktop,
          child: view);
      if (AppConf.isDesktop) {
        return SmoothScrollDesktop(
          controller: scrollController,
          child: v,
          scrollSpeed: 200,
          scrollAnimationLength: 200,
        );
      }
      return v;
    }
  }

  Widget makeButton(
      BuildContext context, String tipText, int index, Widget icon) {
    return SizedBox(
        height: 64,
        child: Tooltip(
          message: tipText,
          child: TextButton(
            onPressed: () {},
            child: icon,
          ),
        ));
  }
}

/// Site list
class SitesHorizonList extends StatefulWidget {
  final List<FlarumSiteInfo> sites;
  final SiteIndexCallBack siteIndexCallBack;

  const SitesHorizonList(this.sites, {Key key, this.siteIndexCallBack})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => SitesHorizonListState();
}

class SitesHorizonListState extends State<SitesHorizonList> {
  int siteIndex = 0;

  Widget makeButton(
      BuildContext context, String tipText, int index, Widget icon) {
    return SizedBox(
        height: 64,
        child: Tooltip(
          message: tipText,
          child: TextButton(
            onPressed: () {
              widget.siteIndexCallBack(index);
              if (index == -1) {
                return;
              }
              setState(() {
                siteIndex = index;
              });
            },
            child: icon,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      makeButton(
          context,
          "All Following",
          0,
          Icon(
            Icons.apps,
            color: getTextColor(context),
          ))
    ];
    widget.sites.asMap().forEach((index, site) {
      widgets.add(makeButton(
          context,
          site.data.title,
          index + 1,
          SizedBox(
            child: site.data.faviconUrl == null
                ? makeNoIconSiteIcon(context, site.data.title)
                : Image.network(site.data.faviconUrl),
            height: 42,
            width: 42,
          )));
    });
    widgets.add(makeButton(
        context,
        "add Site",
        -1,
        FaIcon(
          FontAwesomeIcons.plus,
          color: getTextColor(context),
        )));
    if (widget.sites == null || widget.sites.length == 0) {
      return SizedBox();
    }
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 64,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: 64,
                height: 5,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: siteIndex == index
                          ? Colors.black
                          : Colors.transparent,
                      width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                child: widgets[index],
              );
            },
            itemCount: widgets.length,
          )),
    );
  }
}

/// items
class _DiscussCard extends StatelessWidget {
  final FlarumSiteData siteData;
  final FlarumDiscussionData discussionData;
  final bool shoeSiteBanner;

  const _DiscussCard(this.siteData, this.discussionData,
      {Key key, this.shoeSiteBanner = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlarumUserData userData =
        discussionData.included.users[discussionData.user.id];
    FlarumPostData firstPost;
    try {
      firstPost = discussionData.included.posts[discussionData.firstPost.id];
    } catch (_) {}
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 10, bottom: 20, left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Title
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    discussionData.title,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                /// User HEAD
                ListTile(
                  title: Text(userData.displayName),
                  subtitle: Text(discussionData.createdAt),
                  leading: FlarumUserAvatar(userData.avatarUrl),
                ),
                SizedBox(
                  height: 10,
                ),

                /// content
                SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: firstPost == null
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text("..."),
                          )
                        : FlarumHTMLContent(StringUtil.getHtmlContentSummary(
                                firstPost.contentHtml)
                            .outerHtml)),

                shoeSiteBanner ? makeSiteBanner(context) : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeSiteBanner(BuildContext context) {
    Color backgroundColor =
        HexColor.fromHex(siteData.themePrimaryColor).withAlpha(160);
    return ActionChip(
      backgroundColor: backgroundColor,
      onPressed: () {},
      label: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            SizedBox(
              child: CacheImage(siteData.faviconUrl,
                  nullUrlWidget: makeNoIconSiteIcon(context, siteData.title,
                      size: 14,
                      textColor: getTextColorWithBackgroundColor(
                          context, backgroundColor))),
              width: 18,
              height: 18,
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
                child: Text(
              siteData.title,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  fontSize: 12,
                  color: getTextColorWithBackgroundColor(
                      context, backgroundColor)),
            ))
          ],
        ),
      ),
    );
  }
}
