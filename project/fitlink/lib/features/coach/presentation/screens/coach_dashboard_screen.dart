import 'package:flutter/material.dart';
import 'package:fitlink/features/coach/data/model/coach_model.dart';
import 'package:fitlink/core/theme/app_theme.dart';
class CoachDashboardScreen extends StatelessWidget {
  const CoachDashboardScreen({super.key});

 

  final List<PlayerData> players = const [
    PlayerData(
      id: 'P001',
      bpm: 80,
      steps: 4532,
      calories: 210,
      status: 'Active',
      heartRate: [
        78, 77, 80, 82, 85, 88, 90, 94,
        98, 102, 108, 110, 106, 100, 94, 88,
        82, 78, 74, 72, 74, 86, 80,
      ],
    ),
    PlayerData(
      id: 'P002',
      bpm: 92,
      steps: 3876,
      calories: 185,
      status: 'Active',
      heartRate: [
        76, 75, 78, 80, 84, 88, 90, 94,
        98, 104, 110, 114, 109, 102, 96, 92,
        98, 90, 84, 78, 76, 88, 86,
      ],
    ),
    PlayerData(
      id: 'P003',
      bpm: 76,
      steps: 2940,
      calories: 120,
      status: 'Resting',
      heartRate: [
        78, 77, 78, 80, 79, 78, 76, 74,
        72, 73, 74, 76, 78, 80, 82, 80,
        90, 84, 78, 80, 79, 78, 81,
      ],
    ),
    PlayerData(
      id: 'P004',
      bpm: 88,
      steps: 4120,
      calories: 195,
      status: 'Active',
      heartRate: [
        80, 82, 88, 94, 90, 84, 80, 86,
        92, 96, 100, 106, 110, 114, 110, 104,
        98, 90, 94, 96, 90, 82, 86,
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navyBlue,
      body: SafeArea(
        child: Row(
          children: [
            _buildSidebar(),
            Expanded(
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isSmall = constraints.maxWidth < 900;

                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPageTitle(),
                              const SizedBox(height: 20),

                              GridView.builder(
                                shrinkWrap: true,
                                physics:
                                    const NeverScrollableScrollPhysics(),
                                itemCount: players.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: isSmall ? 1 : 2,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  childAspectRatio: isSmall ? 1.45 : 1.15,
                                ),
                                itemBuilder: (context, index) {
                                  return PlayerCard(
                                    player: players[index],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: const Color(0xFF0B2140),
        border: Border(
          right: BorderSide(
            color: Colors.white.withOpacity(.06),
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo
          Container(
            height: 86,
            padding: const EdgeInsets.symmetric(horizontal: 28),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                const Icon(
                  Icons.directions_run,
                  color: accentBlue,
                  size: 36,
                ),
                const SizedBox(width: 10),
                const Text(
                  'FitLink',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: Colors.white.withOpacity(.06),
            height: 1,
          ),

          const SizedBox(height: 18),

          _sidebarItem(
            Icons.grid_view_rounded,
            'Players',
            selected: true,
          ),
          _sidebarItem(
            Icons.access_time_rounded,
            'Sessions',
          ),
          _sidebarItem(
            Icons.bar_chart_rounded,
            'Analytics',
          ),
          _sidebarItem(
            Icons.description_outlined,
            'Reports',
          ),
          _sidebarItem(
            Icons.settings_outlined,
            'Settings',
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(28),
            child: Row(
              children: [
                Icon(
                  Icons.monitor_heart_outlined,
                  color: accentBlue,
                  size: 24,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Better Data.\nStronger Players.',
                    style: TextStyle(
                      color: Color(0xFF9DB6D5),
                      height: 1.5,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(
    IconData icon,
    String title, {
    bool selected = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 4,
      ),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFF174B8F)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(
              icon,
              color: selected
                  ? Colors.white
                  : const Color(0xFF91ACCC),
              size: 23,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : const Color(0xFF91ACCC),
                fontSize: 16,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 86,
      padding: const EdgeInsets.symmetric(horizontal: 26),
      decoration: BoxDecoration(
        color: const Color(0xFF0B2344),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(.06),
          ),
        ),
      ),
      child: Row(
        children: [
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Coach Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Monitor. Guide. Improve.',
                style: TextStyle(
                  color: Color(0xFF91ACCC),
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const Spacer(),

          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Positioned(
                right: 9,
                top: 9,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 15),

          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFF7187A8),
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 10),

          const Text(
            'Coach',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
            ),
          ),

          const SizedBox(width: 5),

          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white70,
          ),
        ],
      ),
    );
  }

  Widget _buildPageTitle() {
    return Row(
      children: [
        const Icon(
          Icons.people_alt_outlined,
          color: accentBlue,
          size: 30,
        ),
        const SizedBox(width: 12),
        const Text(
          'Player Performance',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 17,
            vertical: 11,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF102D52),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: Color(0xFF9DB6D5),
                size: 19,
              ),
              SizedBox(width: 10),
              Text(
                'Today',
                style: TextStyle(
                  color: Color(0xFFB6C9E0),
                  fontSize: 15,
                ),
              ),
              SizedBox(width: 18),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF9DB6D5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


// ============================================================
// PLAYER CARD
// ============================================================

class PlayerCard extends StatelessWidget {
  final PlayerData player;

  const PlayerCard({
    super.key,
    required this.player,
  });

  static const Color cardBlue = Color(0xFF0D2344);
  static const Color green = Color(0xFF27C39F);
  static const Color orange = Color(0xFFFFB84D);
  static const Color accentBlue = Color(0xFF5090D3);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBlue,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFF1B4678),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Player header
          Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: _playerColor(player.id),
                child: Text(
                  player.id,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 13),

              Text(
                player.id,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(width: 12),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: player.status == 'Active'
                      ? const Color(0xFF139A77)
                      : const Color(0xFF1763C2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  player.status,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const Spacer(),

              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFF82A6D3),
                size: 27,
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Metrics
          Row(
            children: [
              _metric(
                Icons.favorite_rounded,
                '${player.bpm} BPM',
                Colors.redAccent,
              ),
              _metric(
                Icons.directions_walk_rounded,
                _formatNumber(player.steps),
                green,
              ),
              _metric(
                Icons.local_fire_department_rounded,
                '${player.calories} kcal',
                orange,
              ),
            ],
          ),

          const SizedBox(height: 13),

          // Heart rate
          Container(
            height: 143,
            padding: const EdgeInsets.fromLTRB(10, 7, 10, 5),
            decoration: BoxDecoration(
              color: const Color(0xFF102D52),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Heart Rate',
                  style: TextStyle(
                    color: Color(0xFFD6E4F5),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Expanded(
                  child: HeartRateChart(
                    values: player.heartRate,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 11),

          ProgressRow(
            icon: Icons.directions_walk_rounded,
            title: 'Steps Today',
            value: player.steps,
            maxValue: 6000,
            suffix: '${_formatNumber(player.steps)} / 6,000',
            color: green,
          ),

          const SizedBox(height: 9),

          ProgressRow(
            icon: Icons.local_fire_department_rounded,
            title: 'Calories',
            value: player.calories,
            maxValue: 400,
            suffix: '${player.calories} / 400',
            color: orange,
          ),
        ],
      ),
    );
  }

  Widget _metric(
    IconData icon,
    String text,
    Color color,
  ) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Color(0xFFE1EBF7),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _playerColor(String id) {
    switch (id) {
      case 'P001':
        return const Color(0xFF328AC8);
      case 'P002':
        return const Color(0xFF5276E8);
      case 'P003':
        return const Color(0xFF635CE1);
      default:
        return const Color(0xFF38B6C9);
    }
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => '${match[1]},',
        );
  }
}


// ============================================================
// PROGRESS BAR
// ============================================================

class ProgressRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final int value;
  final int maxValue;
  final String suffix;
  final Color color;

  const ProgressRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.maxValue,
    required this.suffix,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (value / maxValue).clamp(0.0, 1.0);

    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 21,
            ),
            const SizedBox(width: 9),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFFE0EAF6),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              suffix,
              style: const TextStyle(
                color: Color(0xFFC3D2E5),
                fontSize: 13,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Container(
                height: 12,
                width: double.infinity,
                color: const Color(0xFF19395F),
              ),
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


// ============================================================
// HEART RATE CHART
// ============================================================

class HeartRateChart extends StatelessWidget {
  final List<double> values;

  const HeartRateChart({
    super.key,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HeartRatePainter(values),
      child: const SizedBox.expand(),
    );
  }
}

class HeartRatePainter extends CustomPainter {
  final List<double> values;

  HeartRatePainter(this.values);

  @override
  void paint(Canvas canvas, Size size) {
    const leftPadding = 30.0;
    const bottomPadding = 20.0;
    const topPadding = 5.0;
    const rightPadding = 5.0;

    final chartWidth =
        size.width - leftPadding - rightPadding;

    final chartHeight =
        size.height - topPadding - bottomPadding;

    final gridPaint = Paint()
      ..color = const Color(0xFF234467)
      ..strokeWidth = 1;

    final linePaint = Paint()
      ..color = const Color(0xFF4289E8)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Horizontal grid lines
    for (int i = 0; i < 4; i++) {
      final y = topPadding +
          (chartHeight / 3) * i;

      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        gridPaint,
      );
    }

    // Y-axis labels
    const labels = ['120', '100', '80', '60'];

    for (int i = 0; i < labels.length; i++) {
      final y = topPadding +
          (chartHeight / 3) * i;

      final textPainter = TextPainter(
        text: TextSpan(
          text: labels[i],
          style: const TextStyle(
            color: Color(0xFFB5C9E2),
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(
          0,
          y - textPainter.height / 2,
        ),
      );
    }

    if (values.isEmpty) return;

    final path = Path();

    for (int i = 0; i < values.length; i++) {
      final x = leftPadding +
          (i / (values.length - 1)) * chartWidth;

      final normalized =
          ((values[i] - 60) / 60).clamp(0.0, 1.0);

      final y =
          topPadding + chartHeight * (1 - normalized);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, linePaint);

    // X-axis labels
    const xLabels = ['0', '10', '20', '30', '40'];

    for (int i = 0; i < xLabels.length; i++) {
      final x = leftPadding +
          (i / (xLabels.length - 1)) * chartWidth;

      final textPainter = TextPainter(
        text: TextSpan(
          text: xLabels[i],
          style: const TextStyle(
            color: Color(0xFFB5C9E2),
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          size.height - textPainter.height,
        ),
      );
    }

    final minTextPainter = TextPainter(
      text: const TextSpan(
        text: 'min',
        style: TextStyle(
          color: Color(0xFFB5C9E2),
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    minTextPainter.layout();

    minTextPainter.paint(
      canvas,
      Offset(
        size.width - minTextPainter.width,
        size.height - minTextPainter.height,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant HeartRatePainter oldDelegate) {
    return oldDelegate.values != values;
  }
}


