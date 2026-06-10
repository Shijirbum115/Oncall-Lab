import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bugamed/core/constants/app_colors.dart';

/// Medical category icon rendered from the Healthicons set
/// (assets/icons/categories/, CC0) with a per-category gradient tint.
///
/// Resolves the icon from the English category name first (most reliable),
/// then falls back to the raw `icon_name` value stored in Supabase.
class CategoryIcon extends StatelessWidget {
  final String? categoryName;
  final String? iconName;
  final double size;

  const CategoryIcon({
    super.key,
    this.categoryName,
    this.iconName,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    final spec = _resolve(categoryName, iconName);
    final base = spec.color;
    final light = Color.lerp(base, Colors.white, 0.25)!;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            base.withValues(alpha: 0.14),
            base.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: Center(
        child: ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [light, base],
          ).createShader(bounds),
          child: SvgPicture.asset(
            'assets/icons/categories/${spec.asset}.svg',
            width: size * 0.62,
            height: size * 0.62,
          ),
        ),
      ),
    );
  }

  static _IconSpec _resolve(String? categoryName, String? iconName) {
    final name = categoryName?.toLowerCase() ?? '';

    if (name.contains('bacterio')) return _icons['bacteria']!;
    if (name.contains('coagul')) return _icons['blood_cells']!;
    if (name.contains('cardio') || name.contains('heart')) {
      return _icons['heart_organ']!;
    }
    if (name.contains('diabet') || name.contains('glucose')) {
      return _icons['glucometer']!;
    }
    if (name.contains('imaging') ||
        name.contains('x-ray') ||
        name.contains('ultrasound')) {
      return _icons['xray']!;
    }
    if (name.contains('immun')) return _icons['virus_shield']!;
    if (name.contains('joint') || name.contains('rheum')) {
      return _icons['joints']!;
    }
    if (name.contains('kidney') || name.contains('renal')) {
      return _icons['kidneys']!;
    }
    if (name.contains('liver') ||
        name.contains('gallbladder') ||
        name.contains('hepat')) {
      return _icons['liver']!;
    }
    if (name.contains('mineral') || name.contains('metabol')) {
      return _icons['biochemistry']!;
    }
    if (name.contains('pancrea')) return _icons['pancreas']!;
    if (name.contains('thyroid')) return _icons['thyroid']!;
    if (name.contains('std') ||
        name.contains('sti ') ||
        name.contains('sexually')) {
      return _icons['sti']!;
    }
    if (name.contains('sex') || name.contains('hormone')) {
      return _icons['reproductive_health']!;
    }
    if (name.contains('tumor') ||
        name.contains('cancer') ||
        name.contains('marker')) {
      return _icons['ribbon']!;
    }
    if (name.contains('blood')) return _icons['blood_drop']!;

    // Legacy icon_name values stored in Supabase service_categories.
    return switch (iconName) {
      'bloodtype' || 'blood' => _icons['blood_drop']!,
      'favorite' || 'heart' => _icons['heart_organ']!,
      'coronavirus' => _icons['bacteria']!,
      'monitor_heart' => _icons['glucometer']!,
      'accessibility_new' => _icons['joints']!,
      'biotech' => _icons['ribbon']!,
      'psychology' => _icons['reproductive_health']!,
      _ => _icons['lab_default']!,
    };
  }

  /// Semantic color per medical concept, harmonized with
  /// [AppColors.serviceCategoryColors].
  static final Map<String, _IconSpec> _icons = {
    'bacteria': const _IconSpec('bacteria', Color(0xFF14B8A6)),
    'blood_drop': const _IconSpec('blood_drop', AppColors.primary),
    'blood_cells': const _IconSpec('blood_cells', Color(0xFFB91C1C)),
    'heart_organ': const _IconSpec('heart_organ', Color(0xFFEF4444)),
    'glucometer': const _IconSpec('glucometer', Color(0xFF3B82F6)),
    'xray': const _IconSpec('xray', Color(0xFF0EA5E9)),
    'virus_shield': const _IconSpec('virus_shield', Color(0xFF22C55E)),
    'joints': const _IconSpec('joints', Color(0xFF6366F1)),
    'kidneys': const _IconSpec('kidneys', Color(0xFFF59E0B)),
    'liver': const _IconSpec('liver', Color(0xFFF97316)),
    'biochemistry': const _IconSpec('biochemistry', Color(0xFF8B5CF6)),
    'pancreas': const _IconSpec('pancreas', Color(0xFF06B6D4)),
    'reproductive_health':
        const _IconSpec('reproductive_health', Color(0xFFEC4899)),
    'sti': const _IconSpec('sti', Color(0xFFA855F7)),
    'thyroid': const _IconSpec('thyroid', Color(0xFF0D9488)),
    'ribbon': const _IconSpec('ribbon', Color(0xFFDB2777)),
    'lab_default': const _IconSpec('lab_default', AppColors.primary),
  };
}

class _IconSpec {
  final String asset;
  final Color color;

  const _IconSpec(this.asset, this.color);
}
