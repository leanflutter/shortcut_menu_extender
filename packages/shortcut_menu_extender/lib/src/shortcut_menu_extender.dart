import 'package:shortcut_menu_extender_platform_interface/shortcut_menu_extender_platform_interface.dart';

class ShortcutMenuExtender {
  Future<String?> getPlatformVersion() {
    return ShortcutMenuExtenderPlatform.instance.getPlatformVersion();
  }

  Future<void> register(
    String key, {
    required String name,
    required String executable,
    String? icon,
  }) {
    return ShortcutMenuExtenderPlatform.instance.register(
      key,
      name: name,
      executable: executable,
    );
  }

  Future<void> unregister(String key) {
    return ShortcutMenuExtenderPlatform.instance.unregister(key);
  }
}

final shortcutMenuExtender = ShortcutMenuExtender();
