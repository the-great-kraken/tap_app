import 'dart:math';

import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

/// Main class
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  static const int _divider = 2;

  /// Limit for random
  static const int _limit = 255;
  static const double _tweenEnd = 4.0;

  Color _backgroundColor = const Color.fromARGB(255, 0, 0, 0);
  Color _newColor = const Color.fromARGB(255, 255, 255, 255);

  Offset _touchPoint = Offset.zero;

  late AnimationController _newColorScaleController;
  late Animation<double> _newColorScale;

  @override
  void initState() {
    _newColorScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _newColorScale =
        Tween(begin: 0.0, end: _tweenEnd).animate(_newColorScaleController);

    /// Show a message at startup
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Tap on the screen!",
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 18,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
    super.initState();
  }

  /// Generate random RGB color
  Color _getRandomColor() => Color.fromARGB(
        _limit,
        Random().nextInt(_limit),
        Random().nextInt(_limit),
        Random().nextInt(_limit),
      );

  /// Change background color
  void _updateColor(TapDownDetails details) {
    setState(() {
      _touchPoint = details.localPosition;
    });
    _newColorScaleController.reset();
    _newColorScaleController.forward().then((anim) {
      setState(() {
        _backgroundColor = _newColor;
      });
    });
    _newColor = _getRandomColor();
  }

  /// Play sound
  void _playSound() {
    Audio.load('assets/click.wav')
      ..play()
      ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: GestureDetector(
        onTapDown: (details) {
          _updateColor(details);
          _playSound();
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: _backgroundColor,
          child: Stack(
            children: <Widget>[
              Positioned(
                left: _touchPoint.dx -
                    MediaQuery.of(context).size.width / _divider,
                top: _touchPoint.dy -
                    MediaQuery.of(context).size.height / _divider,
                child: ScaleTransition(
                  scale: _newColorScale,
                  child: SingleChildScrollView(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: _newColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Hey there!',
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
