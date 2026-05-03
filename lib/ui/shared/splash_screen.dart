import 'dart:async';

import 'package:flutter/material.dart';

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _showSplash = true;
  bool _splashRemoved = false;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => _showSplash = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (!_splashRemoved)
          AnimatedOpacity(
            opacity: _showSplash ? 1 : 0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            onEnd: () {
              if (!_showSplash && mounted) {
                setState(() => _splashRemoved = true);
              }
            },
            child: const SplashScreen(),
          ),
      ],
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  // Background color matching the dark icon
  static const Color _bgColor = Color(0xFF00300F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/bugamed_icon_dark.png',
              width: 160,
              height: 160,
            ),
            const SizedBox(height: 24),
            const Text(
              'BUGAMED',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}