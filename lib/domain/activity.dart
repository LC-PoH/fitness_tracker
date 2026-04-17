// Represents a single workout activity
class Activity {
  final String name;
  final String type;
  final int duration; // minutes
  final int calories;
  final DateTime date;
  final String intensity; // Easy, Moderate, Hard
  final double? distance; // km, optional

  Activity({
    required this.name,
    required this.type,
    required this.duration,
    required this.calories,
    DateTime? date,
    this.intensity = 'Moderate',
    this.distance,
  }) : date = date ?? DateTime.now();
}
