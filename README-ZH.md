> **🚀 快速发布您的应用**: 试试 [Fastforge](https://fastforge.dev) - 构建、打包和分发您的 Flutter 应用最简单的方式。

# shortcut_menu_extender

[![pub version][pub-image]][pub-url] [![][discord-image]][discord-url] ![][visits-count-image]

[pub-image]: https://img.shields.io/pub/v/shortcut_menu_extender.svg
[pub-url]: https://pub.dev/packages/shortcut_menu_extender
[discord-image]: https://img.shields.io/discord/884679008049037342.svg
[discord-url]: https://discord.gg/zPa6EZ2jqb
[visits-count-image]: https://img.shields.io/badge/dynamic/json?label=Visits%20Count&query=value&url=https://api.countapi.xyz/hit/leanflutter.shortcut_menu_extender/visits

这个插件允许 Flutter 应用扩展全局快捷菜单。

---

[English](./README.md) | 简体中文

---

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [shortcut_menu_extender](#shortcut_menu_extender)
  - [平台支持](#平台支持)
  - [快速开始](#快速开始)
    - [安装](#安装)
    - [用法](#用法)
      - [Windows](#windows)
    - [注册/取消注册](#注册取消注册)
    - [监听事件](#监听事件)
  - [谁在用使用它？](#谁在用使用它)
  - [赞助者](#赞助者)
  - [许可证](#许可证)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## 平台支持

| Linux | macOS | Windows |
| :---: | :---: | :-----: |
|  ➖   |  ➖   |   ✔️    |

## 快速开始

### 安装

将此添加到你的软件包的 pubspec.yaml 文件：

```yaml
dependencies:
  shortcut_menu_extender: ^0.1.1
```

### 用法

##### Windows

更改文件 `windows/runner/main.cpp` 如下：

```diff
#include <flutter/dart_project.h>
#include <flutter/flutter_view_controller.h>
#include <windows.h>

#include "flutter_window.h"
#include "utils.h"

+#include <shortcut_menu_extender_windows/shortcut_menu_extender_windows_plugin_c_api.h>

int APIENTRY wWinMain(_In_ HINSTANCE instance,
                      _In_opt_ HINSTANCE prev,
                      _In_ wchar_t* command_line,
                      _In_ int show_command) {
+  HANDLE instance_mutex =
+      CreateMutex(NULL, TRUE, L"shortcut_menu_extender_example");
+  if (GetLastError() == ERROR_ALREADY_EXISTS &&
+      !ShouldHandleByShortcutMenuExtenderCommand()) {
+    HWND hwnd = ::FindWindow(L"FLUTTER_RUNNER_WIN32_WINDOW",
+                             L"shortcut_menu_extender_example");
+    if (hwnd != NULL && ShouldHandleByShortcutMenuExtender()) {
+      DispatchToShortcutMenuExtender(hwnd);
+    }
+    CloseHandle(instance_mutex);
+    return EXIT_SUCCESS;
+  }

  // Attach to console when present (e.g., 'flutter run') or create a
  // new console when running with a debugger.
  if (!::AttachConsole(ATTACH_PARENT_PROCESS) && ::IsDebuggerPresent()) {
    CreateAndAttachConsole();
  }

  // Initialize COM, so that it is available for use in the library and/or
  // plugins.
  ::CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED);

  flutter::DartProject project(L"data");

  std::vector<std::string> command_line_arguments = GetCommandLineArguments();

  project.set_dart_entrypoint_arguments(std::move(command_line_arguments));

  FlutterWindow window(project);
  Win32Window::Point origin(10, 10);
  Win32Window::Size size(1280, 720);
  if (!window.Create(L"shortcut_menu_extender_example", origin, size)) {
    return EXIT_FAILURE;
  }
  window.SetQuitOnClose(true);

  ::MSG msg;
  while (::GetMessage(&msg, nullptr, 0, 0)) {
    ::TranslateMessage(&msg);
    ::DispatchMessage(&msg);
  }

  ::CoUninitialize();
  return EXIT_SUCCESS;
}
```

```dart
import 'package:shortcut_menu_extender/shortcut_menu_extender.dart';

void main() async {
  // 必须加上这一行。
  WidgetsFlutterBinding.ensureInitialized();

  if (shortcutMenuExtenderCommand.runIfNeeded(args)) exit(0);

  runApp(MyApp());
}
```

### 注册/取消注册

```dart
shortcutMenuExtender.register(
  'MyFlutterApp',
  name: 'Open With MyFlutterApp',
  executable: Platform.resolvedExecutable,
  useDefaultIcon: true,
);

shortcutMenuExtender.unregister(
  'MyFlutterApp',
);
```

### 监听事件

```dart
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with ShortcutMenuListener {
  @override
  void initState() {
    shortcutMenuExtender.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    shortcutMenuExtender.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ...
  }

  @override
  void onShortcutMenuClicked(String key, String path) {
    print('onShortcutMenuClicked: $key, $path');
  }
}
```

> 请看这个插件的示例应用，以了解完整的例子。

## 赞助者

<table>
  <tbody>
    <tr>
      <td align="center" valign="top" width="14.28%"><a href="https://github.com/cmlanche"><img src="https://avatars.githubusercontent.com/u/5886757?v=4?s=100" width="100px;" alt="cmlanche"/><br /><sub><b>cmlanche</b></sub></a></td>
    </tr>
  </tbody>
</table>

## 许可证

[MIT](./LICENSE)
