import 'package:fitlink/core/services/wearable_service.dart';
import 'package:fitlink/core/theme/app_theme.dart';
import 'package:fitlink/features/coach/widgets/container.dart';
import 'package:fitlink/features/sessions/presentation/screens/session_management_screen.dart';
import 'package:fitlink/features/coach/presentation/screens/coach_player_assignment_screen.dart';
import 'package:flutter/material.dart';

class CoachdashboardScreen extends StatefulWidget {
  const CoachdashboardScreen({super.key});

  @override
  State<CoachdashboardScreen> createState() => _CoachdashboardScreenState();
}

class _CoachdashboardScreenState extends State<CoachdashboardScreen> {
  String selectedItem = 'Dashboard';
  final WearableService _wearableService = WearableService();
  String steps = '—';
  String calories = '—';
  bool isLoading = true;
  String? errorMessage;

  static const _menu = <(String, IconData)>[
    ('Dashboard', Icons.dashboard_rounded),
    ('Sessions', Icons.calendar_month_rounded),
    ('Players', Icons.groups_rounded),
    ('Analytics', Icons.insights_rounded),
    ('Profile', Icons.person_outline_rounded),
  ];

  @override
  void initState() {
    super.initState();
    fetchWearableData();
  }

  Future<void> fetchWearableData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      final readings = await _wearableService.getWearableData('P001');
      if (!mounted) return;
      final latest = readings.isEmpty ? null : readings.last;
      setState(() {
        steps = latest?['steps']?.toString() ?? '—';
        calories = latest?['calories']?.toString() ?? '—';
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  void _select(String title) {
    setState(() => selectedItem = title);
    if (MediaQuery.sizeOf(context).width < 900) Navigator.of(context).pop();
  }

  Widget _buildNavItem(String title, IconData icon) {
    final selected = selectedItem == title;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
      child: Semantics(
        button: true,
        selected: selected,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _select(title),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF1E497A) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: selected
                  ? Border.all(color: accentBlue.withValues(alpha: .35))
                  : null,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: selected ? Colors.white : const Color(0xFF9DB6D5),
                  size: 21,
                ),
                const SizedBox(width: 14),
                Text(
                  title,
                  style: TextStyle(
                    color: selected ? Colors.white : const Color(0xFFB6C9E0),
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                if (selected) ...[
                  const Spacer(),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF8BC5FF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigation() => Container(
    width: 270,
    color: const Color(0xFF0D2342),
    child: SafeArea(
      bottom: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E497A),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.fitness_center,
                    color: Color(0xFF8BC5FF),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'FitLink',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF153456),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: .07)),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 23,
                    backgroundColor: Color(0xFF5090D3),
                    child: Icon(Icons.person_rounded, color: Colors.white),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Coach',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Team administrator',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: .65),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.more_vert,
                    color: Colors.white.withValues(alpha: .7),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
            child: Text(
              'WORKSPACE',
              style: TextStyle(
                color: Colors.white.withValues(alpha: .45),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          for (final item in _menu) _buildNavItem(item.$1, item.$2),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .045),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.monitor_heart_outlined,
                    color: Color(0xFF8BC5FF),
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Better data.\nStronger players.',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: .72),
                        height: 1.4,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 900;
    return Scaffold(
      drawer: compact
          ? Drawer(
              backgroundColor: const Color(0xFF0D2342),
              child: _buildNavigation(),
            )
          : null,
      appBar: AppBar(
        toolbarHeight: 76,
        titleSpacing: compact ? 4 : 24,
        title: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: accentBlue.withValues(alpha: .16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _menu.firstWhere((item) => item.$1 == selectedItem).$2,
                color: const Color(0xFF8BC5FF),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedItem,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .1,
                    ),
                  ),
                  if (!compact) ...[
                    const SizedBox(height: 2),
                    Text(
                      _subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: .62),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0D2342),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        shape: const Border(bottom: BorderSide(color: Colors.white12)),
        actions: [
          if (selectedItem == 'Dashboard' && compact)
            IconButton(
              onPressed: isLoading ? null : fetchWearableData,
              tooltip: 'Refresh wearable data',
              icon: isLoading
                  ? const SizedBox(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh_rounded),
            ),
          if (selectedItem == 'Dashboard' && !compact)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: OutlinedButton.icon(
                onPressed: isLoading ? null : fetchWearableData,
                icon: isLoading
                    ? const SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.refresh_rounded, size: 17),
                label: Text(isLoading ? 'Updating' : 'Refresh'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFD7E8FA),
                  side: BorderSide(color: Colors.white.withValues(alpha: .14)),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  minimumSize: const Size(42, 40),
                ),
              ),
            ),
          // Padding(
          //   padding: EdgeInsets.only(left: 12, right: compact ? 12 : 24),
          //   child: Row(mainAxisSize: MainAxisSize.min, children: [
          //     const CircleAvatar(radius: 17, backgroundColor: Color(0xFF1E497A), child: Icon(Icons.person, size: 19)),
          //     if (!compact) ...[
          //       const SizedBox(width: 9),
          //       const Text('Coach', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          //     ],
          //   ]),
          // ),
        ],
      ),
      backgroundColor: navyBlueLight,
      body: SafeArea(
        child: Row(
          children: [
            if (!compact) _buildNavigation(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(compact ? 16 : 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (selectedItem == 'Dashboard')
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              if (errorMessage != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: MaterialBanner(
                                    content: Text(
                                      'Could not load wearable data. $errorMessage',
                                    ),
                                    leading: const Icon(Icons.wifi_off_rounded),
                                    actions: [
                                      TextButton(
                                        onPressed: fetchWearableData,
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                ),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final width = constraints.maxWidth < 720
                                      ? constraints.maxWidth
                                      : (constraints.maxWidth - 20) / 2;
                                  return Wrap(
                                    spacing: 20,
                                    runSpacing: 20,
                                    children: [
                                      _playerCard(
                                        width,
                                        'Shivangi',
                                        'P001',
                                        isLoading ? 'Loading…' : steps,
                                        isLoading ? 'Loading…' : calories,
                                      ),
                                      _playerCard(
                                        width,
                                        'Shivangi',
                                        'P002',
                                        isLoading ? 'Loading…' : steps,
                                        isLoading ? 'Loading…' : calories,
                                      ),
                                      _playerCard(
                                        width,
                                        'Shivangi',
                                        '00129',
                                        '1,222',
                                        '1,112',
                                      ),
                                      _playerCard(
                                        width,
                                        'Shivangi',
                                        '00129',
                                        '1,222',
                                        '1,112',
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (selectedItem == 'Sessions')
                      const Expanded(child: SessionManagementScreen())
                    else if (selectedItem == 'Players')
                      const Expanded(child: CoachPlayerAssignmentScreen())
                    else
                      Expanded(
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 460),
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: navyBlue,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _menu
                                      .firstWhere(
                                        (item) => item.$1 == selectedItem,
                                      )
                                      .$2,
                                  color: const Color(0xFF8BC5FF),
                                  size: 38,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '$selectedItem workspace',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'This section is ready for your $selectedItem tools.',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFF9DB6D5),
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 18),
                                OutlinedButton.icon(
                                  onPressed: () => _select('Dashboard'),
                                  icon: const Icon(Icons.dashboard_outlined),
                                  label: const Text('Back to dashboard'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _playerCard(
    double width,
    String name,
    String id,
    String stepCount,
    String calorieCount,
  ) => SizedBox(
    width: width,
    child: DashboardContainer(
      bpm: '80',
      steps: stepCount,
      calories: calorieCount,
      name: name,
      playerId: id,
      width: width,
      height: 450,
      child: const Text(
        '',
        style: TextStyle(color: Colors.white54, fontSize: 12),
      ),
    ),
  );

  String get _subtitle => switch (selectedItem) {
    'Dashboard' => 'A clear view of your team’s training and wellbeing.',
    'Sessions' => 'Plan and review your team training sessions.',
    'Players' => 'View and support your roster.',
    'Analytics' => 'Track progress and team performance.',
    'Profile' => 'Manage your coach profile and preferences.',
    _ => '',
  };
}
