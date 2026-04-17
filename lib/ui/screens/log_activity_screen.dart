import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../providers/fitness_provider.dart';
import '../../domain/activity.dart';

class LogActivityScreen extends StatefulWidget {
  const LogActivityScreen({super.key});

  @override
  State<LogActivityScreen> createState() => _LogActivityScreenState();
}

class _LogActivityScreenState extends State<LogActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _distanceController = TextEditingController();

  String _selectedType = 'Running';
  String _selectedIntensity = 'Moderate';

  final List<String> _types = ['Running', 'Cycling', 'Yoga', 'Swimming', 'Strength'];
  final List<String> _intensities = ['Easy', 'Moderate', 'Hard'];

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _caloriesController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final distance = _distanceController.text.isNotEmpty
          ? double.tryParse(_distanceController.text)
          : null;

      context.read<FitnessProvider>().addActivity(Activity(
        name: _nameController.text.trim(),
        type: _selectedType,
        duration: int.parse(_durationController.text),
        calories: int.parse(_caloriesController.text),
        intensity: _selectedIntensity,
        distance: distance,
      ));

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_nameController.text} logged!'),
          backgroundColor: AppColors.accentGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
        ),
      );
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

  Color _colorForIntensity(String intensity) {
    switch (intensity) {
      case 'Easy': return AppColors.accentGreen;
      case 'Moderate': return AppColors.accentYellow;
      case 'Hard': return Colors.redAccent;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Log Workout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Workout type selector
              const Text(
                'Workout Type',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 85,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _types.length,
                  itemBuilder: (context, i) {
                    final type = _types[i];
                    final isSelected = type == _selectedType;
                    final color = _colorForType(type);
                    // GestureDetector has no implicit role; Semantics exposes it as a button
                    // and announces the selected state (e.g. "Running workout type, selected")
                    return Semantics(
                      label: '$type workout type${isSelected ? ", selected" : ""}',
                      button: true,
                      selected: isSelected,
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedType = type),
                        child: Container(
                          width: 78,
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: isSelected ? color.withValues(alpha: 0.2) : AppColors.card,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? color : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _iconForType(type),
                                color: isSelected ? color : AppColors.textSecondary,
                                size: 26,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                type,
                                style: TextStyle(
                                  color: isSelected ? color : AppColors.textSecondary,
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Intensity selector
              const Text(
                'Intensity',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: _intensities.map((intensity) {
                  final isSelected = intensity == _selectedIntensity;
                  final color = _colorForIntensity(intensity);
                  return Expanded(
                    // Semantics exposes intensity selection state so screen readers announce
                    // both the option name and whether it is currently chosen
                    child: Semantics(
                      label: '$intensity intensity${isSelected ? ", selected" : ""}',
                      button: true,
                      selected: isSelected,
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedIntensity = intensity),
                        child: Container(
                          margin: EdgeInsets.only(right: intensity != _intensities.last ? 8 : 0),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? color.withValues(alpha: 0.18) : AppColors.card,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? color : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              intensity,
                              style: TextStyle(
                                color: isSelected ? color : AppColors.textSecondary,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Activity name
              const Text(
                'Activity Name',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'e.g. Morning Run',
                  hintStyle: TextStyle(color: AppColors.textMuted),
                  prefixIcon: Icon(Icons.edit),
                ),
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),

              // Duration and Calories side by side
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Duration (min)',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _durationController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: '30',
                            hintStyle: TextStyle(color: AppColors.textMuted),
                            prefixIcon: Icon(Icons.timer),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (int.tryParse(v) == null) return 'Invalid number';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Calories (kcal)',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _caloriesController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: '250',
                            hintStyle: TextStyle(color: AppColors.textMuted),
                            prefixIcon: Icon(Icons.local_fire_department),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (int.tryParse(v) == null) return 'Invalid number';
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Distance (optional)
              const Text(
                'Distance (km) - optional',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _distanceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'e.g. 5.0',
                  hintStyle: TextStyle(color: AppColors.textMuted),
                  prefixIcon: Icon(Icons.straighten),
                ),
              ),
              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check),
                  label: const Text(
                    'Save Workout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Cancel button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


