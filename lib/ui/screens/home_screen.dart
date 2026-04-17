import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../providers/fitness_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fitness = context.watch<FitnessProvider>();
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
        ? 'Good Afternoon'
        : 'Good Evening';
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        const Text(
                          'Arbin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Semantics label makes this icon-only container readable by screen readers
                  Semantics(
                    label: 'Notifications',
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent,
                      // withValues replaces deprecated withOpacity for precision-safe alpha blending
                  AppColors.accent.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    _StepsProgressRing(progress: fitness.stepProgress),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Steps Today',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '${fitness.steps}',
                            style: TextStyle(
                              color: Colors.white,
                              // MediaQuery: shrinks step count font on narrow screens (<380px)
                              fontSize: screenWidth > 380 ? 30 : 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '/ ${fitness.stepGoal} goal',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.local_fire_department,
                                color: Colors.white70,
                                size: 14,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${fitness.totalCalories} kcal burned',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
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
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatCard(
                    Icons.timer,
                    'Active',
                    '${fitness.todayMinutes}',
                    'min',
                    AppColors.accentPurple,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    Icons.favorite,
                    'Heart Rate',
                    '${fitness.heartRate}',
                    'bpm',
                    Colors.redAccent,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    Icons.local_fire_department,
                    'Streak',
                    '${fitness.streak}',
                    'days',
                    AppColors.accentYellow,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _WaterCard(fitness: fitness),
              const SizedBox(height: 16),
              const Text(
                "Today's Activity",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildTodayActivities(fitness),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      context.read<FitnessProvider>().addSteps(500),
                  icon: const Icon(Icons.directions_walk),
                  label: const Text(
                    'Add 500 Steps',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String label,
    String value,
    String unit,
    Color color,
  ) {
    return Expanded(
      // Semantics gives screen readers a single meaningful description of the whole card
      child: Semantics(
        label: '$label: $value $unit',
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
              // Icon is decorative here; parent Semantics already describes the card
              ExcludeSemantics(child: Icon(icon, color: color, size: 20)),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                unit,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayActivities(FitnessProvider fitness) {
    final now = DateTime.now();
    final today = fitness.activities.where((a) {
      return a.date.year == now.year &&
          a.date.month == now.month &&
          a.date.day == now.day;
    }).toList();

    if (today.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.directions_run, color: AppColors.textMuted, size: 36),
              SizedBox(height: 8),
              Text(
                'No workouts logged today',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              Text(
                'Tap Workouts to log one!',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: today.length,
        itemBuilder: (context, i) {
          final a = today[i];
          final color = _colorForType(a.type);
          // Semantics surfaces activity details to screen readers in one readable announcement
          return Semantics(
            label: '${a.name}: ${a.duration} minutes, ${a.calories} calories',
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withValues(alpha: 0.4)),
              ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_iconForType(a.type), color: color, size: 22),
                const Spacer(),
                Text(
                  a.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${a.duration} min - ${a.calories} kcal',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            ),
          );
        },
      ),
    );
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'Running':
        return AppColors.accent;
      case 'Cycling':
        return AppColors.accentGreen;
      case 'Yoga':
        return AppColors.accentPurple;
      case 'Swimming':
        return AppColors.accentBlue;
      case 'Strength':
        return AppColors.accentYellow;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'Running':
        return Icons.directions_run;
      case 'Cycling':
        return Icons.directions_bike;
      case 'Yoga':
        return Icons.self_improvement;
      case 'Swimming':
        return Icons.pool;
      case 'Strength':
        return Icons.fitness_center;
      default:
        return Icons.sports;
    }
  }
}

class _StepsProgressRing extends StatelessWidget {
  final double progress;

  const _StepsProgressRing({required this.progress});

  @override
  Widget build(BuildContext context) {
    final clamped = progress.clamp(0.0, 1.0);
    final percent = (clamped * 100).round();

    // Semantics announces the numeric progress value so TalkBack/VoiceOver users
    // get "Steps goal progress: 64 percent" instead of a silent visual ring
    return Semantics(
      label: 'Steps goal progress: $percent percent',
      child: SizedBox(
        width: 108,
        height: 108,
        child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: clamped),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        builder: (context, animatedValue, _) {
          return Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 108,
                height: 108,
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 10,
                  color: Colors.white.withValues(alpha: 0.22),
                ),
              ),
              SizedBox(
                width: 108,
                height: 108,
                child: CircularProgressIndicator(
                  value: animatedValue,
                  strokeWidth: 10,
                  strokeCap: StrokeCap.round,
                  color: Colors.white,
                ),
              ),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withValues(alpha: 0.28)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$percent%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'GOAL',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10,
                        letterSpacing: 1,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      ),
    );
  }
}

class _WaterCard extends StatelessWidget {
  final FitnessProvider fitness;
  const _WaterCard({required this.fitness});

  @override
  Widget build(BuildContext context) {
    final cups = (fitness.water / 0.25).round();
    final totalCups = (fitness.waterGoal / 0.25).round();

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
          Row(
            children: [
              const Icon(Icons.water_drop, color: AppColors.accentBlue),
              const SizedBox(width: 8),
              const Text(
                'Water Intake',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Text(
                '${fitness.water.toStringAsFixed(1)}L / ${fitness.waterGoal.toStringAsFixed(1)}L',
                style: const TextStyle(
                  color: AppColors.accentBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: List.generate(totalCups, (i) {
              return Icon(
                i < cups ? Icons.water_drop : Icons.water_drop_outlined,
                color: i < cups ? AppColors.accentBlue : AppColors.border,
                size: 20,
              );
            }),
          ),
          const SizedBox(height: 12),
          // label names the indicator; value gives the current percentage for screen readers
          Semantics(
            label: 'Water intake progress',
            value: '${(fitness.waterProgress * 100).round()} percent',
            child: LinearProgressIndicator(
              value: fitness.waterProgress,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.accentBlue,
              ),
              minHeight: 6,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: fitness.water > 0
                      ? () => context.read<FitnessProvider>().removeWater()
                      : null,
                  icon: const Icon(Icons.remove, size: 16),
                  label: const Text('-250ml'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentBlue,
                    side: const BorderSide(color: AppColors.accentBlue),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.read<FitnessProvider>().addWater(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('+250ml'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accentBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
