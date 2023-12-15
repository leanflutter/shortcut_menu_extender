import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shortcut_menu_extender_platform_interface/src/shortcut_menu_extender_platform.dart';

/// An implementation of [ShortcutMenuExtenderPlatform] that uses method channels.
class MethodChannelShortcutMenuExtender extends ShortcutMenuExtenderPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('shortcut_menu_extender');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
