import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// This is used to create the reference GIF in the README.
/// It uses a fixed size & layout to make it easier to capture the video/gif.
/// It's not really intended as an example of how to use the package, but you're
/// welcome to look it over.

class ReadMeExample extends StatefulWidget {
  const ReadMeExample({super.key});

  @override
  State<ReadMeExample> createState() => _ReadMeExampleState();
}

class _ReadMeExampleState extends State<ReadMeExample> {
  // capture at 1080 x 320, margin added to make it easier to capture without edges.
  static const double margin = 2;
  static const double width = 1080 + margin * 2;
  static const double height = 320 + margin * 2;
  static const double pad = 64 + margin;

  int _selectedIndex = 0;
  int? _settledIndex;
  late CustomCarouselScrollController _controller;
  bool _forward = true;

  @override
  void initState() {
    _controller = CustomCarouselScrollController(initialItem: _selectedIndex);
    // comment out this line to disable auto-animation:
    Future.delayed(1.ms, _animate);
    super.initState();
  }

  void _animate() {
    const double t = 2500;
    Future.delayed((t + 1250).ms, _animate);
    _forward
        ? _controller.nextItem(duration: t.ms)
        : _controller.previousItem(duration: t.ms);
    _forward = !_forward;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        const SizedBox(height: margin),
        _buildCarousel(),
        _buildSnapRow(),
      ],
    );

    return Container(
      alignment: Alignment.center,
      color: Colors.red,
      child: Container(
        color: Colors.white,
        width: width,
        height: height,
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.black, fontSize: 24),
          child: content,
        ),
      ),
    );
  }

  Widget _buildSnapRow() {
    const double r = 4;
    Widget getDot(double x, [bool filled = true]) => Positioned(
          left: pad + (width - pad * 2) * (x + 1) / 2 - r,
          top: 0,
          child: Container(
            width: r * 2,
            height: r * 2,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.black),
              color: filled ? Colors.black : Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        );

    Widget getLabel(String str) => Transform.translate(
          offset: const Offset(-pad, 18),
          child: SizedBox(
            width: pad * 2,
            child: Text(str, textAlign: TextAlign.center),
          ),
        );

    Widget getTick(double x) => Positioned(
          left: x - 1,
          top: r,
          child: Container(width: 2, height: 12, color: Colors.black),
        );

    return SizedBox(
      height: 48,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            left: pad,
            right: pad,
            top: r - 1,
            child: Container(height: 2, color: Colors.black),
          ),
          Positioned(left: pad, child: getLabel('-1')),
          Positioned(left: width - pad, child: getLabel('+1')),
          Positioned(left: width / 2, child: getLabel('0')),
          getTick(pad),
          getTick(width - pad),
          getTick(width / 2),
          getDot(-1, false),
          getDot(-0.8),
          getDot(-0.4),
          getDot(-0.2, false),
          getDot(0),
          getDot(0.2, false),
          getDot(0.4),
          getDot(0.8),
          getDot(1, false),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    const double x = (width - pad * 2) / 2;
    Widget content = CustomCarousel(
      itemCountBefore: 2,
      itemCountAfter: 2,
      scrollDirection: Axis.horizontal,
      loop: true,
      controller: _controller,
      alignment: Alignment.center,
      effectsBuilder: (_, ratio, child) {
        Widget card = Stack(
          alignment: Alignment.bottomCenter,
          children: [
            child,
            Positioned(
              bottom: 16,
              child: Text(ratio.toStringAsFixed(2)),
            ),
            Transform.translate(
              offset: const Offset(0, 20),
              child: const Icon(
                Icons.arrow_downward,
                size: 20,
                color: Colors.black,
              ),
            )
          ],
        );
        return Transform.translate(
          offset: Offset(x * ratio, 0),
          child: card,
        );
      },
      onSelectedItemChanged: (value) => setState(() {
        _selectedIndex = value;
      }),
      onSettledItemChanged: (value) => setState(() {
        _settledIndex = value;
      }),
      children: List.generate(
        5,
        (i) => _ContentCard(i, i == _selectedIndex, i == _settledIndex),
      ),
    );

    return SizedBox(
      width: width - pad * 2,
      height: 260,
      child: content,
    );
  }
}

class _ContentCard extends StatelessWidget {
  const _ContentCard(this.index, this.selected, this.settled, {Key? key})
      : super(key: key);

  final int index;
  final bool selected;
  final bool settled;

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      width: 160,
      height: 220,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.black12,
        border: Border.all(
          width: settled ? 8 : 3,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
    );
    return card;
  }
}
