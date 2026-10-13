import 'package:flutter/material.dart';
import 'package:fitlink/core/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
class DashboardContainer extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;
  final String name;
  final String playerId;
  final String bpm;
  final String steps;
  final String calories;
  const DashboardContainer({super.key,required this.child, required this.height, required this.width, required this.name, required this.playerId, required this.bpm,required this.calories, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
      color: const Color(0xFF0D2342),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
      color: Colors.white12,
      ),
      ),
  child:Column(
       crossAxisAlignment: CrossAxisAlignment.center,
       children: [
        Row(
         children: [
          CircleAvatar(
             radius: 20,
                backgroundColor: const Color(0xFF1E497A),child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),
           Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    playerId,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
         ],
        )
        
       ], 
        ),
        const SizedBox(height: 24,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Row(
              children: [
                Icon(Icons.monitor_heart,color: Colors.red,),
                 const SizedBox(width: 10,),
            Text(bpm),
              ],
            ),
           
           // const SizedBox(width: 60,),
            Row(
              children: [
                Icon(Icons.directions_walk,color: Colors.green,),
                const SizedBox(width: 10,),
                Text(steps),
              ],
            ),
           // const SizedBox(width: 60,),
            Row(
              children: [
                Icon(Icons.local_fire_department,color: Colors.orange,),
                const SizedBox(width: 10,),
                Text(calories),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),

const Align(
  alignment: Alignment.centerLeft,
  child: Text(
    'Heart Rate',
    style: TextStyle(
      color: Colors.white,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  ),
),

const SizedBox(height: 16),

SizedBox(
  height: 180,
  width: double.infinity,
  child: LineChart(
    LineChartData(
      minY: 50,
      maxY: 130,
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
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            interval: 20,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 25,
            interval: 1,
            getTitlesWidget: (value, meta) {
              const labels = ['1', '2', '3', '4', '5', '6'];
              final index = value.toInt();

              if (index < 0 || index >= labels.length) {
                return const SizedBox.shrink();
              }

              return Text(
                labels[index],
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                ),
              );
            },
          ),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 72),
            FlSpot(1, 85),
            FlSpot(2, 78),
            FlSpot(3, 98),
            FlSpot(4, 88),
            FlSpot(5, 105),
          ],
          isCurved: true,
          color: Colors.redAccent,
          barWidth: 3,
          dotData: const FlDotData(show: true),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.redAccent.withValues(alpha: 0.12),
          ),
        ),
      ],
    ),
  ),
),

const SizedBox(height: 16),
        child,
        ]),);
  }
}