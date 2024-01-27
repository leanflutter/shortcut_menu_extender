import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shortcut_menu_extender_platform_interface/src/shortcut_menu_extender_platform.dart';
import 'package:shortcut_menu_extender_platform_interface/src/shortcut_menu_listener.dart';

/// An implementation of [ShortcutMenuExtenderPlatform] that uses method channels.
class MethodChannelShortcutMenuExtender extends ShortcutMenuExtenderPlatform {
  final ObserverList<ShortcutMenuListener> _listeners =
      ObserverList<ShortcutMenuListener>();

  List<ShortcutMenuListener> get listeners {
    final List<ShortcutMenuListener> localListeners =
        List<ShortcutMenuListener>.from(_listeners);
    return localListeners;
  }

  Map<String, dynamic> _parseArgs(String argsRawString) {
    final args = argsRawString.split('\n');
    final Map<String, dynamic> map = {};
    for (final arg in args) {
      if (arg.isEmpty) continue;
      final keyValue = arg.split('=');
      map[keyValue.first.toLowerCase()] = keyValue.last;
    }
    return map;
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    for (final ShortcutMenuListener listener in listeners) {
      if (!_listeners.contains(listener)) {
        return;
      }
      if (call.method == 'onShortcutMenuClicked') {
        final args = _parseArgs(call.arguments['raw_args'] as String);
        listener.onShortcutMenuClicked(
          args['key'],
          args['path'],
        );
      } else {
        throw UnimplementedError();
      }
    }
  }

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('shortcut_menu_extender');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  void addListener(ShortcutMenuListener listener) {
    _listeners.add(listener);
    if (_listeners.isNotEmpty) {
      methodChannel.setMethodCallHandler(_handleMethodCall);
    }
  }

  @override
  void removeListener(ShortcutMenuListener listener) {
    _listeners.remove(listener);
    if (_listeners.isEmpty) {
      methodChannel.setMethodCallHandler(null);
    }
  }
}
