import 'package:flutter/material.dart';

/// Shared UI for all demos. Includes the back button and a background color.
/// It also implements [ClipRect] to prevent the carousel from drawing outside
/// it's bounds, and a [RepaintBoundary] to optimize paint performance and
/// reduce visual artifacts.

class DemoChrome extends StatelessWidget {
  const DemoChrome({super.key, required this.body, this.backgroundColor});

  final Widget body;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ClipRect(
        child: Stack(children: [
          RepaintBoundary(child: body),
          SafeArea(
            minimum: const EdgeInsets.only(top: 8.0),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(999),
                ),
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(left: 16),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
