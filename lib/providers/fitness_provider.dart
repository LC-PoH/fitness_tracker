import 'package:flutter/material.dart';
import '../domain/activity.dart';
import '../data/dummy_data.dart';

// State manager for the fitness app using Provider pattern
class FitnessProvider extends ChangeNotifier {
  final List<Activity> _activities = List.from(dummyActivities);
  int _steps = 6450;
  double _water = 1.5;
  final int _heartRate = 72;
  bool _notificationsEnabled = true;

  // Daily goals
  final int stepGoal = 10000;
  final double waterGoal = 3.0;
  final int calorieGoal = 600;

  // Getters
  List<Activity> get activities => List.unmodifiable(_activities);
  int get steps => _steps;
  double get water => _water;
  int get heartRate => _heartRate;
  bool get notificationsEnabled => _notificationsEnabled;

  // Calories burned today
  int get totalCalories => _activities
      .where((a) => _isToday(a.date))
      .fold(0, (sum, a) => sum + a.calories);

  // Total calories across all activities
  int get allTimeCalories => _activities.fold(0, (sum, a) => sum + a.calories);

  // Total minutes worked out today
  int get todayMinutes => _activities
      .where((a) => _isToday(a.date))
      .fold(0, (sum, a) => sum + a.duration);

  int get streak => 6;

  List<int> get weeklySteps => List.from(dummyWeeklySteps);
  List<int> get weeklyCalories => List.from(dummyWeeklyCalories);

  double get stepProgress => (_steps / stepGoal).clamp(0.0, 1.0);
  double get waterProgress => (_water / waterGoal).clamp(0.0, 1.0);
  double get calorieProgress => (totalCalories / calorieGoal).clamp(0.0, 1.0);

  void addActivity(Activity activity) {
    _activities.insert(0, activity);
    notifyListeners();
  }

  void removeActivity(int index) {
    _activities.removeAt(index);
    notifyListeners();
  }

  void addWater() {
    _water = (_water + 0.25).clamp(0.0, waterGoal + 1);
    notifyListeners();
  }

  void removeWater() {
    _water = (_water - 0.25).clamp(0.0, waterGoal + 1);
    notifyListeners();
  }

  void addSteps(int count) {
    _steps = (_steps + count).clamp(0, 99999);
    notifyListeners();
  }

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
