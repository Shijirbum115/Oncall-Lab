import 'dart:async';

import 'package:flutter/material.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_section_header.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';

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
        AppSectionHeader(
          title: l10n.availableTests,
          actionLabel: widget.onSeeAllTap != null ? l10n.viewAll : null,
          onActionTap: widget.onSeeAllTap,
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 78,
          width: double.infinity,
          child: ListView.builder(
            controller: _scrollController,
            padding: AppPadding.screenH,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final actualIndex = index % widget.testTypes.length;
              final test = widget.testTypes[actualIndex];
              final price = test['price_mnt'] as int?;

              return Padding(
                padding: const EdgeInsets.only(right: _cardSpacing),
                child: SizedBox(
                  width: _cardWidth,
                  child: AppCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    borderColor: AppColors.border,
                    borderRadius: AppRadius.sm,
                    elevation: AppCardElevation.resting,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
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
                                style: AppTypography.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                price != null ? l10n.priceInMNT(price) : '',
                                style: AppTypography.caption,
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
