
//     ],
//   ),
// ),
//         ],
//       )),
//     );
//   }
// }
import 'package:fitlink/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:fitlink/features/coach/widgets/container.dart';
import 'package:fitlink/core/services/wearable_service.dart';
class CoachdashboardScreen extends StatefulWidget {
  const CoachdashboardScreen({super.key});

  @override
  State<CoachdashboardScreen> createState() =>
      _CoachdashboardScreenState();
}

class _CoachdashboardScreenState extends State<CoachdashboardScreen> {
  String selectedItem = 'Dashboard';
  final WearableService _wearableService = WearableService();

String steps = '—';
String calories = '—';

bool isLoading = true;
String? errorMessage;

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
    final List<dynamic> readings =
        await _wearableService.getWearableData('P001');

    if (readings.isEmpty) {
      if (!mounted) return;

      setState(() {
        steps = '—';
        calories = '—';
        isLoading = false;
      });
      return;
    }

    // Your backend sorts readings by recordedAt in ascending order.
    // Therefore, the last record is the newest reading.
    final latest = readings.last;

    if (!mounted) return;

    setState(() {
      steps = latest['steps']?.toString() ?? '—';
      calories = latest['calories']?.toString() ?? '—';
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

  Widget _buildNavItem(IconData icon, String title) {
    final bool isSelected = selectedItem == title;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          setState(() {
            selectedItem = title;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF1E497A)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : Colors.white70,
                size: 21,
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors.white70,
                  fontSize: 14,
                  fontWeight: isSelected
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
  IconButton(
    onPressed: isLoading ? null : fetchWearableData,
    icon: const Icon(Icons.refresh),
    tooltip: 'Refresh wearable data',
  ),
],
        title: const Text("Coach Dashboard"),
        //backgroundColor: navyBlueLight,
        backgroundColor: const Color(0xFF0D2342),
        foregroundColor: Colors.white,
      ),
      backgroundColor:navyBlueLight,
      body: SafeArea(
        child: Row(
          children: [
            // SIDEBAR
            Container(
              width: 280,
              color: const Color(0xFF0D2342),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo and title
                  const Padding(
                    padding: EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Icon(
                          Icons.fitness_center,
                          color: Colors.white,
                          size: 28,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'FitLink',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Divider(color: Colors.white24),
                  ),

                  //const SizedBox(height: 16),


                  const SizedBox(height: 24),

                 

                  _buildNavItem(
                    Icons.dashboard_outlined,
                    'Dashboard',
                  ),
                  // _buildNavItem(
                  //   Icons.people_outline,
                  //   'Players',
                  // ),
                  // _buildNavItem(
                  //   Icons.calendar_month_outlined,
                  //   'Sessions',
                  // ),
                  // _buildNavItem(
                  //   Icons.bar_chart_outlined,
                  //   'Analytics',
                  // ),
                  // _buildNavItem(
                  //   Icons.assessment_outlined,
                  //   'Reports',
                  // ),

                  const Spacer(),

                
                ],
              ),
            ),
                  // Row(
                  //   children: [
                  //       DashboardContainer( width:300, height:  400,child: const Text("Hello"),)
                  //   ]
                       
                  // ),   
            // MAIN DASHBOARD CONTENT
         
// MAIN DASHBOARD CONTENT
Expanded(
  child: Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          selectedItem == 'BPM' ? 'BPM Monitor' : selectedItem,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 24),

        Expanded(
          child: SingleChildScrollView(
            
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DashboardContainer(
                       bpm: '80',
                          steps: isLoading ? 'Loading...' : steps,
                          calories: isLoading ? 'Loading...' : calories,
                          name: "Shivangi",
                          playerId: "P001",
                        width: 500,
                        height: 450,
                        child: const Text(
                          '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DashboardContainer(
                       bpm: '80',
                        steps: isLoading ? 'Loading...' : steps,
                        calories: isLoading ? 'Loading...' : calories,
                        name: "Shivangi",
                        playerId: "P002",
                        width: 500,
                        height: 450,
                        child: const Text(
                          '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      
                    ),
                    
                  ],
                ),
                const SizedBox(height: 20,),
                //  Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     Expanded(
                //       child: DashboardContainer(
                //         width: 500,
                //         height: 400,
                //         child: const Text(
                //           'Hello',
                //           style: TextStyle(color: Colors.white),
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 20),
                //     Expanded(
                //       child: DashboardContainer(
                //         width: 500,
                //         height: 400,
                //         child: const Text(
                //           'Second Container',
                //           style: TextStyle(color: Colors.white),
                //         ),
                //       ),
                      
                //     ),
                    
                //   ],
                // ),
                  Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: DashboardContainer(
                        bpm: '80',
                        steps: '1222',
                        calories: '1112',
                        name: "Shivangi",
                        playerId: "00129",
                        width: 500,
                        height: 450,
                        child: const Text(
                          '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DashboardContainer(
                        bpm: '80',
                        steps: '1222',
                        calories: '1112',
                        name: "Shivangi",
                        playerId: "00129",
                        width: 500,
                        height: 450,
                        child: const Text(
                          '',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      
                    ),
                    
                  ],
                ),
              ],
          
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
}