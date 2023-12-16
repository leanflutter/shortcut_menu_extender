import 'package:args/args.dart';
import 'package:win32_registry/win32_registry.dart';

const _kCommandRegister = 'shortcut_menu_extender_register';
const _kCommandUnregister = 'shortcut_menu_extender_unregister';

/// Register shortcut menu.
void registerShortcutMenu(
  String key, {
  required String name,
  required String executable,
  String? icon,
}) {
  String keyForFile = '*\\shell\\$key';
  final regKeyForFile = Registry.classesRoot.createKey(keyForFile);
  regKeyForFile.createValue(RegistryValue(
    '',
    RegistryValueType.string,
    name,
  ));
  final regKeyForFileCommand = regKeyForFile.createKey('command');
  regKeyForFileCommand.createValue(RegistryValue(
    '',
    RegistryValueType.string,
    '$executable "%1"',
  ));
  if (icon != null) {
    regKeyForFile.createValue(RegistryValue(
      'Icon',
      RegistryValueType.string,
      icon,
    ));
  }
}

/// Unregister shortcut menu.
void unregisterShortcutMenu(String key) {
  String keyForFile = '*\\shell\\$key';
  Registry.classesRoot.deleteKey(keyForFile, recursive: true);
}

class ShortcutMenuExtenderCommand {
  final ArgParser argParser = ArgParser()
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
    final results = argParser.parse(args);
    final command = results.command;
    if (command == null) return false;
    switch (command.name) {
      case _kCommandRegister:
        registerShortcutMenu(
          command['key']!,
          name: command['name']!,
          executable: command['executable']!,
          icon: command['icon'],
        );
        break;
      case _kCommandUnregister:
        unregisterShortcutMenu(
          command['key']!,
        );
        break;
      default:
        return false;
    }
    return true;
  }
}

final shortcutMenuExtenderCommand = ShortcutMenuExtenderCommand();
