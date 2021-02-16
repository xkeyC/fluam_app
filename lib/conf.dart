class AppConf {
  static bool _isDesktop = false;

  static bool get isDesktop => _isDesktop;

  static void setDesktop() {
    _isDesktop = true;
  }
}
