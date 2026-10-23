import 'package:fitlink/core/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AdminDashboardUserGrowthCart extends StatefulWidget {
  const AdminDashboardUserGrowthCart({super.key});

  @override
  State<AdminDashboardUserGrowthCart> createState() =>
      _AdminDashboardUserGrowthCartState();
}

class _AdminDashboardUserGrowthCartState
    extends State<AdminDashboardUserGrowthCart> {
  static const Map<String, List<double>> _growthData = {
    'Total Users': [120, 145, 170, 210, 245, 280],
    'Active Users': [90, 110, 135, 160, 190, 220],
    'Total Coaches': [8, 10, 12, 14, 16, 18],
    'Current Users': [75, 95, 120, 145, 170, 200],
  };

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
  ];

  String _selectedMetric = 'Total Users';

  @override
  Widget build(BuildContext context) {
    final values = _growthData[_selectedMetric]!;
    final maxValue = values.reduce((a, b) => a > b ? a : b);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: navyBlueLight,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Growth Over Time',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Monthly platform growth',
            style: TextStyle(color: Colors.white60, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _growthData.keys.map((metric) {
              final selected = _selectedMetric == metric;
              return ChoiceChip(
                label: Text(metric),
                selected: selected,
                onSelected: (_) {
                  setState(() => _selectedMetric = metric);
                },
                labelStyle: TextStyle(
                  color: selected ? Colors.white : Colors.white70,
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                ),
                selectedColor: Colors.lightBlueAccent.withValues(alpha: 0.3),
                backgroundColor: Colors.white.withValues(alpha: 0.06),
                side: BorderSide(
                  color: selected ? Colors.lightBlueAccent : Colors.white12,
                ),
                showCheckmark: false,
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 280,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (_months.length - 1).toDouble(),
                minY: 0,
                maxY: maxValue * 1.2,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      const FlLine(color: Colors.white12, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index < 0 || index >= _months.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            _months[index],
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 11,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (var index = 0; index < values.length; index++)
                        FlSpot(index.toDouble(), values[index]),
                    ],
                    isCurved: true,
                    curveSmoothness: 0.25,
                    barWidth: 3,
                    color: Colors.lightBlueAccent,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.lightBlueAccent.withValues(alpha: 0.12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
