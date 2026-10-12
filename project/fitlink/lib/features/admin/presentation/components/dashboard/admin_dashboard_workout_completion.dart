import 'package:fitlink/core/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WorkoutCompletionData {
  final String title;
  final String value;
  final TextStyle? style;
  final double radius;
  final Color? color;

  const WorkoutCompletionData({
    required this.title,
    required this.value,
    required this.style,
    required this.radius,
    this.color,
  });
}

class AdminDashboardWorkoutCompletion extends StatelessWidget {
  final List<WorkoutCompletionData> data;

  const AdminDashboardWorkoutCompletion({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 400,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: navyBlueLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workout Completion',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Completion rate for assigned workouts',
              style: TextStyle(color: Colors.white60, fontSize: 13),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 64,
                  sectionsSpace: 4,
                  sections: data.map((item) {
                    final value = double.tryParse(item.value) ?? 0;
                    return PieChartSectionData(
                      value: value,
                      title: item.title,
                      color: item.color ?? Colors.lightBlueAccent,
                      radius: item.radius,
                      titleStyle: item.style,
                    );
                  }).toList(),
                ),
              ),
            ),
            const Center(
              child: Text(
                'Workouts Completed',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
