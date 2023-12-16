import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shortcut_menu_extender_platform_interface/src/method_channel_shortcut_menu_extender.dart';

abstract class ShortcutMenuExtenderPlatform extends PlatformInterface {
  /// Constructs a ShortcutMenuExtenderPlatform.
  ShortcutMenuExtenderPlatform() : super(token: _token);

  static final Object _token = Object();

  static ShortcutMenuExtenderPlatform _instance =
      MethodChannelShortcutMenuExtender();

  /// The default instance of [ShortcutMenuExtenderPlatform] to use.
  ///
  /// Defaults to [MethodChannelShortcutMenuExtender].
  static ShortcutMenuExtenderPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ShortcutMenuExtenderPlatform] when
  /// they register themselves.
  static set instance(ShortcutMenuExtenderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> register(
    String key, {
    required String name,
    required String executable,
    String? icon,
  }) {
    throw UnimplementedError('register() has not been implemented.');
  }

  Future<void> unregister(String key) {
    throw UnimplementedError('register() has not been implemented.');
  }
}
