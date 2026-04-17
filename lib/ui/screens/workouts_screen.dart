import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../providers/fitness_provider.dart';
import '../../domain/activity.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  String _filter = 'All';
  final List<String> _filters = ['All', 'Running', 'Cycling', 'Yoga', 'Swimming', 'Strength'];

  List<Activity> _filtered(List<Activity> activities) {
    if (_filter == 'All') return activities;
    return activities.where((a) => a.type == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final fitness = context.watch<FitnessProvider>();
    final displayed = _filtered(fitness.activities);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Workouts'),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 20),
            ),
            onPressed: () => Navigator.pushNamed(context, '/log'),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: SizedBox(
            height: 52,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              itemCount: _filters.length,
              itemBuilder: (context, i) {
                final f = _filters[i];
                final isSelected = f == _filter;
                return GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accent : AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.accent : AppColors.border,
                      ),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: displayed.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.fitness_center, color: AppColors.textMuted, size: 56),
                  const SizedBox(height: 16),
                  Text(
                    _filter == 'All' ? 'No workouts logged yet' : 'No $_filter workouts found',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap + to log your first workout',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: displayed.length,
              itemBuilder: (context, index) {
                return _ActivityCard(
                  activity: displayed[index],
                  onDelete: () {
                    final realIndex = fitness.activities.indexOf(displayed[index]);
                    if (realIndex != -1) {
                      context.read<FitnessProvider>().removeActivity(realIndex);
                    }
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/log'),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Log Workout', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback onDelete;

  const _ActivityCard({required this.activity, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final color = _colorForType(activity.type);

    return Dismissible(
      key: ObjectKey(activity),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade900,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_iconForType(activity.type), color: color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.name,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _Tag(label: activity.type, color: color),
                      const SizedBox(width: 6),
                      _Tag(label: activity.intensity, color: _intensityColor(activity.intensity)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.timer, size: 12, color: AppColors.textSecondary),
                      const SizedBox(width: 3),
                      Text(
                        '${activity.duration} min',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                      if (activity.distance != null) ...[
                        const SizedBox(width: 10),
                        const Icon(Icons.straighten, size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 3),
                        Text(
                          '${activity.distance!.toStringAsFixed(1)} km',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${activity.calories}',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Text('kcal', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                const SizedBox(height: 4),
                Text(_timeLabel(activity.date), style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _timeLabel(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'Running': return AppColors.accent;
      case 'Cycling': return AppColors.accentGreen;
      case 'Yoga': return AppColors.accentPurple;
      case 'Swimming': return AppColors.accentBlue;
      case 'Strength': return AppColors.accentYellow;
      default: return AppColors.textSecondary;
    }
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'Running': return Icons.directions_run;
      case 'Cycling': return Icons.directions_bike;
      case 'Yoga': return Icons.self_improvement;
      case 'Swimming': return Icons.pool;
      case 'Strength': return Icons.fitness_center;
      default: return Icons.sports;
    }
  }

  Color _intensityColor(String intensity) {
    switch (intensity) {
      case 'Easy': return AppColors.accentGreen;
      case 'Moderate': return AppColors.accentYellow;
      case 'Hard': return Colors.redAccent;
      default: return AppColors.textSecondary;
    }
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}

