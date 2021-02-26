import 'package:fluam_app/api.dart';
import 'package:fluam_app/conf.dart';
import 'package:fluam_app/data/app/FlarumSiteInfo.dart';
import 'package:fluam_app/data/decoder/flarum/flarum.dart';
import 'package:fluam_app/ui/widgets.dart';
import 'package:fluam_app/ui/widgets/cache_image/cache_image.dart';
import 'package:fluam_app/ui/widgets/flarum_html_content.dart';
import 'package:fluam_app/ui/widgets/flarum_user_avatar.dart';
import 'package:fluam_app/util/StringUtil.dart';
import 'package:flutter/material.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:webscrollbar/webscrollbar.dart';

typedef SiteIndexCallBack(int index);

class MainDiscussList extends StatefulWidget {
  final List<FlarumSiteInfo> sites;

  const MainDiscussList(this.sites, {Key key}) : super(key: key);

  @override
  _MainDiscussListState createState() => _MainDiscussListState();
}

class _MainDiscussListState extends State<MainDiscussList> {
  int pageIndex = 0;
  List<Widget> widgets = [];
  ScrollController scrollController = ScrollController();
  int siteIndex = 0;

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  void _loadData() async {
    if (widget.sites != null && widget.sites.length != 0) {
      final discussions =
          await AppWebApi.getDiscussionsList(widget.sites[0].data, pageIndex);
      discussions.discussionsList.forEach((element) {
        widgets.add(_DiscussCard(widget.sites[0].data, element));
      });
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sites == null || widget.sites.length == 0) {
      return Center(
        child: Text("no followSites"),
      );
    } else if (widgets.length == 0) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      final view = CustomScrollView(
        physics: AppConf.isDesktop ? NeverScrollableScrollPhysics() : null,
        controller: scrollController,
        semanticChildCount: widgets.length,
        slivers: [
          SliverToBoxAdapter(
              child: SitesHorizonList(
            widget.sites,
            siteIndex: siteIndex,
            siteIndexCallBack: (index) {
              setState(() {
                siteIndex = index;
              });
            },
          )),
          SliverWaterfallFlow(
            gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              crossAxisCount: AppConf.isDesktop ? 3 : 1,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            delegate: SliverChildBuilderDelegate((BuildContext c, int index) {
              return widgets[index];
            }, childCount: widgets.length),
          )
        ],
      );

      if (AppConf.isDesktop) {
        return WebScrollBar(
            visibleHeight: MediaQuery.of(context).size.height,
            controller: scrollController,
            child: view);
      }
      return view;
    }
  }
}

/// Site list
class SitesHorizonList extends StatelessWidget {
  final List<FlarumSiteInfo> sites;
  final int siteIndex;
  final SiteIndexCallBack siteIndexCallBack;

  const SitesHorizonList(this.sites,
      {Key key, this.siteIndexCallBack, this.siteIndex = -1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      SizedBox(
          height: 64,
          child: Tooltip(
            message: "All",
            child: TextButton(
              onPressed: () {
                siteIndexCallBack(0);
              },
              child: Icon(
                Icons.apps,
                color: getTextColor(context),
              ),
            ),
          ))
    ];
    sites.asMap().forEach((index, site) {
      widgets.add(SizedBox(
          height: 64,
          child: Tooltip(
            message: site.data.title,
            child: TextButton(
              onPressed: () {
                siteIndexCallBack(index + 1);
              },
              child: CacheImage(site.data.faviconUrl),
            ),
          )));
    });
    widgets.add(SizedBox(
        height: 64,
        child: Tooltip(
          message: "Add Site",
          child: TextButton(
            onPressed: () {
              siteIndexCallBack(-1);
            },
            child: Icon(
              Icons.add,
              color: getTextColor(context),
            ),
          ),
        )));
    if (sites == null || sites.length == 0) {
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

  const _DiscussCard(this.siteData, this.discussionData, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlarumUserData userData =
        discussionData.included.users[discussionData.user.id];
    FlarumPostData firstPost =
        discussionData.included.posts[discussionData.firstPost.id];
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
                    child: FlarumHTMLContent(
                        StringUtil.getHtmlContentSummary(firstPost.contentHtml)
                            .outerHtml))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
