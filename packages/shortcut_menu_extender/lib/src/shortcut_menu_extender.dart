import 'package:shortcut_menu_extender_platform_interface/shortcut_menu_extender_platform_interface.dart';

/// Extending global shortcut menus.
class ShortcutMenuExtender {
  Future<String?> getPlatformVersion() {
    return ShortcutMenuExtenderPlatform.instance.getPlatformVersion();
  }

  /// Register a shortcut menu.
  ///
  /// [key] is the unique identifier of the shortcut menu.
  /// [name] is the name of the shortcut menu.
  /// [executable] is the executable path of the shortcut menu.
  /// [useDefaultIcon] is whether to use the default icon of the executable file.
  ///
  /// Sample usage:
  ///
  /// ```dart
  /// shortcutMenuExtender.register(
  ///   'MyFlutterApp',
  ///   name: 'Open With MyFlutterApp',
  ///   executable: Platform.resolvedExecutable,
  ///   useDefaultIcon: true,
  /// );
  /// ```
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

  /// Unregister a shortcut menu.
  ///
  /// [key] is the unique identifier of the shortcut menu.
  Future<void> unregister(String key) {
    return ShortcutMenuExtenderPlatform.instance.unregister(key);
  }

  /// Add a listener to listen for shortcut menu events.
  void addListener(ShortcutMenuListener listener) {
    return ShortcutMenuExtenderPlatform.instance.addListener(listener);
  }

  /// Remove a listener.
  void removeListener(ShortcutMenuListener listener) {
    return ShortcutMenuExtenderPlatform.instance.removeListener(listener);
  }
}

final shortcutMenuExtender = ShortcutMenuExtender();
