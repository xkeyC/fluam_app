class StringUtil {
  static bool isHTTPSUrl(String s) {
    return RegExp(r"^(https?:\/\/)[^\s]+").hasMatch(s);
  }
}
