import 'package:volo_meeting/index.dart';

extension PlatformExtension on UniversalPlatform {
  static final isMobile =
      UniversalPlatform.isAndroid || UniversalPlatform.isIOS;
}

extension BuildContextExtension on BuildContext {
  Future<T?> push<T extends Object?>(Widget page) =>
      Navigator.push(this, CupertinoPageRoute<T>(builder: (_) => page));

  void pop<T extends Object?>([T? result]) => Navigator.pop(this, result);

  Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
    Widget page, {
    TO? result,
  }) =>
      Navigator.pushReplacement(
        this,
        CupertinoPageRoute<T>(
          builder: (_) => page,
          settings: RouteSettings(arguments: result),
        ),
      );

  Future<T?> pushAndRemoveRoot<T extends Object?>(Widget page) =>
      Navigator.pushAndRemoveUntil(
        this,
        CupertinoPageRoute<T>(builder: (_) => page),
        (_) => false,
      );

  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Brightness get brightness => colorScheme.brightness;
}

extension BrightnessExtension on Brightness {
  bool get isDark => this == Brightness.dark;
  bool get isLight => this == Brightness.light;
}

extension DynamicExtension on dynamic {
  bool get isNull => this == null;
  bool get isNotNull => this != null;
}
