import 'package:flutter/material.dart';
import 'package:fitlink/core/theme/app_theme.dart';
import 'package:fitlink/features/auth/presenttation/screens/user_page.dart';
import 'package:fitlink/features/auth/presenttation/screens/previleges_page.dart';
import 'package:fitlink/features/auth/presenttation/screens/dashboard_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitlink/features/admin/presentation/cubits/users_cubit.dart';
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navyBlue,
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
      
      
    );
  }
}