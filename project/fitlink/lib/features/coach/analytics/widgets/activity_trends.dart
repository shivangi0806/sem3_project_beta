
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'analytics_container.dart';

class ActivityTrends extends StatelessWidget {
  // const ActivityTrends({super.key});
  final List<dynamic> trends;

  const ActivityTrends({
    super.key,
    required this.trends,
  });

  @override
  Widget build(BuildContext context) {
    return AnalyticsContainer(
      title: 'Activity Trends',
      child: trends.isEmpty
    ? const SizedBox(
        height: 320,
        child: Center(
          child: Text(
            'No activity data available for this period',
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ),
      )
    : SizedBox(
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.white12,
                  strokeWidth: 1,
                );
              },
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                // spots: const [
                //   FlSpot(0, 20),
                //   FlSpot(1, 35),
                //   FlSpot(2, 28),
                //   FlSpot(3, 50),
                //   FlSpot(4, 42),
                //   FlSpot(5, 65),
                //   FlSpot(6, 55),
                // ],
                spots: trends.asMap().entries.map((entry) {
  final value = entry.value['totalSteps'];

  return FlSpot(
    entry.key.toDouble(),
    (value as num?)?.toDouble() ?? 0,
  );
}).toList(),
                isCurved: true,
                color: const Color(0xFF21C5C0),
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: const Color(0xFF21C5C0).withValues(alpha: 0.15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}