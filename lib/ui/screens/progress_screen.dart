import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../providers/fitness_provider.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fitness = context.watch<FitnessProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Progress'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accent,
          labelColor: AppColors.accent,
          unselectedLabelColor: AppColors.textMuted,
          tabs: const [
            Tab(text: 'This Week'),
            Tab(text: 'Achievements'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _WeeklyTab(fitness: fitness),
          const _AchievementsTab(),
        ],
      ),
    );
  }
}

class _WeeklyTab extends StatelessWidget {
  final FitnessProvider fitness;
  const _WeeklyTab({required this.fitness});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary stat cards
          Row(
            children: [
              _SummaryCard(
                label: 'Workouts',
                value: '${fitness.activities.length}',
                unit: 'sessions',
                color: AppColors.accent,
                icon: Icons.fitness_center,
              ),
              const SizedBox(width: 12),
              _SummaryCard(
                label: 'Streak',
                value: '${fitness.streak}',
                unit: 'days',
                color: AppColors.accentYellow,
                icon: Icons.local_fire_department,
              ),
              const SizedBox(width: 12),
              _SummaryCard(
                label: 'Calories',
                value: '${fitness.allTimeCalories}',
                unit: 'kcal',
                color: AppColors.accentGreen,
                icon: Icons.bolt,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Steps bar chart
          _BarChart(
            title: 'Daily Steps',
            subtitle: 'Goal: 10,000 steps/day',
            data: fitness.weeklySteps,
            maxValue: 12000,
            barColor: AppColors.accent,
            goalLine: 10000,
          ),
          const SizedBox(height: 24),

          // Calories bar chart
          _BarChart(
            title: 'Calories Burned',
            subtitle: 'Goal: 600 kcal/day',
            data: fitness.weeklyCalories,
            maxValue: 800,
            barColor: AppColors.accentGreen,
            goalLine: 600,
          ),
          const SizedBox(height: 24),

          // Best day card
          _bestDayCard(fitness.weeklySteps),
        ],
      ),
    );
  }

  Widget _bestDayCard(List<int> steps) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    int maxIdx = 0;
    for (int i = 1; i < steps.length; i++) {
      if (steps[i] > steps[maxIdx]) maxIdx = i;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.emoji_events, color: AppColors.accentYellow, size: 36),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Most Active Day', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              Text(
                days[maxIdx],
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '${steps[maxIdx]} steps',
                style: const TextStyle(color: AppColors.accent, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;
  final IconData icon;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(unit, style: const TextStyle(color: AppColors.textSecondary, fontSize: 10)),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<int> data;
  final int maxValue;
  final Color barColor;
  final int goalLine;

  const _BarChart({
    required this.title,
    required this.subtitle,
    required this.data,
    required this.maxValue,
    required this.barColor,
    required this.goalLine,
  });

  @override
  Widget build(BuildContext context) {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final today = DateTime.now().weekday - 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(data.length, (i) {
              final ratio = data[i] / maxValue;
              final isToday = i == today;
              final metGoal = data[i] >= goalLine;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i < 6 ? 6 : 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: (ratio * 90).clamp(4.0, 90.0),
                        decoration: BoxDecoration(
                          color: data[i] == 0
                              ? AppColors.border
                              : metGoal
                                  ? barColor
                                  : barColor.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(4),
                          border: isToday ? Border.all(color: barColor, width: 2) : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        days[i],
                        style: TextStyle(
                          fontSize: 11,
                          color: isToday ? barColor : AppColors.textSecondary,
                          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _AchievementsTab extends StatelessWidget {
  const _AchievementsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Badges', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: const [
              _Badge(icon: Icons.directions_run, label: 'First Run', color: AppColors.accent, earned: true),
              _Badge(icon: Icons.local_fire_department, label: '7-Day Streak', color: AppColors.accentYellow, earned: true),
              _Badge(icon: Icons.fitness_center, label: '10 Workouts', color: AppColors.accentPurple, earned: true),
              _Badge(icon: Icons.water_drop, label: 'Hydrated', color: AppColors.accentBlue, earned: true),
              _Badge(icon: Icons.directions_bike, label: '50km Ride', color: AppColors.accentGreen, earned: false),
              _Badge(icon: Icons.emoji_events, label: 'Top 10%', color: AppColors.accentYellow, earned: false),
            ],
          ),
          const SizedBox(height: 24),
          const Text('Personal Records', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _recordRow(Icons.directions_run, 'Longest Run', '7.4 km', AppColors.accent),
          _recordRow(Icons.timer, 'Best 5K Time', '24:32', AppColors.accentGreen),
          _recordRow(Icons.local_fire_department, 'Max Calories/Day', '720 kcal', AppColors.accentYellow),
          _recordRow(Icons.directions_walk, 'Max Steps/Day', '11,200', AppColors.accentBlue),
        ],
      ),
    );
  }

  Widget _recordRow(IconData icon, String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14))),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool earned;

  const _Badge({required this.icon, required this.label, required this.color, required this.earned});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: earned ? color.withOpacity(0.12) : AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: earned ? color.withOpacity(0.4) : AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            earned ? icon : Icons.lock_outline,
            color: earned ? color : AppColors.textMuted,
            size: 28,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: earned ? Colors.white : AppColors.textMuted,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

