import 'package:flutter/material.dart';

makeAppBar(BuildContext context,
    {bool showBackButton = false,
    Widget title,
    List<Widget> actions,
    bool centerTitle = false}) {
  Color backgroundColor = getAppbarBackGroundColor(context);
  Color textColor =
      backgroundColor.computeLuminance() < 0.5 ? Colors.white : Colors.black;
  return AppBar(
    backgroundColor: backgroundColor,
    brightness: Theme.of(context).brightness,
    elevation: 4,
    leading: showBackButton
        ? IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: textColor,
            ),
            tooltip: "[BACK]",
            onPressed: () {
              Navigator.pop(context);
            })
        : null,
    title: title,
    centerTitle: centerTitle,
    actions: actions,
  );
}

Widget makeTitleText(BuildContext context, String text, {TextAlign textAlign}) {
  return Text(
    text,
    style: TextStyle(color: getTextColor(context)),
    textAlign: textAlign,
  );
}

Color getTextColor(BuildContext context) {
  Color backgroundColor = getAppbarBackGroundColor(context);
  return getTextColorWithBackgroundColor(context, backgroundColor);
}

Color getTextColorWithBackgroundColor(
    BuildContext context, Color backgroundColor) {
  return backgroundColor.computeLuminance() < 0.4 ? Colors.white : Colors.black;
}

Color getAppbarBackGroundColor(BuildContext context) {
  return isDarkMode(context) ? Theme.of(context).primaryColor : Colors.white;
}

Color getScaffoldBackground(BuildContext context) {
  return isDarkMode(context)
      ? Theme.of(context).primaryColor
      : Color.fromARGB(255, 242, 241, 246);
}

MaterialColor materialColorWhite = const MaterialColor(
  0xFFFFFFFF,
  const <int, Color>{
    50: const Color(0xFFFFFFFF),
    100: const Color(0xFFFFFFFF),
    200: const Color(0xFFFFFFFF),
    300: const Color(0xFFFFFFFF),
    400: const Color(0xFFFFFFFF),
    500: const Color(0xFFFFFFFF),
    600: const Color(0xFFFFFFFF),
    700: const Color(0xFFFFFFFF),
    800: const Color(0xFFFFFFFF),
    900: const Color(0xFFFFFFFF),
  },
);

bool isDarkMode(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark;
}

const RadiusDialogShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15)));
