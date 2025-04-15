import 'dart:io';

abstract class PlatformInfo {
  static bool get isDesktop =>
      Platform.isWindows || Platform.isLinux || Platform.isMacOS;
}
