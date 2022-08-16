import 'package:flutter/material.dart';
import 'package:flutter_dark_light_mode/providers/display_mode_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // Brightness? _brightness;
  late DisplayModeProvider _displayModeProvider;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _displayModeProvider = DisplayModeProvider();
    _displayModeProvider.brightnessMode =
        WidgetsBinding.instance.window.platformBrightness;
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      _displayModeProvider.brightnessMode =
          WidgetsBinding.instance.window.platformBrightness;
    }

    super.didChangePlatformBrightness();
  }

  ThemeData get _lightTheme => ThemeData(
        brightness: Brightness.light, // light theme settings
      );

  ThemeData get _darkTheme => ThemeData(
        brightness: Brightness.dark, // dark theme settings
      );

  @override
  Widget build(BuildContext context) {
    return ListenableProvider.value(
      value: _displayModeProvider,
      child: Builder(builder: (context) {
        final displayModeProvider = Provider.of<DisplayModeProvider>(
          context,
          listen: true,
        );
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: displayModeProvider.brightness == Brightness.light
              ? _lightTheme
              : _darkTheme,
          home: const MyHomePage(
            title: '',
          ),
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Mode:',
            ),
            Consumer<DisplayModeProvider>(
              builder: (_, displayModeProvider, __) {
                return Text(
                  displayModeProvider.brightness == Brightness.light
                      ? 'Light'
                      : 'Dark',
                  style: Theme.of(context).textTheme.headline4?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: context.read<DisplayModeProvider>().switchBrightness,
        tooltip: 'Increment',
        child: const Icon(
          Icons.sunny,
        ),
      ),
    );
  }
}
