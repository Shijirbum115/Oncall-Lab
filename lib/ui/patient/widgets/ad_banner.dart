import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_colors.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  // Large multiplier for "infinite" scroll effect
  static const int _infiniteMultiplier = 10000;

  final List<_AdContent> _ads = const [
    _AdContent(
      imageUrl:
          'https://images.unsplash.com/photo-1581094794329-c8112a89af12?auto=format&fit=crop&w=1100&q=80',
      title: '24/7 лабораторийн үзлэг',
      subtitle: 'Тоног төхөөрөмжтэй баг тань руу нэг цагийн дотор очно.',
    ),
    _AdContent(
      imageUrl:
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=1100&q=80',
      title: 'Гэрийн шинжилгээний багц',
      subtitle: 'Онлайн захиалгаар 15% хүртэл хямдралтай.',
    ),
    _AdContent(
      imageUrl:
          'https://images.unsplash.com/photo-1505751172876-fa1923c5c528?auto=format&fit=crop&w=1100&q=80',
      title: 'Сувилагчийн урьдчилсан зөвлөгөө',
      subtitle: 'Шаардлагатай шинжилгээг онлайнаар төлөвлөөд авч өгнө.',
    ),
  ];

  int get _realIndex => _currentPage % _ads.length;

  @override
  void initState() {
    super.initState();
    // Start at middle position for infinite scroll in both directions
    final initialPage = (_infiniteMultiplier ~/ 2) * _ads.length;
    _currentPage = initialPage;
    _pageController = PageController(
      viewportFraction: 1.0, // Full viewport - hide next/previous
      initialPage: initialPage,
    );

    _timer = Timer.periodic(const Duration(seconds: 8), (_) {
      if (_pageController.hasClients) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 150,
          child: PageView.builder(
            controller: _pageController,
            // No itemCount = infinite pages
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final actualIndex = index % _ads.length;
              final ad = _ads[actualIndex];

              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double opacity = 1.0;
                  if (_pageController.position.haveDimensions) {
                    final page = _pageController.page ?? _currentPage.toDouble();
                    final distance = (page - index).abs();
                    // Fade out as page slides away, fade in as it comes into view
                    opacity = (1 - distance).clamp(0.0, 1.0);
                  }
                  return Opacity(
                    opacity: opacity,
                    child: child,
                  );
                },
                child: Padding(
                  padding: AppPadding.screenH,
                  child: _AdCard(content: ad),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _ads.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _realIndex == index ? 22 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: _realIndex == index
                    ? AppColors.primary
                    : AppColors.inkSubtle.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AdCard extends StatelessWidget {
  const _AdCard({required this.content});

  final _AdContent content;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            content.imageUrl,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.1),
                  AppColors.primary.withValues(alpha: 0.78),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  content.title,
                  style: AppTypography.h3.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  content.subtitle,
                  style: AppTypography.bodySm.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdContent {
  final String imageUrl;
  final String title;
  final String subtitle;

  const _AdContent({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });
}
