// Dart imports:

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flex_color_scheme/flex_color_scheme.dart';

// Project imports:
import 'package:network_arch/theme/theme.dart';

abstract class Themes {
  // ignore: avoid-global-state
  static List<FlexSchemeData> schemesListWithDynamic = [
    // Fallback scheme that will get replaced if device supports dynamic colors
    FlexSchemeData(
      name: 'Fallback',
      description:
          'Fallback scheme if your device does not support dynamic colors (Android 12+)',
      light: FlexSchemeColor.from(
        primary: Colors.blue,
        brightness: Brightness.light,
      ),
      dark: FlexSchemeColor.from(
        primary: Colors.blue,
        brightness: Brightness.dark,
      ),
    ),

    ...FlexColor.schemesList,
  ];

  static ThemeData getLightThemeDataFor(CustomFlexScheme flexScheme) {
    return FlexThemeData.light(
      colors: schemesListWithDynamic[flexScheme.index].light,
      useMaterial3: true,
      useMaterial3ErrorColors: true,
      subThemesData: const FlexSubThemesData(inputDecoratorRadius: 20),
      appBarStyle: FlexAppBarStyle.background,
      appBarOpacity: 0,
      blendLevel: 5,
    );
  }

  static ThemeData getDarkThemeDataFor(CustomFlexScheme flexScheme) {
    return FlexThemeData.dark(
      colors: schemesListWithDynamic[flexScheme.index].dark,
      useMaterial3: true,
      useMaterial3ErrorColors: true,
      subThemesData: const FlexSubThemesData(inputDecoratorRadius: 20),
      surfaceMode: FlexSurfaceMode.level,
      appBarStyle: FlexAppBarStyle.background,
      appBarOpacity: 0,
      blendLevel: 20,
    );
  }

  static const CupertinoThemeData cupertinoLightThemeData = CupertinoThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: CupertinoColors.systemGrey6,
  );

  static const CupertinoThemeData cupertinoDarkThemeData = CupertinoThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: CupertinoColors.black,
  );

  static const CupertinoDynamicColor iOSlightBgColor =
      CupertinoColors.systemGrey6;
  static const Color iOSdarkBgColor = CupertinoColors.black;
  static const CupertinoDynamicColor iOSbgColor =
      CupertinoDynamicColor.withBrightness(
    color: iOSlightBgColor,
    darkColor: iOSdarkBgColor,
  );

  static final CupertinoDynamicColor iOSCardColor =
      CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.systemGrey6.darkColor,
  );

  static final CupertinoDynamicColor iOSOnboardingBgColor =
      CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.systemGrey6.darkColor,
  );

  // https://github.com/flutter/flutter/issues/48438
  static const iOStextColor = CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.black,
    darkColor: CupertinoColors.white,
  );

  static Color getPlatformIconColor(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? const CupertinoDynamicColor.withBrightness(
            color: CupertinoColors.black,
            darkColor: CupertinoColors.white,
          )
        : Theme.of(context).colorScheme.onSurface;
  }

  static Color getPlatformSuccessColor(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoDynamicColor.resolve(
            CupertinoColors.systemGreen,
            context,
          )
        : Colors.green;
  }

  static Color getPlatformErrorColor(BuildContext context) {
    return Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoDynamicColor.resolve(
            CupertinoColors.systemRed,
            context,
          )
        : Theme.of(context).colorScheme.error;
  }
}
