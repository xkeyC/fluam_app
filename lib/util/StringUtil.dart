import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parse;

class StringUtil {
  static bool isHTTPSUrl(String s) {
    return RegExp(r"^(https?:\/\/)[^\s]+").hasMatch(s);
  }

  static String getHtmlAllText(String? htmlString) {
    final doc = parse.parse(htmlString);
    return doc.body!.text;
  }

  static String getSha1(String str) {
    return sha1.convert(utf8.encode(str)).toString();
  }

  /// magick
  static dom.Document getHtmlContentSummary(String? htmlString) {
    final doc = parse.parse(htmlString);

    List<dom.Element> summary = [];
    int textLen = 0;
    doc.body!.children.forEach((element) {
      if (textLen >= 240) {
        return;
      }
      if (element.children.length == 0) {
        if (element.text != "") {
          textLen = textLen + element.text.length;
          summary.add(element);
        }
      } else {
        element.children.forEach((element) {
          if (textLen >= 240) {
            return;
          }
          if (element.text != "") {
            if (element.localName == "code" && element.text.length > 120) {
              element.text = element.text.substring(0, 120);
              element.text += "...";
            }
            textLen = textLen + element.text.length;
            summary.add(element);
          }
        });
      }
    });
    summary.add(dom.Element.html("<p>...</p>"));
    final d = dom.Document.html("<body></body>")..body!.children.addAll(summary);
    return d;
  }
}
