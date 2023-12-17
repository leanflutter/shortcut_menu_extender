#ifndef FLUTTER_PLUGIN_SHORTCUT_MENU_EXTENDER_WINDOWS_PLUGIN_H_
#define FLUTTER_PLUGIN_SHORTCUT_MENU_EXTENDER_WINDOWS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace shortcut_menu_extender_windows {

class ShortcutMenuExtenderWindowsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows* registrar);

  ShortcutMenuExtenderWindowsPlugin(
      flutter::PluginRegistrarWindows* registrar,
      std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel);

  flutter::MethodChannel<flutter::EncodableValue>* channel() const {
    return channel_.get();
  }

  virtual ~ShortcutMenuExtenderWindowsPlugin();

  // Disallow copy and assign.
  ShortcutMenuExtenderWindowsPlugin(const ShortcutMenuExtenderWindowsPlugin&) =
      delete;
  ShortcutMenuExtenderWindowsPlugin& operator=(
      const ShortcutMenuExtenderWindowsPlugin&) = delete;

  flutter::PluginRegistrarWindows* registrar_;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel_ =
      nullptr;
  int32_t window_proc_id_ = -1;

  std::optional<LRESULT> HandleWindowProc(HWND hwnd,
                                          UINT message,
                                          WPARAM wparam,
                                          LPARAM lparam);

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace shortcut_menu_extender_windows

#define SHORTCUTMENU_EXTENDER_MSG_ID (WM_USER + 3)

#endif  // FLUTTER_PLUGIN_SHORTCUT_MENU_EXTENDER_WINDOWS_PLUGIN_H_
