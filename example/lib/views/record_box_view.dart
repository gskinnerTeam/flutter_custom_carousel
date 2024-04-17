import 'package:example/views/demo_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Simple, stateless vertical scroller. Mostly just here because it's fun to play with.
///
/// Demonstrates:
/// - a relatively complex [CustomCarousel.effectsBuilder] function using [CustomCarousel.effectsBuilderFromAnimate]
/// - using [CustomCarousel.scrollSpeed] to accelerate the scroll interaction
///
/// Please note: to keep things simple, all demos were built for portrait mode
/// on mobile handsets, without a lot of effort or testing for responsiveness.

class RecordBoxView extends StatelessWidget {
  const RecordBoxView({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoChrome(
      backgroundColor: const Color(0xFF1F1B2E),
      body: SafeArea(
        bottom: false,
        minimum: const EdgeInsets.only(top: 32),
        child: _buildCarousel(),
      ),
    );
  }

  Widget _buildCarousel() {
    List<Widget> items = List.generate(15, (i) => _Card(i));

    // See `card_deck_view.dart` for a fully commented example of using
    // Animate with CustomCarousel.
    return CustomCarousel(
      itemCountBefore: 4,
      itemCountAfter: 4,
      loop: true,
      tapToSelect: false,
      scrollSpeed: 5,
      effectsBuilder: CustomCarousel.effectsBuilderFromAnimate(
        effects: EffectList()
            .tint(begin: 0.5, color: const Color(0xFF1F1B2E))
            .flipV(begin: -0.15, end: 0.5)
            .slideY(end: 0.5)
            .scaleXY(begin: 0.75, curve: Curves.fastEaseInToSlowEaseOut)
            .align(
              begin: const Alignment(0, -1),
              end: const Alignment(0, 1),
              curve: Curves.easeIn,
            ),
      ),
      children: items,
    );
  }
}

class _Card extends StatelessWidget {
  const _Card(this.index, {Key? key}) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/record_box/album-$index.jpg'),
              fit: BoxFit.cover,
            ),
            border: const Border(
              top: BorderSide(color: Colors.white38, width: 2),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
