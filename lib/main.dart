import 'package:flutter/material.dart';
import 'audio_player_home.dart';
import 'user_list_screen.dart';

void main() {
  runApp(const UserManagerApp());
}

class UserManagerApp extends StatelessWidget {
  const UserManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4361EE),
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const UserListScreen(),
    );
  }
}

// void main() {
//   runApp(const MusicPlayerApp());
// }
//
// class MusicPlayerApp extends StatelessWidget {
//   const MusicPlayerApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Beats Player',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         brightness: Brightness.dark,
//         colorScheme: const ColorScheme.dark(
//           primary: Color(0xFFE8FF47),
//           surface: Color(0xFF0D0D0D),
//         ),
//         scaffoldBackgroundColor: const Color(0xFF0D0D0D),
//       ),
//       home: const AudioPlayerHome(),
//     );
//   }
// }
