import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;

import '../../util/color.dart';
import 'cache_image/cache_image.dart';
import 'cache_image/image_view.dart';
import 'code_view.dart';

typedef void OnLinkTap(String link);

class HtmlView extends StatelessWidget {
  final String content;
  final OnLinkTap? onLinkTap;
  static double textSize = 16;

  HtmlView(this.content, {this.onLinkTap});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    parse(content).body?.children.forEach((element) {
      widgets.add(getWidget(context, element));
    });
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgets),
    );
  }

  List<InlineSpan> getRichTextSpan(BuildContext context, dom.NodeList nodes,
      {List<InlineSpan>? span}) {
    if (span == null) {
      span = <InlineSpan>[];
    }
    nodes.forEach((n) {
      if (n.hasChildNodes()) {
        getRichTextSpan(context, n.nodes, span: span);
      } else {
        switch (n.parent?.localName ?? "") {
          case "div":
          case "span":
            getRichTextSpan(context, n.nodes).forEach((s) {
              span!.add(s);
            });
            break;
          case "p":
            if (n.toString() == "<html img>") {
              String? url = n.attributes["src"];
              String k = UniqueKey().toString();
              span!.add(WidgetSpan(
                  child: contentPadding(Center(
                child: InkWell(
                  child: Material(
                    child: Hero(tag: k, child: CacheImage(url)),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ImagesView([n.attributes["src"]!], 0, k);
                    }));
                  },
                ),
              ))));
            } else {
              span?.add(TextSpan(
                  text: "${n.text}", style: TextStyle(fontSize: textSize)));
            }
            break;
          case "a":
            switch (n.parent?.className ?? "") {
              case "UserMention":
                span?.add(WidgetSpan(
                    child: InkWell(
                  child: Text("${n.text}",
                      style: TextStyle(
                          fontSize: textSize,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)),
                  onTap: () {
                    onLinkTap?.call(n.parent!.attributes["href"]!);
                  },
                )));
                break;
              case "PostMention":
                span?.add(WidgetSpan(
                    child: InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: FaIcon(
                          FontAwesomeIcons.reply,
                          color: Colors.blue,
                          size: textSize,
                        ),
                      ),
                      Text("${n.text}",
                          style: TextStyle(
                              fontSize: textSize,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  onTap: () {
                    onLinkTap?.call(n.parent!.attributes["href"]!);
                  },
                )));
                break;
              case "github-issue-link":
                span?.add(WidgetSpan(
                    child: InkWell(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 5, right: 2),
                        child: FaIcon(
                          FontAwesomeIcons.github,
                          size: 18,
                        ),
                      ),
                      Text("${n.text}",
                          style: TextStyle(
                              fontSize: textSize,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  onTap: () {
                    onLinkTap?.call(n.parent!.attributes["href"]!);
                  },
                )));
                break;
              default:
                span?.add(WidgetSpan(
                    child: InkWell(
                  child: Text("${n.text}",
                      style: TextStyle(
                          fontSize: textSize,
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold)),
                  onTap: () {
                    onLinkTap?.call(n.parent!.attributes["href"]!);
                  },
                )));
                if (n.parent!.className != "") {
                  print("UnimplementedUrlClass:${n.parent!.className}");
                }
                break;
            }
            break;
          case "b":
          case "strong":
            span?.add(TextSpan(
                text: "${n.text}",
                style: TextStyle(
                    fontSize: textSize, fontWeight: FontWeight.bold)));
            break;
          case "br":
            span?.add(WidgetSpan(child: Text("\n")));
            break;
          case "em":
            span?.add(TextSpan(
                text: n.text,
                style: TextStyle(
                  fontSize: textSize,
                  fontStyle: FontStyle.italic,
                )));
            break;
          case "code":
            span?.add(TextSpan(
                text: n.text,
                style: TextStyle(
                    color: Colors.black54, backgroundColor: Colors.white)));
            break;
          case "s":
          case "del":
            span?.add(TextSpan(
                text: "${n.text}",
                style: TextStyle(
                  fontSize: textSize,
                  decoration: TextDecoration.lineThrough,
                )));
            break;
          default:
            print("UnimplementedNode:${n.parent?.localName}");
            span?.add(WidgetSpan(
                child: Text(
              "${n.text}",
              style: TextStyle(fontSize: textSize),
            )));
            break;
        }
      }
    });
    return span;
  }

  Widget getWidget(BuildContext context, dom.Element element) {
    switch (element.localName) {
      case "p":
        return contentPadding(RichText(
            text: TextSpan(
                children: getRichTextSpan(context, element.nodes),
                style: TextStyle(fontSize: textSize, color: Colors.black))));
      case "h1":
        return contentPadding(Text(
          element.text,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ));
      case "h2":
        return contentPadding(Text(
          element.text,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ));
      case "h3":
        return contentPadding(Text(
          element.text,
          style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),
        ));
      case "h4":
        return contentPadding(Text(
          element.text,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ));
      case "h5":
        return contentPadding(Text(
          element.text,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ));
      case "h6":
        return contentPadding(Text(
          element.text,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey),
        ));
      case "hr":
        return contentPadding(Divider(
          height: 1,
          color: Colors.grey,
        ));
      case "br":
        return contentPadding(SizedBox());
      case "details":
        return contentPadding(SizedBox(
          width: MediaQuery.of(context).size.width,
          child: RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(
                "title_show_details",
                style: TextStyle(
                    color: ColorUtil.getTitleFormBackGround(
                        Theme.of(context).primaryColor)),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    var e = element.outerHtml.replaceAll("<details", "<p");
                    return AlertDialog(
                      title: Text("title_details"),
                      content: Scrollbar(
                          child: SingleChildScrollView(
                        child: HtmlView(
                          e,
                          onLinkTap: onLinkTap,
                        ),
                      )),
                      actions: <Widget>[
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("close"))
                      ],
                    );
                  },
                );
              }),
        ));
      case "ol":
        List<Widget> list = [];
        int index = 1;
        element.children.forEach((c) {
          list.add(Text(
            "$index.${c.text}",
            style: TextStyle(fontSize: textSize),
          ));
          index++;
        });
        return Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list,
            ),
          ),
        );
        break;
      case "ul":
        List<Widget> list = [];
        element.children.forEach((c) {
          list.add(Text(
            "• ${c.text}",
            style: TextStyle(fontSize: textSize),
          ));
        });
        return Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: list,
            ),
          ),
        );
      case "blockquote":
        Color background = HexColor.fromHex("#e7edf3");
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            elevation: 0,
            color: background,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: RichText(
                  text: TextSpan(
                      children: getRichTextSpan(context, element.nodes),
                      style:
                          TextStyle(fontSize: textSize, color: Colors.black))),
            ),
          ),
        );
      case "pre":
        Color backGroundColor = Colors.black87;
        return contentPadding(SizedBox(
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            child: Card(
              elevation: 0,
              color: backGroundColor,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0))),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: NotificationListener(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      element.text,
                      style: TextStyle(
                          color: ColorUtil.getTitleFormBackGround(
                              backGroundColor)),
                    ),
                  ),
                  onNotification: (ScrollNotification notification) {
                    return true;
                  },
                ),
              ),
            ),
            onTap: () async {
              SystemChrome.setEnabledSystemUIOverlays([]);
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.landscapeRight,
                DeviceOrientation.landscapeRight,
              ]);
              await Navigator.push(context,
                  MaterialPageRoute(builder: (BuildContext context) {
                return CodeView(element.text);
              }));
              SystemChrome.setEnabledSystemUIOverlays(
                  [SystemUiOverlay.top, SystemUiOverlay.bottom]);
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
              ]);
            },
          ),
        ));
      case "div":
        return HtmlView(element.outerHtml.replaceAll("<div", "<p"));
      case "script":
        return SizedBox();
      default:
        return contentPadding(RichText(
            text: TextSpan(
                children: getRichTextSpan(context, element.nodes),
                style: TextStyle(fontSize: textSize, color: Colors.black))));
        // return contentPadding(contentPadding(SizedBox(
        //   width: MediaQuery.of(context).size.width,
        //   child: RaisedButton(
        //       color: Colors.red,
        //       child: Text(
        //         "UnimplementedNode",
        //         style: TextStyle(color: Colors.white),
        //       ),
        //       onPressed: () {
        //         showDialog(
        //             context: context,
        //             builder: (BuildContext context) {
        //               return AlertDialog(
        //                 title: Text("Source"),
        //                 content: Text(element.outerHtml),
        //               );
        //             });
        //       }),
        // )));
    }
  }

  Widget contentPadding(Widget child) {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
      child: child,
    );
  }
}
