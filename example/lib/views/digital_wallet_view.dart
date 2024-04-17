import 'package:example/views/demo_chrome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_carousel/flutter_custom_carousel.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Example showing a swipable carousel of digital wallet accounts.
///
/// Demonstrates:
/// - using [CustomCarousel.onSelectedItemChanged] and [CustomCarousel.onSettledItemChanged]
/// - using [CustomCarousel.reverse] to reverse the interaction direction
///
/// Please note: to keep things simple, all demos were built for portrait mode
/// on mobile handsets, without a lot of effort or testing for responsiveness.

class DigitalWalletView extends StatefulWidget {
  const DigitalWalletView({super.key});

  @override
  State<DigitalWalletView> createState() => _DigitalWalletViewState();
}

class _DigitalWalletViewState extends State<DigitalWalletView> {
  int _selectedIndex = 0;
  int? _activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    HSLColor color = HSLColor.fromColor(_accounts[_selectedIndex].color);

    return DemoChrome(
      backgroundColor: _accounts[_selectedIndex].color,
      body: AnimatedContainer(
        duration: 300.ms,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withLightness(color.lightness * 0.1).toColor(),
              color.withLightness(color.lightness * 0.3).toColor(),
              color.toColor(),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCarousel(),
            const SizedBox(height: 16),
            if (_activeIndex != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  key: ValueKey(_selectedIndex),
                  children: List.generate(
                    _selectedIndex % 3 + 3,
                    (i) => _buildTransactionRow(i),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    List<Widget> items = _accounts.map((account) => _Card(account)).toList();

    // See `card_deck_view.dart` for a fully commented example of using
    // Animate with CustomCarousel.
    //
    // This example is unusual in that it sets `reverse: true`, because it was
    // easier to think about the animation effects that way. This simply
    // reverses the direction of user scroll interactions.
    Widget carousel = CustomCarousel(
      itemCountBefore: 0,
      itemCountAfter: 3,
      scrollDirection: Axis.horizontal,
      loop: true,
      reverse: true,
      depthOrder: DepthOrder.reverse,
      scrollSpeed: 0.5,
      alignment: Alignment.bottomCenter,
      effectsBuilder: CustomCarousel.effectsBuilderFromAnimate(
        effects: EffectList()
            .fadeOut(delay: 100.ms, duration: 100.ms, curve: Curves.easeIn)
            .blurXY(end: 8, curve: Curves.linear)
            .slide(end: const Offset(-0.7, -0.45))
            .slideX(delay: 0.ms, begin: 1.0),
      ),
      // This uses a combination of selected and settled item so that the
      // transaction list only appears after the user has settled on a card, but
      // the list doesn't get removed until they scroll fully off the card.
      onSelectedItemChanged: (i) => setState(() {
        _selectedIndex = i;
        _activeIndex = null;
      }),
      onSettledItemChanged: (i) {
        if (i != null) setState(() => _activeIndex = i);
      },
      children: items,
    );

    return AspectRatio(aspectRatio: 1, child: carousel);
  }

  Widget _buildTransactionRow(int i) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(children: [
        _box(width: 40, height: 40),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _box(height: 20, opacity: 0.25),
              const SizedBox(height: 8),
              _box(height: 12, width: 120, opacity: 0.15),
            ],
          ),
        ),
      ]),
    )
        .animate()
        .fadeIn(delay: (i * 150).ms)
        .slideY(begin: -0.1, curve: Curves.easeOut);
  }

  Widget _box({double? width, double? height, opacity = 0.3}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card(this.account, {Key? key}) : super(key: key);

  final _AccountData account;

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Image.asset(
            'assets/images/digital_wallet/${account.logo}',
            width: 32,
          ),
          const SizedBox(width: 12),
          Text(
            account.name,
            style: const TextStyle(fontWeight: FontWeight.w300),
          ),
        ]),
        const Spacer(flex: 3),
        Text(
          account.type,
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
        ),
        Text(account.balance, style: const TextStyle(fontSize: 22)),
        const Spacer(flex: 2),
        Text(account.cardNumber, style: const TextStyle(fontSize: 14)),
      ],
    );

    return AspectRatio(
      aspectRatio: 3 / 2,
      child: DefaultTextStyle(
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/digital_wallet/${account.art}'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12),
            border: const Border(
              top: BorderSide(color: Colors.white24, width: 2),
            ),
          ),
          child: content,
        ),
      ),
    );
  }
}

class _AccountData {
  const _AccountData({
    required this.art,
    required this.logo,
    required this.name,
    required this.type,
    required this.balance,
    required this.cardNumber,
    required this.color,
  });

  final String art;
  final String logo;
  final String name;
  final String type;
  final String balance;
  final String cardNumber;
  final Color color;
}

const List<_AccountData> _accounts = [
  _AccountData(
    art: 'wallet-1.jpg',
    logo: 'logo-1.png',
    name: 'ProviderBank',
    type: 'Savings Account',
    balance: '\$11,234.56',
    cardNumber: '**** **** **** 2345',
    color: Color(0xFF3A8F07),
  ),
  _AccountData(
    art: 'wallet-2.jpg',
    logo: 'logo-2.png',
    name: 'WidgetOne',
    type: 'Cashback Credit Card',
    balance: '\$4,567.89',
    cardNumber: '****** ***** 12345',
    color: Color(0xFF6B1B9C),
  ),
  _AccountData(
    art: 'wallet-3.jpg',
    logo: 'logo-2.png',
    name: 'Dart Financial',
    type: 'Credit Card',
    balance: '\$2,345.67',
    cardNumber: '**** **** **** 7890',
    color: Color(0xFF1A949C),
  ),
  _AccountData(
    art: 'wallet-4.jpg',
    logo: 'logo-3.png',
    name: 'Dash+',
    type: 'Travel Rewards',
    balance: '10,678 pts',
    cardNumber: 'Member #54321',
    color: Color(0xFF073C96),
  ),
  _AccountData(
    art: 'wallet-5.jpg',
    logo: 'logo-2.png',
    name: 'Carousel',
    type: 'Member Card',
    balance: '\$987.00',
    cardNumber: 'Member ID: C-12345',
    color: Color(0xFFBC5A22),
  ),
];
