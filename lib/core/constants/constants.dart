import 'package:flutter/material.dart';

class Constants {
  static const String appName = 'MyApp';
  static const String appVersion = '1.0.0';
  static const String apiBaseUrl = 'https://api.example.com';
  static const int defaultTimeout = 30; // in seconds
  static const String defaultLanguage = 'en';
  static const String defaultCurrency = 'USD';

  // Add more constants as needed
  static const String defaultTheme = 'light';
  static const String defaultLocale = 'en_US';
  static const String defaultDateFormat = 'yyyy-MM-dd';
  static const String defaultTimeFormat = 'HH:mm:ss';
  static const String defaultDateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String defaultApiKey = 'your_api_key_here';
  static const String defaultApiSecret = 'your_api_secret_here';
  static const String defaultUserAgent = 'MyApp/1.0.0';
  static const String defaultAcceptLanguage = 'en-US,en;q=0.9';
  static const String defaultContentType = 'application/json';
  static const String defaultAccept = 'application/json';
}

//colors
Color backgroundColor = const Color(0xFFF1F2F6);
Color shadowColor = const Color(0xFFDADFF0);
Color blueShade = const Color(0xFF4D3FB4);
Color lightBlueShade = const Color(0xFF027FFF);
Color blueBackground = const Color(0xFF7026ED);
Color lightShadowColor = Colors.white;
Color textColor = const Color(0xFF707070);
Color seekBarLightColor = const Color(0xFFB8ECED);
Color seekBarDarkColor = const Color(0xFF37C8DF);

class AppImages {
  static const imageList = {
    0: 'assets/images/1.png',
    1: 'assets/images/2.png',
    2: 'assets/images/3.png',
    3: 'assets/images/4.png',
    4: 'assets/images/5.png',
    5: 'assets/images/6.png',
    6: 'assets/images/7.png',
    7: 'assets/images/8.png',
    8: 'assets/images/9.png',
    9: 'assets/images/10.png',
    10: 'assets/images/11.png',
    11: 'assets/images/12.png',
    12: 'assets/images/13.png',
    13: 'assets/images/14.png',
  };
}

class AppSvg {
  static const drawer = 'assets/svgs/drawer.svg';
  static const loop = 'assets/svgs/loop.svg';
  static const more = 'assets/svgs/more.svg';
  static const next = 'assets/svgs/next.svg';
  static const notification = 'assets/svgs/notification.svg';
  static const pause = 'assets/svgs/pause.svg';
  static const play = 'assets/svgs/play.svg';
  static const prev = 'assets/svgs/prev.svg';
  static const search = 'assets/svgs/search.svg';
}

class AppIcons {
  static const splashIcons = 'assets/icons/splashIcon.png';
}
