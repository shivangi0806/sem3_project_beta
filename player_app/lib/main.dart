import 'package:flutter/material.dart';
import 'package:player_app/core/theme.dart';
import 'core/components/player_container.dart';
//import 'package:fitlink/core/theme/app_theme.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Player app"),),
      body: Column(
        children: [
          Row(
            children: [
              
            ],
          )
        ],
      ),
    );
     }
}

