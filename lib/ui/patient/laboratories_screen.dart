import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/services/supabase_service.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/design_system/widgets/app_card.dart';
import 'package:bugamed/ui/design_system/widgets/app_screen_header.dart';
import 'package:bugamed/ui/design_system/widgets/app_text_field.dart';
import 'package:bugamed/ui/patient/laboratory_detail_screen_new.dart';
import 'package:bugamed/ui/shared/widgets/mascot_state_widget.dart';

class LaboratoriesScreen extends StatefulWidget {
  final String? preSelectedServiceId;
  final String? serviceName;

  const LaboratoriesScreen({
    super.key,
    this.preSelectedServiceId,
    this.serviceName,
  });

  @override
  State<LaboratoriesScreen> createState() => _LaboratoriesScreenState();
}

class _LaboratoriesScreenState extends State<LaboratoriesScreen> {
  List<Map<String, dynamic>> laboratories = [];
  List<Map<String, dynamic>> filteredLaboratories = [];
  bool isLoading = true;
  String? errorMessage;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadLaboratories();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLaboratories() async {
    if (!mounted) return;

    try {
      if (widget.preSelectedServiceId != null) {
        final data = await supabase
            .from('laboratory_services')
            .select('laboratories(*)')
            .eq('service_id', widget.preSelectedServiceId!)
            .eq('is_available', true);

        final labs = data
            .map((item) => item['laboratories'] as Map<String, dynamic>)
            .toList();

        if (mounted) {
          setState(() {
            laboratories = labs;
            filteredLaboratories = labs;
            isLoading = false;
          });
        }
      } else {
        final data =
            await supabase.from('laboratories').select().order('name');

        final labs = List<Map<String, dynamic>>.from(data);
        if (mounted) {
          setState(() {
            laboratories = labs;
            filteredLaboratories = labs;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final showBackButton = widget.preSelectedServiceId != null;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        automaticallyImplyLeading: showBackButton,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: AppColors.ink,
                ),
                onPressed: () {
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
              )
            : null,
        titleSpacing: 0,
        title: AppScreenHeader(
          title: widget.serviceName ?? l10n.laboratories,
          padding: const EdgeInsets.symmetric(horizontal: 4),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppPadding.screen, 8, AppPadding.screen, AppSpacing.md),
            child: AppSearchField(
              controller: _searchController,
              hint: l10n.searchLaboratories,
              prefixIcon: Iconsax.search_normal,
              onChanged: (_) => _onSearchChanged(),
              onClear: () {
                _searchController.clear();
                _onSearchChanged();
              },
            ),
          ),
          if (!isLoading && filteredLaboratories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppPadding.screen, 0, AppPadding.screen, AppSpacing.sm),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${filteredLaboratories.length} ${l10n.laboratories.toLowerCase()}',
                  style: AppTypography.bodySm,
                ),
              ),
            ),
          Expanded(
            child: _buildContent(l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    if (isLoading) {
      return _buildSkeletonLoader();
    }

    if (errorMessage != null) {
      return Center(
        child: SingleChildScrollView(
          child: MascotStateWidget(
            emotion: MascotEmotion.error,
            title: l10n.unableToLoadLaboratories,
            subtitle: errorMessage!,
            actionText: l10n.retry,
            onAction: () {
              setState(() {
                errorMessage = null;
                isLoading = true;
              });
              _loadLaboratories();
            },
          ),
        ),
      );
    }

    if (laboratories.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: MascotStateWidget(
            emotion: MascotEmotion.empty,
            title: l10n.noLaboratoriesAvailable,
          ),
        ),
      );
    }

    if (filteredLaboratories.isEmpty && _query.isNotEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: MascotStateWidget(
            emotion: MascotEmotion.empty,
            title: l10n.noLaboratoriesMatchQuery(_query),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLaboratories,
      color: AppColors.primary,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
            AppPadding.screen, 0, AppPadding.screen, AppSpacing.lg),
        itemCount: filteredLaboratories.length,
        itemBuilder: (context, index) {
          final lab = filteredLaboratories[index];
          return _ModernLabCard(
            laboratory: lab,
            l10n: l10n,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LaboratoryDetailScreenNew(
                    laboratory: lab,
                    preSelectedServiceId: widget.preSelectedServiceId,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(
          AppPadding.screen, 0, AppPadding.screen, AppSpacing.lg),
      itemCount: 5,
      itemBuilder: (context, index) => const _SkeletonLabCard(),
    );
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      _query = query;
      if (query.isEmpty) {
        filteredLaboratories = List<Map<String, dynamic>>.from(laboratories);
      } else {
        filteredLaboratories = laboratories.where((lab) {
          final name = (lab['name'] ?? '').toString().toLowerCase();
          final address = (lab['address'] ?? '').toString().toLowerCase();
          return name.contains(query) || address.contains(query);
        }).toList();
      }
    });
  }
}

class _ModernLabCard extends StatelessWidget {
  final Map<String, dynamic> laboratory;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _ModernLabCard({
    required this.laboratory,
    required this.l10n,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final name = laboratory['name'] as String? ?? l10n.laboratoryFallback;
    final address = laboratory['address'] as String? ?? l10n.addressNotProvided;
    final isActive = laboratory['is_active'] as bool? ?? true;

    final now = DateTime.now();
    final isOpen = now.hour >= 8 && now.hour < 20;

    final rating = 4.8;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: onTap,
        elevation: AppCardElevation.resting,
        borderColor: AppColors.border,
        borderRadius: AppRadius.md,
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: Image.asset(
                  'assets/images/express.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Iconsax.buildings,
                        size: 32,
                        color: AppColors.primary,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: AppTypography.body
                              .copyWith(fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.warning, size: 16),
                          const SizedBox(width: 2),
                          Text(
                            rating.toString(),
                            style: AppTypography.bodySm.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Iconsax.location,
                          size: 14, color: AppColors.inkSubtle),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          address,
                          style: AppTypography.bodySm,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: (isOpen && isActive)
                              ? AppColors.success.withValues(alpha: 0.12)
                              : AppColors.error.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.xs),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: (isOpen && isActive)
                                    ? AppColors.success
                                    : AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              (isOpen && isActive)
                                  ? l10n.available
                                  : l10n.closed,
                              style: AppTypography.label.copyWith(
                                color: (isOpen && isActive)
                                    ? AppColors.success
                                    : AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('8:00 - 20:00', style: AppTypography.caption),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.inkSubtle, size: 24),
          ],
        ),
      ),
    );
  }
}

class _SkeletonLabCard extends StatelessWidget {
  const _SkeletonLabCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        elevation: AppCardElevation.none,
        borderRadius: AppRadius.md,
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(AppRadius.xs / 2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 14,
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(AppRadius.xs / 2),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 20,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(AppRadius.xs),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
