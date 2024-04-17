import 'package:example/views/demo_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Example showing a randomly shuffled card deck the user can flip through.
///
/// Demonstrates:
/// - a complex [CustomCarousel.effectsBuilder] function using [CustomCarousel.effectsBuilderFromAnimate]
/// - using the [CustomCarousel.controller] to navigate items
///
/// Check out the code comments on `_buildCarousel` for information on how
/// everything works.
///
/// Please note: to keep things simple, all demos were built for portrait mode
/// on mobile handsets, without a lot of effort or testing for responsiveness.

class CardDeckView extends StatefulWidget {
  const CardDeckView({super.key});

  @override
  State<CardDeckView> createState() => _CardDeckViewState();
}

class _CardDeckViewState extends State<CardDeckView> {
  List<int> _cardIndexes = List.generate(14, (i) => i);
  int _selectedIndex = 0;
  late CustomCarouselScrollController _controller;

  @override
  void initState() {
    _controller = CustomCarouselScrollController();
    Future.delayed(300.ms, _shuffleDeck); // small delay for nav to settle
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DemoChrome(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/card_deck/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(child: _buildCarousel()),
              Padding(
                padding: const EdgeInsets.only(bottom: 32, top: 16),
                child: _buildNextBtn(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    List<Widget> items =
        List.generate(_cardIndexes.length, (i) => _Card(_cardIndexes[i]));

    // Note: we could wrap the carousel in IgnorePointer to prevent user interaction.
    // but it's kinda fun to play with in the demo, so we'll leave it enabled.

    return CustomCarousel(
      // Enable `sticky` physics so you can only "throw" one card at a time:
      physics: const CustomCarouselScrollPhysics(sticky: true),
      // Creates the stack of 3 cards behind the selected card:
      itemCountBefore: 3,
      // We don't want any cards left on screen after they "scroll off":
      itemCountAfter: 0,
      // Start all the cards in the middle (we'll move them around from there):
      alignment: Alignment.center,
      // The user will use horizontal scroll interactions:
      scrollDirection: Axis.horizontal,
      // Slow down scroll interactions a bit:
      scrollSpeed: 0.5,
      // We don't want to let the user tap to scroll to (ie. select) a card:
      tapToSelect: false,
      // We'll use our own controller so that we can navigate the cards via
      // the "Next Card" / "Shuffle Deck" button:
      controller: _controller,
      // Create the effectsBuilder using Animate, so we can leverage pre-built
      // effects like shimmer, tint, and shadows:
      effectsBuilder: CustomCarousel.effectsBuilderFromAnimate(
        // This is quite a complex effects list, but we'll try to break it
        // down into understandable chunks.
        //
        // The specific duration doesn't really matter, but to make it
        // easier to think about, we'll use 200ms. The "middle" at 100ms
        // is when the card is selected. So 0-100ms is "before"
        // the card is selected, and 100-200ms is "after".
        //
        // Effects are applied in the order they are added to the list, so
        // we'll start with the effects that happen "on the card", versus
        // "to the card".
        effects: EffectList()
            // This tint will run from 0-100, so untint as it approaches the
            // front of the stack (ie. approaches the middle). It's what makes
            // the cards in the background a little darker.
            .untint(
              duration: 100.ms,
              color: Colors.black45,
            )
            // Inherits the 100ms duration, and the delay makes this run from
            // 100-200, so it animates as the card leaves the stack
            // (ie. leaves the middle). It creates the gloss effect across
            // the face of the card as it flips.
            .shimmer(
              delay: 100.ms,
              color: Colors.white70,
              angle: 3.1,
            )
            // This inherits the 100-200 timing from the shimmer. It animates
            // the shadow behind the card as it flips.
            .boxShadow(
              begin: const BoxShadow(
                color: Colors.black38,
                blurRadius: 0,
                spreadRadius: -4,
                offset: Offset(0, 0),
              ),
              end: BoxShadow(
                color: Colors.black.withOpacity(0),
                blurRadius: 24,
                offset: const Offset(-48, 0),
              ),
              borderRadius: BorderRadius.circular(24),
            )
            // the following effects happen "to the card" (ex. moving it around)
            // so we'll add them at the end of the list.
            //
            // This rotation resets the delay to 0, thereby running from 0-100.
            // It subtley rotates the cards in the stack as they move to the front.
            .rotate(
              delay: 0.ms,
              curve: Curves.easeIn,
              begin: 0.02,
            )
            // The 2.5d card flip as it leaves the stack (100-200).
            .flipH(
              delay: 100.ms,
              end: -0.15,
              alignment: Alignment.center,
              perspective: 2,
            )
            // Slides the card to the right as it leaves the stack (100-200).
            .slideX(end: 1.5),
      ),
      // This is mostly just used to update the "Next Card" button to say
      // "Shuffle Deck" when the last card is selected.
      onSelectedItemChanged: (i) => setState(() => _selectedIndex = i),
      children: items,
    );
  }

  Widget _buildNextBtn() {
    return GestureDetector(
      onTap: () {
        if (_selectedIndex == 0) {
          _shuffleDeck();
        } else {
          _controller.previousItem(duration: 1000.ms);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF4CB1BE),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          _selectedIndex == 0 ? 'Shuffle Deck' : 'Next Card',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _shuffleDeck() {
    setState(() {
      _cardIndexes = _cardIndexes.sublist(1);
      _cardIndexes.shuffle();
      _cardIndexes.insert(0, 0);
      _controller.animateToItem(_cardIndexes.length - 1, duration: 800.ms);
    });
  }
}

class _Card extends StatelessWidget {
  const _Card(this.index, {Key? key}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    Widget card = AspectRatio(
      aspectRatio: 2 / 3,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/card_deck/card-$index.jpg'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const HSLColor.fromAHSL(1, 0, 1, 1).toColor(),
            width: 20,
          ),
        ),
      ),
    );

    return card;
  }
}
