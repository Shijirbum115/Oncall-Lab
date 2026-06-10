import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/core/services/supabase_service.dart';
import 'package:bugamed/ui/patient/laboratory_detail_screen_new.dart';
import 'package:bugamed/core/utils/error_handler.dart';
import 'package:bugamed/l10n/app_localizations.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';

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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        title: Text(
          widget.serviceName ?? l10n.laboratories,
          style: const TextStyle(
            color: AppColors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.scaffoldBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(
                    Iconsax.search_normal,
                    color: AppColors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: l10n.searchLaboratories,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        hintStyle: const TextStyle(
                          fontSize: 15,
                          color: AppColors.grey,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        _onSearchChanged();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.grey.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.grey,
                          size: 14,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Results count
          if (!isLoading && filteredLaboratories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${filteredLaboratories.length} ${l10n.laboratories.toLowerCase()}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),

          // Content
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.warning_2,
                  color: AppColors.error,
                  size: 40,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                l10n.unableToLoadLaboratories,
                style: AppTypography.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                friendlyErrorMessage(l10n, errorMessage),
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    errorMessage = null;
                    isLoading = true;
                  });
                  _loadLaboratories();
                },
                icon: const Icon(Iconsax.refresh),
                label: Text(l10n.retry),
              ),
            ],
          ),
        ),
      );
    }

    if (laboratories.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.grey.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Iconsax.buildings,
                size: 48,
                color: AppColors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noLaboratoriesAvailable,
              style: AppTypography.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (filteredLaboratories.isEmpty && _query.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.grey.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Iconsax.search_status,
                  color: AppColors.grey,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.noLaboratoriesMatchQuery(_query),
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLaboratories,
      color: AppColors.primary,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        itemCount: filteredLaboratories.length,
        itemBuilder: (context, index) {
          final lab = filteredLaboratories[index];
          return _ModernLabCard(
            laboratory: lab,
            l10n: l10n,
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
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
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
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

// Modern compact laboratory card
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

    // Check if currently open (simplified logic - would need actual hours)
    final now = DateTime.now();
    final isOpen = now.hour >= 8 && now.hour < 20;

    // Mock rating for now
    final rating = 4.8;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Lab image/logo
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/express.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Iconsax.buildings,
                            size: 32,
                            color: AppColors.primary.withValues(alpha: 0.5),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Lab info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name row with rating
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Rating
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: AppColors.warning,
                                size: 16,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                rating.toString(),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Address
                      Row(
                        children: [
                          Icon(
                            Iconsax.location,
                            size: 14,
                            color: AppColors.grey.withValues(alpha: 0.8),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              address,
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.grey.withValues(alpha: 0.9),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Status badges
                      Row(
                        children: [
                          // Open/Closed badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: (isOpen && isActive)
                                  ? AppColors.success.withValues(alpha: 0.12)
                                  : AppColors.error.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
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
                                  (isOpen && isActive) ? l10n.available : l10n.closed,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: (isOpen && isActive)
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Operating hours hint
                          Text(
                            '8:00 - 20:00',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.grey.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Arrow
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.grey.withValues(alpha: 0.5),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Skeleton loading card
class _SkeletonLabCard extends StatelessWidget {
  const _SkeletonLabCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Image skeleton
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.grey.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 14),
          // Text skeletons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 14,
                  width: 150,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 20,
                  width: 80,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
