import 'package:fitlink/features/admin/presentation/cubits/users_state.dart';
import 'package:flutter/material.dart';
import 'package:fitlink/core/theme/app_theme.dart';
import 'package:fitlink/features/auth/presenttation/screens/user_page.dart';
import 'package:fitlink/features/auth/presenttation/screens/previleges_page.dart';
import 'package:fitlink/features/auth/presenttation/screens/dashboard_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitlink/features/admin/presentation/cubits/users_cubit.dart';
import 'package:fl_chart/fl_chart.dart';
//class AdminDashboardScreen extends StatelessWidget {
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}
Widget _sessionDetail(String title, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
 // const AdminDashboardScreen({super.key});
String selectedMetric = "Total Users";
  @override
  Widget build(BuildContext context) {
    final Map<String, List<double>> growthData = {
  "Total Users": [120, 145, 170, 210, 245, 280],
  "Active Users": [90, 110, 135, 160, 190, 220],
  "Total Coaches": [8, 10, 12, 14, 16, 18],
  "Current Users": [75, 95, 120, 145, 170, 200],
};

final List<String> months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
];
     return BlocProvider(
      create: (context) => UsersCubit(),
      child: Scaffold(
        backgroundColor: navyBlue,
    //return Scaffold(
     // backgroundColor: navyBlue,
      appBar: AppBar(
        backgroundColor: navyBlue,
        title: const Text(
          "FitLink Admin",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Logout will be added later
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      drawer: Drawer(
        backgroundColor:  accentBlue,
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          child: Text(
            "FitLink Admin",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          
        ),
        ListTile(
          leading: const Icon(Icons.dashboard),
          title: const Text("Dashboard"),
          onTap: () {
            
            Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardPage()));
          },
        ),

        ListTile(
          leading: const Icon(Icons.people),
          title: const Text("Users"),
          // onTap: () {
          //   Navigator.push(context, MaterialPageRoute(builder: (context)=> UserPage()) );
          //   //Navigator.pop(context);
          // },
          onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => UsersCubit(),
        child: UserPage(),
      ),
    ),
  );
},
        ),
        ListTile(
          leading: const Icon(Icons.star_sharp),
          title: const Text("privileges"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>PrevilegesPage()));
          },
        ),
        ])
      ),
      
      body:
BlocBuilder<UsersCubit, UsersState>(
  builder: (context, state) {
    print("USERS UI STATE: $state");
    return  SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
            // LEFT SIDE
            Expanded(
              flex: 3,
              child: 
              Column(
                children: [
        
                 // 4 cards
                  Row(
                    children: [
                      Expanded(
                        child: 
                        Container(
                          
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(20),
                            
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Total Users",style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                                        
                                ),),
                              
                              ),
                               Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("2024",style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                                        
                                ),),
                              
                              ),
                            ],
                          ),
                        ),
                      ),
        
                      const SizedBox(width: 20),
        
                      Expanded(
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Active Users",style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                                                    
                            ),),
                          ),
                        ),
                      ),
        
                      const SizedBox(width: 20),
        
                      Expanded(
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Total Coaches",style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                                                    
                            ),),
                          ),
                        ),
                      ),
        
                      const SizedBox(width: 20),
        
                      Expanded(
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(20),
                          ),child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Current Users",style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                                                    
                            ),),
                          ),
                        ),
                      ),
                    ],
                  ),
        
                  const SizedBox(height: 30),
        
                  //TOP PERFORMERS
                  // Container(
                  //   height: 300,
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //     color: navyBlueLight,
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: const Padding(
                  //     padding: EdgeInsets.all(20),
                  //     child: Text(
                  //       "User Growth Over Time",
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
  padding: const EdgeInsets.all(20),
  decoration: BoxDecoration(
    color: navyBlueLight,
    borderRadius: BorderRadius.circular(16),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "User Growth Over Time",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),

      const SizedBox(height: 16),

      // Metric selection
      Wrap(
        spacing: 8,
        children: growthData.keys.map((metric) {
          return ChoiceChip(
            label: Text(metric),
            selected: selectedMetric == metric,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  selectedMetric = metric;
                });
              }
            },
          );
        }).toList(),
      ),

      const SizedBox(height: 24),

      SizedBox(
        height: 300,
        child: LineChart(
          LineChartData(
            minY: 0,

            gridData: FlGridData(
              show: true,
            ),

            borderData: FlBorderData(
              show: true,
            ),

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
                    int index = value.toInt();

                    if (index >= 0 && index < months.length) {
                      return Text(months[index]);
                    }

                    return const SizedBox();
                  },
                ),
              ),

              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                ),
              ),
            ),

            lineBarsData: [
              LineChartBarData(
                spots: List.generate(
                  growthData[selectedMetric]!.length,
                  (index) => FlSpot(
                    index.toDouble(),
                    growthData[selectedMetric]![index],
                  ),
                ),

                isCurved: true,

                barWidth: 3,

                dotData: const FlDotData(
                  show: true,
                ),

                belowBarData: BarAreaData(
                  show: true,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
)
                
                 ],
              ),
            ),
        
           // const SizedBox(width: 30),
        
          ],
          
        ),
      
      const SizedBox(height: 30),
  Row(
  children: [
    Expanded(
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: navyBlueLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child:  Column(
          
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Session Overview",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),),
                //SizedBox(height: 20,),
              const SizedBox(height: 25),

        _sessionDetail(
          "Total Sessions",
          "24",
        ),

        _sessionDetail(
          "Completed Sessions",
          "18",
        ),
            
          ],
        ),
        
      ),
    ),

    const SizedBox(width: 40),

    // Expanded(
    //   child: Container(
    //     height: 400,
    //     decoration: BoxDecoration(
    //       color: navyBlueLight,
    //       borderRadius: BorderRadius.circular(20),
    //     ),
    //     child: const Padding(
    //       padding: EdgeInsets.all(20),
    //       child: Text(
    //         "Session Overview",
    //         style: TextStyle(
    //           color: Colors.white,
    //           fontSize: 20,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //     ),
    //   ),
    // ),
    Expanded(
  child: Container(
    height: 400,
    decoration: BoxDecoration(
      color: navyBlueLight,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Workout Completion",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 70,
                sectionsSpace: 4,

                sections: [
                  PieChartSectionData(
                    value: 75,
                    title: "75%",
                    radius: 70,
                    titleStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  PieChartSectionData(
                    value: 25,
                    title: "",
                    radius: 70,
                    color: Colors.white24,
                  ),
                ],
              ),
            ),
          ),

          const Center(
            child: Text(
              "Workouts Completed",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    ),
  ),
),
    
  ],
  

),

   const SizedBox(height: 30),
  Row(
  children: [
    Expanded(
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: navyBlueLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Coach Workload",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),

    const SizedBox(width: 40),

    Expanded(
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: navyBlueLight,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Recent Activity",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
    
  ],
  

),

   ] ),
  
  ),

);
  
  }
  )
  ));



  }
}