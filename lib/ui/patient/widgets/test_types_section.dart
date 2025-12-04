import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oncall_lab/core/constants/app_colors.dart';
import 'package:oncall_lab/l10n/app_localizations.dart';

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
      final maxScroll = _scrollController.position.maxScrollExtent;
      final double currentOffset = _scrollController.offset;
      final double targetOffset =
          currentOffset + _cardWidth + _cardSpacing <= maxScroll
              ? currentOffset + _cardWidth + _cardSpacing
              : 0;
      if (!mounted) return;
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
          padding: const EdgeInsets.symmetric(horizontal: 15),
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
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final test = widget.testTypes[index];
              final price = test['price_mnt'] as int?;
              return SizedBox(
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
                              test['name'],
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
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: _cardSpacing),
            itemCount: widget.testTypes.length,
          ),
        ),
      ],
    );
  }
}
