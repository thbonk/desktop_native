/*
  Copyright 2021 Thomas Bonk <thomas@meandmymac.de>

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
*/

import 'dart:io' show Platform;

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

import 'windows/windows_app_theme.dart';

/// An application that uses fluent design.
///
/// A convenience widget that wraps either a MacosApp or FluentApp,
/// depending on the current platform. It initializes its depending on the
/// system settings, either dark or light.
class DesktopApp extends StatelessWidget {
  //---------- Initialization

  const DesktopApp(
      {Key? key,
      required String title,
      required String initialRoute,
      required Map<String, WidgetBuilder> routes})
      : _appTitle = title,
        _initialRoute = initialRoute,
        _routes = routes,
        super(key: key);

  //---------- Private Properties

  final String _appTitle;
  final String _initialRoute;
  final Map<String, WidgetBuilder> _routes;

  static final ValueNotifier<ThemeMode> _themeNotifier = ValueNotifier(ThemeMode.light);

  //---------- StatelessWidget

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _themeNotifier,
      builder: (_, ThemeMode currentMode, __) {
        return Platform.isMacOS ? _macosApp(currentMode) : _windowsApp(currentMode);
      },
    );
  }

  //---------- Private Methods

  MacosApp _macosApp(ThemeMode currentMode) {
    return MacosApp(
      title: _appTitle,
      themeMode: currentMode,
      theme: MacosThemeData.light(),
      darkTheme: MacosThemeData.dark(),
      initialRoute: _initialRoute,
      routes: _routes,
      debugShowCheckedModeBanner: false,
    );
  }

  FluentApp _windowsApp(ThemeMode currentMode) {
    final appTheme = WindowsAppTheme();

    return FluentApp(
      title: _appTitle,
      themeMode: currentMode,
      theme: ThemeData(
        accentColor: appTheme.color,
        brightness: (currentMode == ThemeMode.dark ? Brightness.dark : Brightness.light),
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen() ? 2.0 : 0.0,
        ),
      ),
      initialRoute: _initialRoute,
      routes: _routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
