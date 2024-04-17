import 'package:example/views/demo_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Example showing a familiar horizontal carousel of items; similar to
/// streaming video UIs. This demo has been kept VERY simple as an introduction,
/// and doesn't worry about niceties like responsiveness.
///
/// Demonstrates:
/// - a very simple [CustomCarousel.effectsBuilder] that does not use [Animate]
/// - tap interactions to open a new view
/// - using [Hero] in a carousel
/// - applying [CustomCarousel.alignment]
///
/// Check out the code comments on `_buildCarousel` for information on how
/// everything works.
///
/// Please note: to keep things simple, all demos were built for portrait mode
/// on mobile handsets, without a lot of effort or testing for responsiveness.

class CoverSliderView extends StatelessWidget {
  const CoverSliderView({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoChrome(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('Our Menu', title: true),
                _buildLabel('Starters'),
                _buildCarouselRow('a', 6),
                _buildLabel('Popular Entrées'),
                _buildCarouselRow('b', 10),
                _buildLabel('Something Sweet'),
                _buildCarouselRow('c', 6, height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselRow(String category, int count, {double? height = 100}) {
    // Build a list of widgets for the carousel items:
    List<Widget> items = List.generate(count, (i) => _Card(category, i + 1));

    Widget carousel = CustomCarousel(
      // The carousel will have 5 items total: The 1 selected item, 2 before it,
      // and 2 after it:
      itemCountBefore: 2,
      itemCountAfter: 2,
      // Our items will start aligned to the center left and be moved from there.
      // That also means our "selected" item will rest on the left side of the list:
      alignment: Alignment.centerLeft,
      // The user will interact with horizontal scroll interactions (ex. swipe left/right):
      scrollDirection: Axis.horizontal,
      // Loop the items in the list infinitely:
      loop: true,
      // We don't want to let the user tap to scroll to (ie. select) a card:
      tapToSelect: false,
      // The effectsBuilder takes a ratio from -1 to 1 that indicates this child's
      // current position in the scroll, where 0 is the selected item,
      // and uses it to wrap the child in other widgets that apply "effects":
      effectsBuilder: (_, ratio, child) {
        // This is a very simple effects builder that just moves the child
        // horizontally based on the ratio. `170` is the distance between cards,
        // and `2.5` is the number of card widths we want to move in total on
        // either side (5 cards total divided by 2).
        return Transform.translate(
          offset: Offset(ratio * 170 * 2.5, 0),
          child: child,
        );
      },
      // Pass in the list of widgets we created above:
      children: items,
    );

    return SizedBox(height: height, child: carousel);
  }

  Widget _buildLabel(String label, {bool title = false}) {
    return Padding(
      padding: EdgeInsets.only(top: title ? 56 : 24, bottom: title ? 0 : 8),
      child: Text(
        label,
        style: TextStyle(
          fontSize: title ? 40 : 18,
          fontWeight: FontWeight.bold,
          color: title ? Colors.deepOrange : Colors.grey[800],
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card(this.category, this.index, {Key? key}) : super(key: key);

  final String category;
  final int index;

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: 160,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/cover_slider/food-$category-$index.jpg',
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    return GestureDetector(
      onTap: () => _showDetails(context, category, index),
      child: Hero(tag: 'food-$category-$index', child: content),
    );
  }

  void _showDetails(BuildContext context, String category, int index) {
    PageRouteBuilder route = PageRouteBuilder(
      pageBuilder: (_, __, ___) => _DetailView(category, index),
      transitionDuration: 300.ms,
      transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
    );
    Navigator.push(context, route);
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView(this.category, this.index, {Key? key}) : super(key: key);

  final String category;
  final int index;

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/cover_slider/food-$category-$index.jpg',
          ),
          fit: BoxFit.cover,
        ),
      ),
    );

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio: 1,
          child: Hero(
            tag: 'food-$category-$index',
            child: content,
          ),
        ),
      ),
    );
  }
}
