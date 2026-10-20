
import 'package:flutter/material.dart';
import 'package:player_app/core/theme.dart';
import 'package:player_app/screens/watch_connection_screen.dart';
import 'core/components/player_container.dart';
//import 'package:player_app/screens/watch_connection_screen.dart';
//import 'package:lib/service/wearable_service.dart';
import 'services/wearable_service.dart';
void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
final service = WearableService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: darkNavyTheme,
      home: WatchConnectionScreen()
//       Scaffold(
//         appBar: AppBar(
//           title: const Text("Player app"),
//         ),
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Row(
//                 children: [
//                   PlayerContainer(
//                     height: 430,
//                     width: 340,
//                     name: "shib",
//                     playerId: "098",
//                     bpm: "80",
//                     calories: "90",
//                     steps: "1212",
//                     child: const Text("hello"),
//                   ),
//                 ],

//               ),
              
//             ),
//            ElevatedButton(
//   onPressed: () async {
//     try {
//       final result = await service.sendWearableData(
//         playerId: '098',
//         heartRate: 80,
//         steps: 1212,
//         calories: 90.0,
//       );

//       debugPrint('Data sent successfully: $result');
//     } catch (e) {
//       debugPrint('Failed to send data: $e');
//     }
//   },
//   child: const Text('Send Test Data'),
// ) // ElevatedButton(onPressed: service(), child: child)
//           ],
//         ),
//       ),
      
    );
  }
}
/* 
 1. player watch memory fix if it kills readings are lost
 2. sync id recordedAt -->> to wearable service 
 3. loacl db of watch
 4. ui of everything
 5. sync button on watch

 */