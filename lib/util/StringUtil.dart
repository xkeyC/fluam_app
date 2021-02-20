import 'package:html/parser.dart' show parse;

class StringUtil {
  static bool isHTTPSUrl(String s) {
    return RegExp(r"^(https?:\/\/)[^\s]+").hasMatch(s);
  }

  static String getHtmlAllText(String htmlString) {
    final doc = parse(htmlString);
    return doc.body.text;
  }
}
