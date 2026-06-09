import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/l10n/app_localizations.dart';

class TestTypesSection extends StatefulWidget {
  const TestTypesSection({
    super.key,
    required this.testTypes,
    this.onSeeAllTap,
  });

  final List<Map<String, dynamic>> testTypes;
  final VoidCallback? onSeeAllTap;

  @override
  State<TestTypesSection> createState() => _TestTypesSectionState();
}

class _TestTypesSectionState extends State<TestTypesSection> {
  static const double _cardWidth = 210;
  static const double _cardSpacing = 12;
  static const Duration _slideInterval = Duration(seconds: 3);

  final ScrollController _scrollController = ScrollController();
  Timer? _autoScrollTimer;
  int _currentIndex = 0;

  // Total width of one card + spacing
  double get _itemExtent => _cardWidth + _cardSpacing;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
  }

  @override
  void didUpdateWidget(covariant TestTypesSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.testTypes.length != widget.testTypes.length) {
      _restartAutoScroll();
    }
  }

  void _restartAutoScroll() {
    _autoScrollTimer?.cancel();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    if (widget.testTypes.length <= 1) return;
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(_slideInterval, (_) async {
      if (!_scrollController.hasClients ||
          !_scrollController.position.hasContentDimensions) {
        return;
      }
      if (!mounted) return;

      _currentIndex++;
      final targetOffset = _currentIndex * _itemExtent;

      await _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.testTypes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: AppPadding.screenH,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.availableTests,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -.5,
                  color: AppColors.black,
                ),
              ),
              if (widget.onSeeAllTap != null)
                TextButton(
                  onPressed: widget.onSeeAllTap,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    l10n.viewAll,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 78,
          width: double.infinity,
          child: ListView.builder(
            controller: _scrollController,
            padding: AppPadding.screenH,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            // No itemCount = infinite scroll
            itemBuilder: (context, index) {
              final actualIndex = index % widget.testTypes.length;
              final test = widget.testTypes[actualIndex];
              final price = test['price_mnt'] as int?;

              return Padding(
                padding: EdgeInsets.only(right: _cardSpacing),
                child: SizedBox(
                  width: _cardWidth,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: AppColors.grey.withValues(alpha: 0.15),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.bloodtype,
                            size: 15,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                l10n.localeName == 'mn' && test['name_mn'] != null
                                    ? test['name_mn']
                                    : test['name'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                price != null
                                    ? l10n.priceInMNT(price)
                                    : '',
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      AppColors.grey.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
