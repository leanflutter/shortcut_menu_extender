import 'package:flutter_test/flutter_test.dart';
import 'package:shortcut_menu_extender_windows/src/shortcut_menu_extender_command.dart';

void main() {
  group('argParser', () {
    final argParser = ShortcutMenuExtenderCommand().argParser;
    test('shortcut_menu_extender_register#1', () {
      final results = argParser.parse(['shortcut_menu_extender_register']);
      expect(results.command?.name, 'shortcut_menu_extender_register');
    });
    test('shortcut_menu_extender_register#2', () {
      final results = argParser.parse([
        'shortcut_menu_extender_register',
        '--key',
        'example-key',
        '--name',
        'example-name',
        '--icon',
        'example-icon',
        '--executable',
        'example-executable',
      ]);
      final command = results.command;
      expect(command?.name, 'shortcut_menu_extender_register');
      expect(command?['key'], 'example-key');
      expect(command?['name'], 'example-name');
      expect(command?['icon'], 'example-icon');
      expect(command?['executable'], 'example-executable');
    });
    test('shortcut_menu_extender_unregister#1', () {
      final results = argParser.parse(['shortcut_menu_extender_unregister']);
      expect(results.command?.name, 'shortcut_menu_extender_unregister');
    });
    test('shortcut_menu_extender_unregister#2', () {
      final results = argParser.parse([
        'shortcut_menu_extender_unregister',
        '--key',
        'example-key',
      ]);
      final command = results.command;
      expect(command?.name, 'shortcut_menu_extender_unregister');
      expect(command?['key'], 'example-key');
    });
  });
}
