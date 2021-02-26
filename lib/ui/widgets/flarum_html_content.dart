import 'package:fluam_app/ui/widgets.dart';
import 'package:fluam_app/ui/widgets/flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html;

class FlarumHTMLContent extends StatelessWidget {
  final String htmlString;
  final bool summary;

  const FlarumHTMLContent(this.htmlString, {Key key, this.summary = false})
      : super(key: key);

  /// Recursive decoding
  List<InlineSpan> _htmlToRichSpan(BuildContext context,
      List<dom.Element> htmlElement, List<InlineSpan> list) {
    htmlElement.forEach((element) {
      switch (element.localName) {
        case "p":
        case "ul":
          list.add(WidgetSpan(
              child: Padding(
            padding: EdgeInsets.all(10),
            child: getHtmlWidget(context, element.outerHtml),
          )));
          break;
        case "blockquote":
          list.add(WidgetSpan(
              child: Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              elevation: 1,
              color: Color.fromARGB(255, 231, 237, 243),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: getHtmlWidget(context, element.outerHtml),
              ),
            ),
          )));
          break;
        case "code":
          list.add(TextSpan(children: [
            WidgetSpan(
              child: Card(
                color: Colors.black,
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    element.text,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            TextSpan(text: "\n"),
          ]));

          break;
        default:
          if (element.children.length == 0) {
            switch (element.localName) {
              case "h1":
                list.add(_makeHTML_H(context, element, 20));
                break;
              case "h2":
                list.add(_makeHTML_H(context, element, 18));
                break;
              case "h3":
                list.add(_makeHTML_H(context, element, 16));
                break;
              case "h4":
                list.add(_makeHTML_H(context, element, 14));
                break;
              case "h5":
                list.add(_makeHTML_H(context, element, 12));
                break;
              case "hr":
                list.add(WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Divider(
                      height: 1.0,
                      color: Colors.grey,
                    ),
                  ),
                ));
                break;
              default:
                break;
            }
          } else {
            _htmlToRichSpan(context, element.children, list);
          }
      }
    });
    return list;
  }

  Widget getHtmlWidget(BuildContext context, String html) {
    return HtmlWidget(
      html,
      hyperlinkColor: Color.fromARGB(255, 243, 99, 34),
      onTapUrl: (str) {
        print("tapUrl:$str");
      },
    );
  }

  // ignore: non_constant_identifier_names
  InlineSpan _makeHTML_H(
      BuildContext context, dom.Element element, double fontSize) {
    return TextSpan(
        text: "\n${element.text}\n",
        style: TextStyle(
            color: getTextColor(context),
            fontSize: fontSize,
            fontWeight: FontWeight.bold));
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            children: _htmlToRichSpan(
                context, html.parse(htmlString).body.children, [])));
  }
}
