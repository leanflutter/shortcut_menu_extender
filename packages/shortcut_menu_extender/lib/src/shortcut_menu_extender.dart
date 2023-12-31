import 'package:shortcut_menu_extender_platform_interface/shortcut_menu_extender_platform_interface.dart';

class ShortcutMenuExtender {
  Future<String?> getPlatformVersion() {
    return ShortcutMenuExtenderPlatform.instance.getPlatformVersion();
  }

  Future<void> register(
    String key, {
    required String name,
    required String executable,
    bool useDefaultIcon = true,
  }) {
    return ShortcutMenuExtenderPlatform.instance.register(
      key,
      name: name,
      executable: executable,
      useDefaultIcon: useDefaultIcon,
    );
  }

  Future<void> unregister(String key) {
    return ShortcutMenuExtenderPlatform.instance.unregister(key);
  }

  void addListener(ShortcutMenuListener listener) {
    return ShortcutMenuExtenderPlatform.instance.addListener(listener);
  }

  void removeListener(ShortcutMenuListener listener) {
    return ShortcutMenuExtenderPlatform.instance.removeListener(listener);
  }
}

final shortcutMenuExtender = ShortcutMenuExtender();
