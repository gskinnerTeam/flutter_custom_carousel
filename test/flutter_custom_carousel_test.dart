import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';

void main() {
  test('placeholder test', () {
    final CustomCarousel carousel = CustomCarousel(
      effectsBuilder: (_, __, child) => child,
      children: const [],
    );
    expect(carousel.scrollSpeed, 1);
  });
}
