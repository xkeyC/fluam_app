import 'package:fluam_app/api.dart';
import 'package:fluam_app/conf.dart';
import 'package:fluam_app/data/app/FlarumSiteInfo.dart';
import 'package:fluam_app/data/decoder/flarum/flarum.dart';
import 'package:fluam_app/ui/widgets/flarum_html_content.dart';
import 'package:fluam_app/ui/widgets/flarum_user_avatar.dart';
import 'package:fluam_app/util/StringUtil.dart';
import 'package:flutter/material.dart';
import 'package:waterfall_flow/waterfall_flow.dart';
import 'package:webscrollbar/webscrollbar.dart';

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
      if (AppConf.isDesktop) {
        return WebScrollBar(
          visibleHeight: MediaQuery.of(context).size.height,
          controller: scrollController,
          child: WaterfallFlow.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: scrollController,
              itemCount: widgets.length,
              gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return widgets[index];
              }),
        );
      } else {
        return ListView.builder(
            itemCount: widgets.length,
            itemBuilder: (context, index) {
              return widgets[index];
            });
      }
    }
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
        padding: EdgeInsets.only(
          top: 10,
          left: 10,
          right: 10,
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
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
