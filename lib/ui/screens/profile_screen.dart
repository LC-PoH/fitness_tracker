import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../providers/fitness_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fitness = context.watch<FitnessProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: AppColors.card,
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.accent, AppColors.accentPurple],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Center(
                      child: Text(
                        'A',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Arbin Maharjan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'arbinmaharjan995@gmail.com',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _profileStat('${fitness.activities.length}', 'Workouts'),
                      Container(width: 1, height: 30, color: AppColors.border),
                      _profileStat('${fitness.streak}', 'Day Streak'),
                      Container(width: 1, height: 30, color: AppColors.border),
                      _profileStat('${fitness.allTimeCalories}', 'Total kcal'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Goals
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _Section(
                title: 'My Goals',
                icon: Icons.flag,
                children: [
                  _goalRow(
                    Icons.directions_walk,
                    'Daily Steps',
                    '${fitness.stepGoal} steps',
                    AppColors.accent,
                    fitness.stepProgress,
                  ),
                  _goalRow(
                    Icons.water_drop,
                    'Water Intake',
                    '${fitness.waterGoal.toStringAsFixed(1)} L/day',
                    AppColors.accentBlue,
                    fitness.waterProgress,
                  ),
                  _goalRow(
                    Icons.local_fire_department,
                    'Calorie Burn',
                    '${fitness.calorieGoal} kcal/day',
                    AppColors.accentYellow,
                    fitness.calorieProgress,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Settings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _Section(
                title: 'Settings',
                icon: Icons.settings,
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.accentPurple.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: AppColors.accentPurple,
                        size: 18,
                      ),
                    ),
                    title: const Text(
                      'Push Notifications',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    value: fitness.notificationsEnabled,
                    onChanged: (_) =>
                        context.read<FitnessProvider>().toggleNotifications(),
                    activeThumbColor: AppColors.accent,
                  ),
                  _settingsTile(
                    Icons.accessibility_new,
                    'Accessibility',
                    AppColors.accentBlue,
                  ),
                  _settingsTile(
                    Icons.lock,
                    'Privacy & Data',
                    AppColors.accentGreen,
                  ),
                  _settingsTile(
                    Icons.language,
                    'Language',
                    AppColors.accentYellow,
                    trailing: const Text(
                      'English',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // About
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _Section(
                title: 'About',
                icon: Icons.info,
                children: [
                  _settingsTile(
                    Icons.help_outline,
                    'Help & Support',
                    AppColors.accent,
                  ),
                  _settingsTile(
                    Icons.star,
                    'Rate FitTrack',
                    AppColors.accentYellow,
                  ),
                  _settingsTile(
                    Icons.description,
                    'Terms of Service',
                    AppColors.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'FitTrack v1.0.0',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Log out
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout, color: Colors.redAccent),
                  label: const Text(
                    'Log Out',
                    style: TextStyle(color: Colors.redAccent, fontSize: 15),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _profileStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _goalRow(
    IconData icon,
    String label,
    String value,
    Color color,
    double progress,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 5,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile(
    IconData icon,
    String label,
    Color color, {
    Widget? trailing,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      trailing:
          trailing ??
          const Icon(Icons.chevron_right, color: AppColors.textMuted),
      onTap: () {},
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Log Out',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _Section({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
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
              Icon(icon, color: AppColors.accent, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.border, height: 20),
          ...children,
        ],
      ),
    );
  }
}
