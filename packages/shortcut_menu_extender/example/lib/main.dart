import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:shortcut_menu_extender/shortcut_menu_extender.dart';

const _kShortcutMenuKeyMyFlutterApp = 'MyFlutterApp';
const _kShortcutMenuKeyMyFlutterApp2 = 'MyFlutterApp2';

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();

  if (shortcutMenuExtenderCommand.runIfNeeded(args)) exit(0);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with ShortcutMenuListener {
  String _platformVersion = 'Unknown';
  final _shortcutMenuExtenderPlugin = ShortcutMenuExtender();

  final List<FileSystemEntity> _entities = [];

  @override
  void initState() {
    shortcutMenuExtender.addListener(this);
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    shortcutMenuExtender.removeListener(this);
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _shortcutMenuExtenderPlugin.getPlatformVersion() ??
              'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Text('Running on: $_platformVersion\n'),
            ElevatedButton(
              onPressed: () {
                shortcutMenuExtender.register(
                  _kShortcutMenuKeyMyFlutterApp,
                  name: 'Open with MyFlutterApp',
                  executable: Platform.resolvedExecutable,
                  useDefaultIcon: true,
                );
              },
              child: const Text('register MyFlutterApp'),
            ),
            ElevatedButton(
              onPressed: () {
                shortcutMenuExtender.unregister(
                  _kShortcutMenuKeyMyFlutterApp,
                );
              },
              child: const Text('unregister MyFlutterApp'),
            ),
            ElevatedButton(
              onPressed: () {
                shortcutMenuExtender.register(
                  _kShortcutMenuKeyMyFlutterApp2,
                  name: '用我的FlutterApp打开',
                  executable: Platform.resolvedExecutable,
                  useDefaultIcon: false,
                );
              },
              child: const Text('register 我的MyFlutterApp2'),
            ),
            ElevatedButton(
              onPressed: () {
                shortcutMenuExtender.unregister(
                  _kShortcutMenuKeyMyFlutterApp2,
                );
              },
              child: const Text('unregister 我的FlutterApp2'),
            ),
            Expanded(
              child: ListView(children: [
                for (final entity in _entities)
                  ListTile(
                    title: Text(entity.statSync().type.toString()),
                    subtitle: Text(entity.path),
                  ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onShortcutMenuClicked(String key, String path) {
    if (key == _kShortcutMenuKeyMyFlutterApp) {
      final type = FileSystemEntity.typeSync(path);
      if (type == FileSystemEntityType.file) {
        _entities.add(File(path));
      } else if (type == FileSystemEntityType.directory) {
        _entities.add(Directory(path));
      }
      setState(() {});
    } else if (key == _kShortcutMenuKeyMyFlutterApp2) {
      print('key: $key, path: $path');
    }
  }
}
