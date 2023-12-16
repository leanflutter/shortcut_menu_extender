import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:shortcut_menu_extender_platform_interface/shortcut_menu_extender_platform_interface.dart';
import 'package:win32/win32.dart';

class ShortcutMenuExtenderWindows extends ShortcutMenuExtenderPlatform {
  /// Registers the Windows implementation.
  static void registerWith() {
    ShortcutMenuExtenderPlatform.instance = ShortcutMenuExtenderWindows();
  }

  @override
  Future<void> register(
    String key, {
    required String name,
    required String executable,
    String? icon,
  }) async {
    await _runWithAdministrator(Platform.resolvedExecutable, [
      'shortcut_menu_extender_register',
      '--key',
      key,
      '--name',
      name,
      '--icon',
      icon ?? '$executable,0',
      '--executable',
      '$executable %1',
    ]);
  }

  @override
  Future<void> unregister(String key) async {
    await _runWithAdministrator(
      Platform.resolvedExecutable,
      [
        'shortcut_menu_extender_unregister',
        '--key',
        key,
      ],
    );
  }

  Future<void> _runWithAdministrator(
    String executable,
    List<String> args,
  ) async {
    final psi = calloc<SHELLEXECUTEINFO>();
    psi.ref.cbSize = sizeOf<SHELLEXECUTEINFO>();
    psi.ref.lpFile = TEXT(executable);
    psi.ref.lpParameters = TEXT(args.join(' '));
    psi.ref.nShow = SW_SHOWNORMAL;
    psi.ref.lpVerb = TEXT('runas');
    if (ShellExecuteEx(psi) == 0) {
      free(psi);
      return Future.error('Failed to execute as admin');
    }

    WaitForSingleObject(psi.ref.hProcess, INFINITE);
    final exitCode = calloc<Uint32>();
    GetExitCodeProcess(psi.ref.hProcess, exitCode);
    CloseHandle(psi.ref.hProcess);
    free(psi);
    return exitCode.value == 0
        ? Future.value()
        : Future.error('Failed to execute as admin');
  }
}
