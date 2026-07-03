import 'package:flutter/material.dart';
import 'package:bugamed/ui/design_system/app_theme.dart';
import 'package:bugamed/ui/patient/models/schedule_ui.dart';
import 'package:bugamed/ui/patient/sample_data/sample_schedules.dart';
import 'package:bugamed/ui/patient/widgets/schedule_item.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 3, vsync: this);

  List<ScheduleUI> get _upcoming => sampleSchedules;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.ink,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.inkSubtle.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.xs),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                labelColor: AppColors.surface,
                unselectedLabelColor:
                    AppColors.ink.withValues(alpha: 0.5),
                tabs: const [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Completed'),
                  Tab(text: 'Canceled'),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ScheduleList(items: _upcoming),
                const _PlaceholderTab(label: 'Completed visits'),
                const _PlaceholderTab(label: 'Canceled visits'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleList extends StatelessWidget {
  const _ScheduleList({required this.items});

  final List<ScheduleUI> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'No visits scheduled',
          style: AppTypography.body.copyWith(color: AppColors.inkSubtle),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemBuilder: (context, index) => ScheduleItem(
        schedule: items[index],
      ),
      separatorBuilder: (_, index) => const SizedBox(height: AppSpacing.sm),
      itemCount: items.length,
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  const _PlaceholderTab({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: AppTypography.h3.copyWith(
          color: AppColors.primary,
        ),
      ),
    );
  }
}
