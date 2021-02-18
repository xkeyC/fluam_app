class AppConf {
  static bool _isDesktop = false;

  static void setDesktop() {
    _isDesktop = true;
  }

  /// if true,the UI will be Desktop mode.
  static bool get isDesktop => _isDesktop;
}
