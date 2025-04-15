import 'package:args/args.dart';
import 'package:win32_registry/win32_registry.dart';

const _kCommandMain = 'shortcut_menu_extender';
const _kCommandRegister = 'shortcut_menu_extender_register';
const _kCommandUnregister = 'shortcut_menu_extender_unregister';

/// Register shortcut menu.
void registerShortcutMenu(
  String key, {
  required String name,
  required String executable,
  String? icon,
}) {
  final regValueMenu = RegistryValue.string(
    '',
    name,
  );
  final regValueMenuIcon = RegistryValue.string(
    'Icon',
    icon ?? '',
  );
  final regValueMenuCommand = RegistryValue.string(
    '',
    '$executable shortcut_menu_extender --key $key --path "%1"',
  );
  // Register shortcut menu for file.
  final regKeyForFile = Registry.classesRoot.createKey('*\\shell\\$key');
  regKeyForFile.createValue(regValueMenu);
  if ((icon ?? '').isNotEmpty) {
    regKeyForFile.createValue(regValueMenuIcon);
  }
  final regKeyForFileCommand = regKeyForFile.createKey('command');
  regKeyForFileCommand.createValue(regValueMenuCommand);

  // Register shortcut menu for folder.
  final regKeyForFolder = Registry.classesRoot.createKey('Folder\\shell\\$key');
  regKeyForFolder.createValue(regValueMenu);
  if ((icon ?? '').isNotEmpty) {
    regKeyForFolder.createValue(regValueMenuIcon);
  }
  final regKeyForFolderCommand = regKeyForFolder.createKey('command');
  regKeyForFolderCommand.createValue(regValueMenuCommand);
}

/// Unregister shortcut menu.
void unregisterShortcutMenu(String key) {
  // Unregister shortcut menu for file.
  final String keyForFile = '*\\shell\\$key';
  Registry.classesRoot.deleteKey(keyForFile, recursive: true);

  // Unregister shortcut menu for folder.
  final String keyForFolder = 'Folder\\shell\\$key';
  Registry.classesRoot.deleteKey(keyForFolder, recursive: true);
}

class ShortcutMenuExtenderCommand {
  final ArgParser argParser = ArgParser()
    ..addCommand(_kCommandMain, ArgParser())
    ..addCommand(
      _kCommandRegister,
      ArgParser()
        ..addOption('key')
        ..addOption('name')
        ..addOption('icon')
        ..addOption('executable'),
    )
    ..addCommand(
      _kCommandUnregister,
      ArgParser()..addOption('key'),
    );

  /// Run command if needed.
  bool runIfNeeded(List<String> args) {
    try {
      final results = argParser.parse(args);
      final command = results.command;
      switch (command?.name) {
        case _kCommandRegister:
          registerShortcutMenu(
            command?['key']!,
            name: Uri.decodeQueryComponent(command?['name']!),
            executable: command?['executable']!,
            icon: command?['icon'],
          );
          return true;
        case _kCommandUnregister:
          unregisterShortcutMenu(
            command?['key']!,
          );
          return true;
      }
    } catch (_) {}
    return false;
  }
}

final shortcutMenuExtenderCommand = ShortcutMenuExtenderCommand();
