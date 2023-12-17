#include "include/shortcut_menu_extender_windows/shortcut_menu_extender_windows_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "shortcut_menu_extender_windows_plugin.h"

#include <codecvt>

void ShortcutMenuExtenderWindowsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  shortcut_menu_extender_windows::ShortcutMenuExtenderWindowsPlugin::
      RegisterWithRegistrar(
          flutter::PluginRegistrarManager::GetInstance()
              ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}

bool ShouldHandleByShortcutMenuExtender() {
  int argc;
  wchar_t** argv = ::CommandLineToArgvW(::GetCommandLineW(), &argc);
  if (argv == nullptr || argc < 2) {
    return false;
  }

  std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
  std::string command = converter.to_bytes(argv[1]);
  ::LocalFree(argv);

  return command == "shortcut_menu_extender";
}

bool ShouldHandleByShortcutMenuExtenderCommand() {
  int argc;
  wchar_t** argv = ::CommandLineToArgvW(::GetCommandLineW(), &argc);
  if (argv == nullptr || argc < 2) {
    return false;
  }

  std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
  std::string command = converter.to_bytes(argv[1]);
  ::LocalFree(argv);
  return command == "shortcut_menu_extender_register" ||
         command == "shortcut_menu_extender_unregister";
}

void DispatchToShortcutMenuExtender(HWND hwnd) {
  int argc;
  wchar_t** argv = ::CommandLineToArgvW(::GetCommandLineW(), &argc);
  if (argv == nullptr || argc < 2) {
    return;
  }

  std::wstring_convert<std::codecvt_utf8_utf16<wchar_t>> converter;
  std::string key = converter.to_bytes(argv[3]);
  std::string path = converter.to_bytes(argv[5]);
  ::LocalFree(argv);

  std::string raw_args = "";
  raw_args += "KEY=" + key + "\n";
  raw_args += "PATH=" + path + "\n";

  COPYDATASTRUCT cds = {0};
  cds.dwData = SHORTCUTMENU_EXTENDER_MSG_ID;
  cds.cbData = (DWORD)(strlen(raw_args.c_str()) + 1);
  cds.lpData = (PVOID)raw_args.c_str();

  SendMessage(hwnd, WM_COPYDATA, 0, (LPARAM)&cds);
}
