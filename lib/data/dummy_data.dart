import '../domain/activity.dart';

/// Hardcoded dummy activities for prototype demonstration
final List<Activity> dummyActivities = [
  Activity(
    name: 'Morning Run',
    type: 'Running',
    duration: 32,
    calories: 310,
    date: DateTime.now().subtract(const Duration(hours: 3)),
    intensity: 'Moderate',
    distance: 4.8,
  ),
  Activity(
    name: 'Power Yoga',
    type: 'Yoga',
    duration: 45,
    calories: 190,
    date: DateTime.now().subtract(const Duration(days: 1)),
    intensity: 'Easy',
  ),
  Activity(
    name: 'Cycling Session',
    type: 'Cycling',
    duration: 55,
    calories: 420,
    date: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
    intensity: 'Hard',
    distance: 18.2,
  ),
  Activity(
    name: 'Lap Swimming',
    type: 'Swimming',
    duration: 40,
    calories: 340,
    date: DateTime.now().subtract(const Duration(days: 2)),
    intensity: 'Moderate',
    distance: 1.2,
  ),
  Activity(
    name: 'Weight Training',
    type: 'Strength',
    duration: 50,
    calories: 360,
    date: DateTime.now().subtract(const Duration(days: 3)),
    intensity: 'Hard',
  ),
  Activity(
    name: 'Evening Walk',
    type: 'Running',
    duration: 25,
    calories: 180,
    date: DateTime.now().subtract(const Duration(days: 4)),
    intensity: 'Easy',
    distance: 2.5,
  ),
  Activity(
    name: 'HIIT Circuit',
    type: 'Strength',
    duration: 30,
    calories: 380,
    date: DateTime.now().subtract(const Duration(days: 5)),
    intensity: 'Hard',
  ),
];

/// Weekly step data (Mon–Sun) for the bar chart
const List<int> dummyWeeklySteps = [7200, 9800, 6100, 11200, 8500, 6450, 0];

/// Weekly calorie burn data
const List<int> dummyWeeklyCalories = [340, 520, 190, 720, 360, 380, 0];
