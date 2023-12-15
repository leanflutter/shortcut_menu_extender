#include "include/shortcut_menu_extender_windows/shortcut_menu_extender_windows_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "shortcut_menu_extender_windows_plugin.h"

void ShortcutMenuExtenderWindowsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  shortcut_menu_extender_windows::ShortcutMenuExtenderWindowsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
