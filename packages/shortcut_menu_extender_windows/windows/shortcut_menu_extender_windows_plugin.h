#ifndef FLUTTER_PLUGIN_SHORTCUT_MENU_EXTENDER_WINDOWS_PLUGIN_H_
#define FLUTTER_PLUGIN_SHORTCUT_MENU_EXTENDER_WINDOWS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace shortcut_menu_extender_windows {

class ShortcutMenuExtenderWindowsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ShortcutMenuExtenderWindowsPlugin();

  virtual ~ShortcutMenuExtenderWindowsPlugin();

  // Disallow copy and assign.
  ShortcutMenuExtenderWindowsPlugin(const ShortcutMenuExtenderWindowsPlugin&) = delete;
  ShortcutMenuExtenderWindowsPlugin& operator=(const ShortcutMenuExtenderWindowsPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace shortcut_menu_extender_windows

#endif  // FLUTTER_PLUGIN_SHORTCUT_MENU_EXTENDER_WINDOWS_PLUGIN_H_
