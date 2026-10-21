
// import 'package:flutter/material.dart';
// import 'package:player_app/core/theme.dart';
// import 'package:player_app/screens/watch_connection_screen.dart';
// import 'core/components/player_container.dart';
// //import 'package:player_app/screens/watch_connection_screen.dart';
// //import 'package:lib/service/wearable_service.dart';
// import 'services/wearable_service.dart';
// void main() {
//   runApp( MyApp());
// }

// class MyApp extends StatelessWidget {
//    MyApp({super.key});
// final service = WearableService();
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: darkNavyTheme,
//       home: WatchConnectionScreen()
// //       Scaffold(
// //         appBar: AppBar(
// //           title: const Text("Player app"),
// //         ),
// //         body: Column(
// //           children: [
// //             Padding(
// //               padding: const EdgeInsets.all(10.0),
// //               child: Row(
// //                 children: [
// //                   PlayerContainer(
// //                     height: 430,
// //                     width: 340,
// //                     name: "shib",
// //                     playerId: "098",
// //                     bpm: "80",
// //                     calories: "90",
// //                     steps: "1212",
// //                     child: const Text("hello"),
// //                   ),
// //                 ],

// //               ),
              
// //             ),
// //            ElevatedButton(
// //   onPressed: () async {
// //     try {
// //       final result = await service.sendWearableData(
// //         playerId: '098',
// //         heartRate: 80,
// //         steps: 1212,
// //         calories: 90.0,
// //       );

// //       debugPrint('Data sent successfully: $result');
// //     } catch (e) {
// //       debugPrint('Failed to send data: $e');
// //     }
// //   },
// //   child: const Text('Send Test Data'),
// // ) // ElevatedButton(onPressed: service(), child: child)
// //           ],
// //         ),
// //       ),
      
//     );
//   }
// }
// /* 
//  1. player watch memory fix if it kills readings are lost
//  2. sync id recordedAt -->> to wearable service 
//  3. loacl db of watch
//  4. ui of everything
//  5. sync button on watch

//  */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/service/api_service.dart';
import 'features/auth/cubit/auth_cubit.dart';
import 'features/auth/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    BlocProvider(
      create: (_) => AuthCubit(ApiService()),
      child: const PlayerApp(),
    ),
  );
}

class PlayerApp extends StatelessWidget {
  const PlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitLink Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A1929),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5090D3),
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A1929),
          foregroundColor: Colors.white,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}