// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:wiredash/wiredash.dart';

// Project imports:
import 'package:network_arch/constants.dart';
import 'package:network_arch/dns_lookup/dns_lookup.dart';
import 'package:network_arch/home.dart';
import 'package:network_arch/ip_geo/ip_geo.dart';
import 'package:network_arch/lan_scanner/lan_scanner.dart';
import 'package:network_arch/network_status/network_status.dart';
import 'package:network_arch/package_info/package_info.dart';
import 'package:network_arch/permissions/permissions.dart';
import 'package:network_arch/ping/ping.dart';
import 'package:network_arch/shared/shared_widgets.dart';
import 'package:network_arch/theme/theme.dart';
import 'package:network_arch/wake_on_lan/wake_on_lan.dart';
import 'package:network_arch/whois/whois.dart';

class App extends StatelessWidget {
  App({super.key});

  final NetworkStatusRepository networkStatusRepository =
      NetworkStatusRepository();
  final pingRepository = PingRepository();
  final lanScannerRepository = LanScannerRepository();
  final ipGeoRepository = IpGeoRepository();
  final whoisRepository = WhoisRepository();
  final dnsLookupRepository = DnsLookupRepository();

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: networkStatusRepository),
        RepositoryProvider.value(value: pingRepository),
        RepositoryProvider.value(value: lanScannerRepository),
        RepositoryProvider.value(value: ipGeoRepository),
        RepositoryProvider.value(value: whoisRepository),
        RepositoryProvider.value(value: dnsLookupRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeBloc(),
          ),
          BlocProvider(
            create: (context) => PermissionsBloc(),
          ),
          BlocProvider(
            create: (context) => PackageInfoCubit(),
          ),
          BlocProvider(
            create: (context) => NetworkStatusBloc(networkStatusRepository),
          ),
          BlocProvider(
            create: (context) => PingBloc(pingRepository),
          ),
          BlocProvider(
            create: (context) => LanScannerBloc(lanScannerRepository),
          ),
          BlocProvider(
            create: (context) => WakeOnLanBloc(),
          ),
          BlocProvider(
            create: (context) => IpGeoBloc(ipGeoRepository),
          ),
          BlocProvider(
            create: (context) => WhoisBloc(whoisRepository),
          ),
          BlocProvider(
            create: (context) => DnsLookupBloc(dnsLookupRepository),
          ),
        ],
        child: PlatformWidget(
          androidBuilder: _buildAndroid,
          iosBuilder: _buildIOS,
        ),
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    Themes.schemesListWithDynamic.first =
        context.read<ThemeBloc>().state.dynamicScheme ??
            Themes.schemesListWithDynamic.first;

    return DynamicColorBuilder(
      // ignore: prefer-extracting-callbacks
      builder: (lightDynamic, darkDynamic) {
        handleDynamicColors(lightDynamic, darkDynamic, context);

        return BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            final themeData = Themes.getLightThemeDataFor(state.scheme);
            final darkThemeData = Themes.getDarkThemeDataFor(state.scheme);

            return Wiredash(
              projectId: 'networkarch-jto3hyq',
              secret: 'wCFJdv9cYZqN1lnX6nIukcXx9qYQwhPA',
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorObservers: [
                  SentryNavigatorObserver(),
                ],
                title: Constants.appName,
                theme: themeData,
                darkTheme: darkThemeData,
                themeMode: state.mode,
                routes: Constants.routes,
                home: const Home(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildIOS(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Wiredash(
          projectId: 'networkarch-jto3hyq',
          secret: 'wCFJdv9cYZqN1lnX6nIukcXx9qYQwhPA',
          child: CupertinoApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              DefaultMaterialLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
            ],
            navigatorObservers: [
              SentryNavigatorObserver(),
            ],
            title: Constants.appName,
            theme: state.mode == ThemeMode.light
                ? Themes.cupertinoLightThemeData
                : Themes.cupertinoDarkThemeData,
            routes: Constants.routes,
            home: const CupertinoScaffold(body: Home()),
          ),
        );
      },
    );
  }

  void handleDynamicColors(
    ColorScheme? lightDynamic,
    ColorScheme? darkDynamic,
    BuildContext context,
  ) {
    if (lightDynamic != null && darkDynamic != null) {
      final lightColorScheme = lightDynamic.harmonized();
      final darkColorScheme = darkDynamic.harmonized();

      final lightFlexSchemeColor = FlexSchemeColor(
        primary: lightColorScheme.primary,
        primaryContainer: lightColorScheme.primaryContainer,
        secondary: lightColorScheme.secondary,
        secondaryContainer: lightColorScheme.secondaryContainer,
        tertiary: lightColorScheme.tertiary,
        tertiaryContainer: lightColorScheme.tertiaryContainer,
        error: lightColorScheme.error,
        errorContainer: lightColorScheme.errorContainer,
      );

      final darkFlexSchemeColor = FlexSchemeColor(
        primary: darkColorScheme.primary,
        primaryContainer: darkColorScheme.primaryContainer,
        secondary: darkColorScheme.secondary,
        secondaryContainer: darkColorScheme.secondaryContainer,
        tertiary: darkColorScheme.tertiary,
        tertiaryContainer: darkColorScheme.tertiaryContainer,
        error: darkColorScheme.error,
        errorContainer: darkColorScheme.errorContainer,
      );

      final newDynamicScheme = FlexSchemeData(
        name: 'System dynamic',
        description: 'Dynamic color theme, based on your system scheme',
        light: lightFlexSchemeColor,
        dark: darkFlexSchemeColor,
      );

      final themeBloc = context.read<ThemeBloc>();
      if (themeBloc.state.dynamicScheme != newDynamicScheme) {
        themeBloc
          ..add(
            ThemeDynamicSchemeChangedEvent(
              newDynamicScheme: newDynamicScheme,
            ),
          )
          ..add(
            const ThemeSchemeChangedEvent(
              scheme: CustomFlexScheme.dynamic,
            ),
          );
      }
    }
  }
}
