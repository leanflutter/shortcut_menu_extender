#include "shortcut_menu_extender_windows_plugin.h"
#include "include/shortcut_menu_extender_windows/shortcut_menu_extender_windows_plugin_c_api.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <codecvt>
#include <memory>
#include <sstream>

namespace shortcut_menu_extender_windows {

// static
void ShortcutMenuExtenderWindowsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows* registrar) {
  auto plugin = std::make_unique<ShortcutMenuExtenderWindowsPlugin>(
      registrar,
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "shortcut_menu_extender",
          &flutter::StandardMethodCodec::GetInstance()));

  plugin->channel()->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto& call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

ShortcutMenuExtenderWindowsPlugin::ShortcutMenuExtenderWindowsPlugin(
    flutter::PluginRegistrarWindows* registrar,
    std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> channel)
    : registrar_(registrar), channel_(std::move(channel)) {
  window_proc_id_ = registrar->RegisterTopLevelWindowProcDelegate(
      [this](HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam) {
        return HandleWindowProc(hwnd, message, wparam, lparam);
      });
}

ShortcutMenuExtenderWindowsPlugin::~ShortcutMenuExtenderWindowsPlugin() {}

std::optional<LRESULT> ShortcutMenuExtenderWindowsPlugin::HandleWindowProc(
    HWND hwnd,
    UINT message,
    WPARAM wparam,
    LPARAM lparam) {
  switch (message) {
    case WM_COPYDATA:
      COPYDATASTRUCT* cds = {0};
      cds = (COPYDATASTRUCT*)lparam;

      if (cds->dwData == SHORTCUTMENU_EXTENDER_MSG_ID) {
        std::string raw_args((char*)((LPCWSTR)cds->lpData));

        flutter::EncodableMap args = flutter::EncodableMap();
        args[flutter::EncodableValue("raw_args")] =
            flutter::EncodableValue(raw_args.c_str());

        channel_->InvokeMethod("onShortcutMenuClicked",
                               std::make_unique<flutter::EncodableValue>(args));
      }
      break;
  }
  return std::nullopt;
}

void ShortcutMenuExtenderWindowsPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("getPlatformVersion") == 0) {
    std::ostringstream version_stream;
    version_stream << "Windows ";
    if (IsWindows10OrGreater()) {
      version_stream << "10+";
    } else if (IsWindows8OrGreater()) {
      version_stream << "8";
    } else if (IsWindows7OrGreater()) {
      version_stream << "7";
    }
    result->Success(flutter::EncodableValue(version_stream.str()));
  } else {
    result->NotImplemented();
  }
}

}  // namespace shortcut_menu_extender_windows
