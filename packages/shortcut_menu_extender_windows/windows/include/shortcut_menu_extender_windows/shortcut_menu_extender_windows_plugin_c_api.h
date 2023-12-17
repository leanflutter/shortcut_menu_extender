#include <windows.h>

#ifndef FLUTTER_PLUGIN_SHORTCUT_MENU_EXTENDER_WINDOWS_PLUGIN_C_API_H_
#define FLUTTER_PLUGIN_SHORTCUT_MENU_EXTENDER_WINDOWS_PLUGIN_C_API_H_

#include <flutter_plugin_registrar.h>

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FLUTTER_PLUGIN_EXPORT __declspec(dllimport)
#endif

#if defined(__cplusplus)
extern "C" {
#endif

FLUTTER_PLUGIN_EXPORT void
ShortcutMenuExtenderWindowsPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar);

FLUTTER_PLUGIN_EXPORT bool ShouldHandleByShortcutMenuExtender();
FLUTTER_PLUGIN_EXPORT bool ShouldHandleByShortcutMenuExtenderCommand();
#define SHORTCUTMENU_EXTENDER_MSG_ID (WM_USER + 3)
FLUTTER_PLUGIN_EXPORT void DispatchToShortcutMenuExtender(HWND hwnd);

#if defined(__cplusplus)
}  // extern "C"
#endif

#endif  // FLUTTER_PLUGIN_SHORTCUT_MENU_EXTENDER_WINDOWS_PLUGIN_C_API_H_
