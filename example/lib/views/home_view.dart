import 'package:example/views/views.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Example showing card vertically scrolling card-based navigation.
///
/// Demonstrates:
/// - using [CustomCarousel.onSettledItemChanged] to update the active card's UI
/// - interacting with items to navigate to other views
///
/// Please note: to keep things simple, all demos were built for portrait mode
/// on mobile handsets, without a lot of effort or testing for responsiveness.

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int? _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: _buildCarousel(),
      ),
    );
  }

  Widget _buildCarousel() {
    List<Widget> items = [];
    for (int i = 0; i < _examples.length; i++) {
      items.add(_ExampleCard(
        example: _examples[i],
        selected: i == _activeIndex,
        key: ValueKey(i),
      ));
    }

    // See `card_deck_view.dart` for a fully commented example of using
    // Animate with CustomCarousel.
    return CustomCarousel(
      alignment: Alignment.center,
      itemCountBefore: 2,
      itemCountAfter: 2,
      scrollSpeed: 1.5,
      loop: true,
      effectsBuilder: CustomCarousel.effectsBuilderFromAnimate(
        effects: EffectList()
            .shimmer(
              delay: 60.ms,
              duration: 140.ms,
              color: Colors.white38,
              angle: 0.3,
            )
            .blurXY(delay: 0.ms, duration: 100.ms, begin: 8)
            .blurXY(delay: 100.ms, end: 8)
            .slideY(delay: 0.ms, duration: 200.ms, begin: -3, end: 3)
            .flipH(begin: -0.3, end: 0.3),
      ),
      onSettledItemChanged: (i) => setState(() => _activeIndex = i),
      children: items,
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({
    Key? key,
    required this.example,
    this.selected = false,
  }) : super(key: key);

  final _ExampleData example;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    Widget card = AspectRatio(
      aspectRatio: 1.125,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: example.color,
          image: DecorationImage(
            image: AssetImage('assets/images/home/${example.id}.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16),
          border: const Border(
            top: BorderSide(color: Colors.white30, width: 2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              example.title,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            if (selected)
              Align(
                alignment: Alignment.bottomRight,
                child: _buildTryBtn(),
              )
          ],
        ),
      ),
    );

    if (selected) {
      card = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _goto(context, example),
          child: card,
        ),
      );
    }

    return card;
  }

  void _goto(BuildContext context, _ExampleData example) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: example.builder),
    );
  }

  Widget _buildTryBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: const Text(
        'Try It →',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
      ),
    ).animate().fadeIn(delay: 100.ms).moveX(begin: -6, curve: Curves.easeOut);
  }
}

class _ExampleData {
  const _ExampleData({
    required this.id,
    required this.title,
    required this.color,
    required this.builder,
  });

  final String id;
  final String title;
  final Color color;
  final WidgetBuilder builder;
}

final List<_ExampleData> _examples = [
  _ExampleData(
    id: 'cover-slider',
    title: 'Cover Slider',
    color: const Color(0xFF4DACF7),
    builder: (_) => const CoverSliderView(),
  ),
  _ExampleData(
    id: 'circular-menu',
    title: 'Circular Menu',
    color: const Color(0xFF71C51C),
    builder: (_) => const CircularMenuView(),
  ),
  _ExampleData(
    id: 'card-deck',
    title: 'Card Deck',
    color: const Color(0xFFE79B2D),
    builder: (_) => const CardDeckView(),
  ),
  _ExampleData(
    id: 'digital-wallet',
    title: 'Digital Wallet',
    color: const Color(0xFFA02BD7),
    builder: (_) => const DigitalWalletView(),
  ),
  _ExampleData(
    id: 'record-box',
    title: 'Record Box',
    color: const Color(0xFFD72B44),
    builder: (_) => const RecordBoxView(),
  ),
];
