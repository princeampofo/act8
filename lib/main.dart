import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: SwipeableScreens(
        isDarkMode: _isDarkMode,
        onThemeToggle: toggleTheme,
      ),
    );
  }
}

class SwipeableScreens extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  const SwipeableScreens({super.key, required this.isDarkMode, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        FadingTextAnimation(
          isDarkMode: isDarkMode,
          onThemeToggle: onThemeToggle,
          screenNumber: 1,
        ),
        FadingTextAnimation(
          isDarkMode: isDarkMode,
          onThemeToggle: onThemeToggle,
          screenNumber: 2,
        ),
      ],
    );
  }
}

class FadingTextAnimation extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onThemeToggle;
  final int screenNumber;

  const FadingTextAnimation({super.key, 
    required this.isDarkMode,
    required this.onThemeToggle,
    required this.screenNumber,
  });

  @override
  _FadingTextAnimationState createState() => _FadingTextAnimationState();
}

class _FadingTextAnimationState extends State<FadingTextAnimation> {
  bool _isVisible = true;
  Color _textColor = Colors.black;

  void toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void showColorPicker() {
    Color tempColor = _textColor;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Choose Text Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _textColor,
              onColorChanged: (color) {
                tempColor = color;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _textColor = tempColor;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Select'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int duration = widget.screenNumber == 1 ? 1 : 3;
    String text = widget.screenNumber == 1 ? 'Hello, Flutter!' : 'Very Slow Fade Animation';

    return Scaffold(
      appBar: AppBar(
        title: Text('Fading Text Animation ${widget.screenNumber}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: showColorPicker,
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.nightlight_round : Icons.wb_sunny),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: toggleVisibility,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: AnimatedOpacity(
                  opacity: _isVisible ? 1.0 : 0.0,
                  duration: Duration(seconds: duration),
                  curve: Curves.easeInOut,
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 24, color: _textColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Light'),
                Switch(
                  value: widget.isDarkMode,
                  onChanged: (value) {
                    widget.onThemeToggle();
                  },
                ),
                const Text('Dark'),
              ],
            ),
            const SizedBox(height: 30),
            const Text(
              'Swipe left or right to change screen',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: toggleVisibility,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}