import 'dart:math';

import 'package:fluam_app/api.dart';
import 'package:fluam_app/conf.dart';
import 'package:fluam_app/data/app/Flarum.dart';
import 'package:fluam_app/data/app/FlarumSite.dart';
import 'package:fluam_app/data/decoder/flarum/flarum.dart';
import 'package:fluam_app/route.dart';
import 'package:fluam_app/ui/widgets/cache_image/cache_image.dart';
import 'package:fluam_app/ui/widgets/flarum_html_content.dart';
import 'package:fluam_app/ui/widgets/flarum_user_avatar.dart';
import 'package:fluam_app/util/StringUtil.dart';
import 'package:fluam_app/util/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import '../widgets.dart';

typedef SiteIndexCallBack(int index);
typedef FabStatueCallBack(int index);

class MainDiscussList extends StatefulWidget {
  final List<FlarumSiteInfo>? sites;
  final FabStatueCallBack fabStatueCallBack;

  const MainDiscussList(this.sites, {Key? key, required this.fabStatueCallBack})
      : super(key: key);

  @override
  _MainDiscussListState createState() => _MainDiscussListState();
}

class _MainDiscussListState extends State<MainDiscussList>
    with TickerProviderStateMixin {
  int pageIndex = 0;

  List<FlarumDiscussionInfo>? listData;
  ScrollController scrollController = ScrollController();

  bool pageHaveNext = false;
  String? singleSiteNextPageUrl = "";
  int siteIndex = -1;

  bool isLoading = false;

  /// siteConf id,pageIndex
  static late Map<String?, int> sitePageMap;

  /// if site loaded END,ignore it.
  static late List<String?> ignoredSiteList;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    /// init sitePageMap
    scrollController.addListener(() {
      //fix desktop scroll
      if (AppConf.isDesktop) {
        const EXTRA_SCROLL_SPEED = 60;
        ScrollDirection scrollDirection =
            scrollController.position.userScrollDirection;
        if (scrollDirection != ScrollDirection.idle) {
          double scrollEnd = scrollController.offset +
              (scrollDirection == ScrollDirection.reverse
                  ? EXTRA_SCROLL_SPEED
                  : -EXTRA_SCROLL_SPEED);
          scrollEnd = min(scrollController.position.maxScrollExtent,
              max(scrollController.position.minScrollExtent, scrollEnd));
          scrollController.jumpTo(scrollEnd);
        }
      }
      if (scrollController.offset == 0) {
        /// show All fab
        widget.fabStatueCallBack(0);
      } else if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        /// show Loading or hide fab
        if (pageHaveNext) {
          widget.fabStatueCallBack(2);
          _pageGoNext();
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
    isLoading = true;
    pageHaveNext = false;
    if (page == 0) {
      sitePageMap = {};
      setState(() {
        // widgets = [];
        listData = [];
        ignoredSiteList = [];
      });
      sitePageMap.addAll({"_lastPageIndex": 0});
    }
    if (siteIndex == -1) {
      /// load All Site
      final r = _splitSites(sitePageMap["_lastPageIndex"]!);
      List<Future<FlarumDiscussionsInfo>> getTask = [];
      r.forEach((s) {
        getTask.add(AppWebApi.getDiscussionsList(s.info, s.index!));
      });
      try {
        final List<FlarumDiscussionsInfo> result = await (Future.wait(getTask));
        for (int i = 0; i < 20; i++) {
          for (var info in result) {
            if (info.data.discussionsList.length == 0) {
              if (!ignoredSiteList.contains(info.site.id)) {
                ignoredSiteList.add(info.site.id);
              }
              continue;
            }
            if (!info.data.discussionsList.asMap().containsKey(i)) {
              continue;
            }
            final d = info.data.discussionsList[i];
            if (!pageHaveNext &&
                d.links != null &&
                d.links!.next != null &&
                d.links!.next != "") {
              pageHaveNext = true;
            }
            listData?.add(FlarumDiscussionInfo(info.site, d));
            // widgets.add(_DiscussCard(
            //   FlarumDiscussionInfo(info.site, d),
            //   showSiteBanner: true,
            // ));
          }
        }
        setState(() {});
      } catch (e) {
        print(e);
      }
    } else {
      await _loadSite(widget.sites![siteIndex]);
    }
    isLoading = false;
  }

  _loadSite(FlarumSiteInfo site, {String? url = ""}) async {
    pageHaveNext = false;
    isLoading = true;
    FlarumDiscussionsInfo info;
    if (url == "") {
      info = await AppWebApi.getDiscussionsList(widget.sites![siteIndex], 0);
    } else {
      info = await AppWebApi.getDiscussionsListWithUrl(site, url!);
    }
    info.data.discussionsList.forEach((d) {
      if (!pageHaveNext &&
          d.links != null &&
          d.links!.next != null &&
          d.links!.next != "") {
        singleSiteNextPageUrl = d.links!.next;
        pageHaveNext = true;
      }
      listData?.add(FlarumDiscussionInfo(info.site, d));
      // widgets.add(_DiscussCard(FlarumDiscussionInfo(info.site, d)));
    });
    setState(() {});
    isLoading = false;
  }

  void _pageGoNext() async {
    if (isLoading) {
      return;
    }
    pageIndex++;
    if (siteIndex == -1) {
      await _loadData(siteIndex, pageIndex);
    } else {
      await _loadSite(widget.sites![siteIndex], url: singleSiteNextPageUrl);
    }
    widget.fabStatueCallBack(1);

    /// Wait for the ui to finish rendering.
    await Future.delayed(Duration(milliseconds: 100));

    /// update scroll
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
    final followSites = AppConf.followSites!;
    int getCount = 5;
    if (followSites.length - ignoredSiteList.length < 5) {
      getCount = (followSites.length - ignoredSiteList.length);
    }
    while (getCount > 0) {
      if (!(followSites.length > index)) {
        index = 0;
      }
      final site = followSites[index];
      if (ignoredSiteList.contains(site.id)) {
        index++;
        continue;
      }
      if (!sitePageMap.containsKey(site.id)) {
        sitePageMap.addAll({site.id: 0});
      }
      int? pageIndex = sitePageMap[site.id];
      print("[siteSplit] ${site.data.title} index: $pageIndex");
      siteIndex.add((FlarumSitePageIndex(site, pageIndex)));
      getCount--;
      index++;
      sitePageMap[site.id] = sitePageMap[site.id]! + 1;
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
    if (widget.sites == null || widget.sites!.length == 0) {
      return Center(
        child: Text("no followSites"),
      );
    } else {
      // return CustomScrollView(
      //   controller: scrollController,
      // );
      return Column(
        children: [
          SitesHorizonList(
            widget.sites,
            siteIndexCallBack: (index) {
              final i = index - 1;
              if (i == -2) {
                _addFollowSite(context);
                return;
              }
              _updateCurrentSite(context, index);
            },
          ),
          SizedBox(
            height: 8,
          ),
          Expanded(
            child: (listData!.length == 0)
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Scrollbar(
                    controller: scrollController,
                    child: WaterfallFlow.builder(
                        controller: scrollController,
                        itemCount: listData!.length,
                        gridDelegate:
                            SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                          crossAxisCount: AppConf.isDesktop ? 3 : 1,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                        ),
                        itemBuilder: (context, index) {
                          return _DiscussCard(
                            listData![index],
                            showSiteBanner: siteIndex == -1,
                          );
                        })),
          )
        ],
      );
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
  final List<FlarumSiteInfo>? sites;
  final SiteIndexCallBack? siteIndexCallBack;

  const SitesHorizonList(this.sites, {Key? key, this.siteIndexCallBack})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => SitesHorizonListState();
}

class SitesHorizonListState extends State<SitesHorizonList> {
  int siteIndex = 0;

  Widget makeButton(
      BuildContext context, String? tipText, int index, Widget icon) {
    return SizedBox(
        height: 64,
        child: Tooltip(
          message: tipText,
          child: TextButton(
            onPressed: () {
              widget.siteIndexCallBack!(index);
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
    widget.sites!.asMap().forEach((index, site) {
      widgets.add(makeButton(
          context,
          site.data.title,
          index + 1,
          SizedBox(
            child: site.data.faviconUrl == null
                ? makeNoIconSiteIcon(context, site.data.title!)
                : Image.network(site.data.faviconUrl!),
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
    if (widget.sites == null || widget.sites!.length == 0) {
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
  final FlarumDiscussionInfo discussionInfo;
  final bool showSiteBanner;

  const _DiscussCard(this.discussionInfo,
      {Key? key, this.showSiteBanner = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlarumUserData? userData =
        discussionInfo.data.included!.users![discussionInfo.data.user?.id];
    FlarumPostData? firstPost;
    try {
      firstPost = discussionInfo
          .data.included!.posts![discussionInfo.data.firstPost?.id];
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
                    discussionInfo.data.title!,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),

                /// User HEAD
                ListTile(
                  title: Text(userData?.displayName ?? "[unknown]"),
                  subtitle: Text(discussionInfo.data.createdAt!),
                  leading: FlarumUserAvatar(userData?.avatarUrl),
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
                        : HtmlView(StringUtil.getHtmlContentSummary(
                                firstPost.contentHtml)
                            .outerHtml)),

                /// SiteBanner
                showSiteBanner ? makeSiteBanner(context) : SizedBox(),

                SizedBox(
                  height: 5,
                ),

                /// Tags
                makeTags(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget makeTags(BuildContext context) {
    List<Widget> tagsWidget = [];

    discussionInfo.data.tags.forEach((tagInfo) {
      final tag = discussionInfo.data.included!.tags![tagInfo?.id]!;
      final backgroundColor = HexColor.fromHex(tag.color);
      tagsWidget.add(InkWell(
        onTap: () {},
        child: Card(
          color: backgroundColor,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              tag.name!,
              style: TextStyle(
                  color: getTextColorWithBackgroundColor(
                      context, backgroundColor)),
            ),
          ),
        ),
      ));
    });

    return SingleChildScrollView(
      child: Row(
        children: tagsWidget,
      ),
    );
  }

  Widget makeSiteBanner(BuildContext context) {
    Color backgroundColor =
        HexColor.fromHex(discussionInfo.site.data.themePrimaryColor)
            .withAlpha(160);
    return ActionChip(
      backgroundColor: backgroundColor,
      onPressed: () {},
      label: Padding(
        padding: EdgeInsets.all(5),
        child: Row(
          children: [
            SizedBox(
              child: CacheImage(discussionInfo.site.data.faviconUrl,
                  nullUrlWidget: makeNoIconSiteIcon(
                      context, discussionInfo.site.data.title!,
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
              discussionInfo.site.data.title!,
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
