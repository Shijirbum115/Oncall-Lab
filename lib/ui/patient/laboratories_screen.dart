import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:bugamed/core/constants/app_colors.dart';
import 'package:bugamed/core/services/supabase_service.dart';
import 'package:bugamed/ui/patient/laboratory_detail_screen_new.dart';
import 'package:bugamed/l10n/app_localizations.dart';

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
    // Only show back button when pushed with parameters (not when used as tab)
    final showBackButton = widget.preSelectedServiceId != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: showBackButton,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: AppColors.grey,
                ),
                onPressed: () {
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                },
              )
            : null,
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
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.grey.withValues(alpha: 0.2),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: AppColors.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: l10n.searchLaboratories,
                        border: InputBorder.none,
                        hintStyle: const TextStyle(
                          fontSize: 16,
                          color: AppColors.grey,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 16,
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
                      child: const Icon(
                        Icons.cancel,
                        color: AppColors.grey,
                        size: 20,
                      ),
                    ),
                ],
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
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(
                l10n.unableToLoadLaboratories,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.grey),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    errorMessage = null;
                    isLoading = true;
                  });
                  _loadLaboratories();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(l10n.retry),
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
            const Icon(Iconsax.buildings,
                size: 60, color: AppColors.grey),
            const SizedBox(height: 12),
            Text(
              l10n.noLaboratoriesAvailable,
              style: const TextStyle(
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    if (filteredLaboratories.isEmpty && _query.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.search_off,
                  color: AppColors.grey, size: 48),
              const SizedBox(height: 12),
              Text(
                l10n.noLaboratoriesMatchQuery(_query),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 14,
                ),
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
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
        itemCount: filteredLaboratories.length,
        itemBuilder: (context, index) {
          final lab = filteredLaboratories[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _LaboratoryCard(
              laboratory: lab,
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
            ),
          );
        },
      ),
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

class _LaboratoryCard extends StatefulWidget {
  const _LaboratoryCard({
    required this.laboratory,
    required this.onTap,
  });

  final Map<String, dynamic> laboratory;
  final VoidCallback onTap;

  @override
  State<_LaboratoryCard> createState() => _LaboratoryCardState();
}

class _LaboratoryCardState extends State<_LaboratoryCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final name = widget.laboratory['name'] as String? ?? l10n.laboratoryFallback;
    final address =
        widget.laboratory['address'] as String? ?? l10n.addressNotProvided;

    // Mock data for demonstration
    final rating = 4.8;
    final reviewCount = 127;
    final distance = "2.5 km";
    final operatingHours = "Open until 8:00 PM";

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Header
            Stack(
              children: [
                // Cover Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/images/express.png',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: AppColors.background,
                        child: const Center(
                          child: Icon(
                            Iconsax.buildings,
                            size: 48,
                            color: AppColors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                // Rating Badge
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.warning,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '($reviewCount)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Card Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Subtitle
                  Text(
                    l10n.laboratory,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Divider
                  Container(
                    height: 1,
                    color: AppColors.grey.withValues(alpha: 0.2),
                  ),
                  const SizedBox(height: 12),
                  // Address Row
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        distance,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Time Row
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        operatingHours,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
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
