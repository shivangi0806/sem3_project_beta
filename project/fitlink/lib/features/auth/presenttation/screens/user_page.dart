import 'package:flutter/material.dart';
import 'package:fitlink/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitlink/features/admin/presentation/cubits/users_cubit.dart';
import 'package:fitlink/features/admin/presentation/cubits/users_state.dart';
class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users"),
      actions: [
        Container(
          width: 300,
          height: 42,
             decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white70,
              ),
              borderRadius: BorderRadius.circular(10)),
              child: const TextField(
                style: TextStyle(
                  color: Colors.white,),
                   decoration: InputDecoration(
            hintText: "Search Users....",
            hintStyle: TextStyle(color: Colors.white70),
            prefixIcon: Icon(Icons.search,color: Colors.white70,),
            border: InputBorder.none
                ),
              ),),

          //style: TextStyle(color: ),
         


          
      
        IconButton(onPressed: (){}, icon: Icon(Icons.notification_add))
      ],
      ),
      

body:BlocBuilder<UsersCubit, UsersState>(
  builder: (context, state) {
    print("USERS UI STATE: $state");
return  SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.all(40),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
            // LEFT SIDE
            Expanded(
              flex: 3,
              child: Column(
                children: [
        
                  // 4 cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(20),
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
                        ),
                      ),
                    ],
                  ),
        
                  const SizedBox(height: 30),
        
                  // TOP PERFORMERS
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: navyBlueLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Top Performers",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        
            const SizedBox(width: 30),
        
            // RIGHT SIDE - RECENT ACTIVITY
            Expanded(
              flex: 1,
              child: Container(
                height: 450,
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
      
      const SizedBox(height: 30),
  
  Container(
    width: double.infinity,
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
            "All Users",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
  
          const SizedBox(height: 20),
  
  //         DataTable(
  //           horizontalMargin: 20,
  // columnSpacing: 70,
  //           headingRowColor: WidgetStateProperty.all(navyBlueMid),
  //           columns: const [
  //             DataColumn(
  //               label: Text(
  //                 "Name",
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ),
  //             DataColumn(
  //               label: Text(
  //                 "Email",
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ),
  //             DataColumn(
  //               label: Text(
  //                 "Role",
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ),
  //             DataColumn(
  //               label: Text(
  //                 "Status",
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ),
  //             DataColumn(
  //               label: Text(
  //                 "Registered",
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ),
  //             DataColumn(
  //               label: Text(
  //                 "Last Login",
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ),
  //             DataColumn(
  //               label: Text(
  //                 "Actions",
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ),
  //           ],
  
  //           rows: [
  //             DataRow(
  //               cells: [
  //                 const DataCell(
  //                   Text(
  //                     "Rahul Patel",
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 ),
  //                 const DataCell(
  //                   Text(
  //                     "rahul@gmail.com",
  //                     style: TextStyle(color: Colors.white70),
  //                   ),
  //                 ),
  //                 const DataCell(
  //                   Text(
  //                     "Player",
  //                     style: TextStyle(color: Colors.white70),
  //                   ),
  //                 ),
  //                 DataCell(
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 10,
  //                       vertical: 5,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: Colors.green.withOpacity(0.2),
  //                       borderRadius: BorderRadius.circular(20),
  //                     ),
  //                     child: const Text(
  //                       "Active",
  //                       style: TextStyle(color: Colors.green),
  //                     ),
  //                   ),
  //                 ),
  //                 const DataCell(
  //                   Text(
  //                     "12 Sep 2026",
  //                     style: TextStyle(color: Colors.white70),
  //                   ),
  //                 ),
  //                 const DataCell(
  //                   Text(
  //                     "Today, 9:20 AM",
  //                     style: TextStyle(color: Colors.white70),
  //                   ),
  //                 ),
  //                 DataCell(
  //                   IconButton(
  //                     onPressed: () {},
  //                     icon: const Icon(
  //                       Icons.more_vert,
  //                       color: Colors.white70,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  
  //             DataRow(
  //               cells: [
  //                 const DataCell(
  //                   Text(
  //                     "Priya Shah",
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 ),
  //                 const DataCell(
  //                   Text(
  //                     "priya@gmail.com",
  //                     style: TextStyle(color: Colors.white70),
  //                   ),
  //                 ),
  //                 const DataCell(
  //                   Text(
  //                     "Coach",
  //                     style: TextStyle(color: Colors.white70),
  //                   ),
  //                 ),
  //                 DataCell(
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 10,
  //                       vertical: 5,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: Colors.green.withOpacity(0.2),
  //                       borderRadius: BorderRadius.circular(20),
  //                     ),
  //                     child: const Text(
  //                       "Active",
  //                       style: TextStyle(color: Colors.green),
  //                     ),
  //                   ),
  //                 ),
  //                 const DataCell(
  //                   Text(
  //                     "10 Sep 2026",
  //                     style: TextStyle(color: Colors.white70),
  //                   ),
  //                 ),
  //                 const DataCell(
  //                   Text(
  //                     "Yesterday",
  //                     style: TextStyle(color: Colors.white70),
  //                   ),
  //                 ),
  //                 DataCell(
  //                   IconButton(
  //                     onPressed: () {},
  //                     icon: const Icon(
  //                       Icons.more_vert,
  //                       color: Colors.white70,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  
  //             DataRow(
  //               cells: [
  //                 const DataCell(
  //                   Text(
  //                     "Amit Kumar",
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 ),
  //                 const DataCell(
  //                   Text(
  //                     "amit@gmail.com",
  //                     style: TextStyle(color: Colors.white70),
  //                   ),
  //                 ),
  //                 const DataCell(
  //                   Text(
  //                     "Player",
  //                     style: TextStyle(color: Colors.white70),
  //                   ),
  //                 ),
  //                 DataCell(
  //                   Container(
  //                     padding: const EdgeInsets.symmetric(
  //                       horizontal: 10,
  //                       vertical: 5,
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: Colors.red.withOpacity(0.2),
  //                       borderRadius: BorderRadius.circular(20),
  //                     ),
  //                     child: const Text(
  //                       "Inactive",
  //                       style: TextStyle(color: Colors.red),
  //                     ),
  //                   ),
  //                 ),
  //                 const DataCell(
  //                   Text(
  //                     "05 Sep 2026",
  //                     style: TextStyle(color: Colors.white70),
  //                   ),
  //                 ),
  //                 const DataCell(
  //                   Text(
  //                     "25 Sep 2026",
  //                     style: TextStyle(color: Colors.white70),
  //                   ),
  //                 ),
  //                 DataCell(
  //                   IconButton(
  //                     onPressed: () {},
  //                     icon: const Icon(
  //                       Icons.more_vert,
  //                       color: Colors.white70,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  Table(
  columnWidths: const {
    0: FlexColumnWidth(1.2),
    1: FlexColumnWidth(2),
    2: FlexColumnWidth(1),
    3: FlexColumnWidth(1),
    4: FlexColumnWidth(1.3),
    5: FlexColumnWidth(1.5),
    6: FlexColumnWidth(0.8),
  },

  border: TableBorder(
    horizontalInside: BorderSide(
      color: Colors.white12,
    ),
  ),

  children: [
    // HEADER
    TableRow(
      decoration: BoxDecoration(
        color: navyBlueMid,
      ),
      children: const [
        Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Name",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Email",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Role",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Status",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Registered",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Last Login",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Actions",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),

    // RAHUL
    TableRow(
      children: [
        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Rahul Patel",
            style: TextStyle(color: Colors.white),
          ),
        ),

        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "rahul@gmail.com",
            style: TextStyle(color: Colors.white70),
          ),
        ),

        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Player",
            style: TextStyle(color: Colors.white70),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Active",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "12 Sep 2026",
            style: TextStyle(color: Colors.white70),
          ),
        ),

        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Today, 9:20 AM",
            style: TextStyle(color: Colors.white70),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(15),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    ),

    // PRIYA
    TableRow(
      children: [
        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Priya Shah",
            style: TextStyle(color: Colors.white),
          ),
        ),

        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "priya@gmail.com",
            style: TextStyle(color: Colors.white70),
          ),
        ),

        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Coach",
            style: TextStyle(color: Colors.white70),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Active",
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "10 Sep 2026",
            style: TextStyle(color: Colors.white70),
          ),
        ),

        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Yesterday",
            style: TextStyle(color: Colors.white70),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(15),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    ),

    // AMIT
    TableRow(
      children: [
        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Amit Kumar",
            style: TextStyle(color: Colors.white),
          ),
        ),

        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "amit@gmail.com",
            style: TextStyle(color: Colors.white70),
          ),
        ),

        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "Player",
            style: TextStyle(color: Colors.white70),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Inactive",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),

        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "05 Sep 2026",
            style: TextStyle(color: Colors.white70),
          ),
        ),

        const Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            "25 Sep 2026",
            style: TextStyle(color: Colors.white70),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(15),
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white70,
            ),
          ),
        ),
      ],
    ),
  ],
)
        ],
      ),
    ),
  ),
   ] ),
  
  ),
);
  
  })
    );

  
      
    
  }
}