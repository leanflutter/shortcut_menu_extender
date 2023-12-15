import 'package:shortcut_menu_extender_platform_interface/shortcut_menu_extender_platform_interface.dart';

class ShortcutMenuExtender {
  Future<String?> getPlatformVersion() {
    return ShortcutMenuExtenderPlatform.instance.getPlatformVersion();
  }
}
