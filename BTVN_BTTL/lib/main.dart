import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/sinhvien_provider.dart';
import 'provider/todo_provider.dart';
import 'provider/sanpham_provider.dart';
import 'provider/chitieu_provider.dart';
import 'view/v_login.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SinhVienProvider()),
        ChangeNotifierProvider(create: (context) => TodoProvider()),
        ChangeNotifierProvider(create: (context) => SanPhamProvider()),
        ChangeNotifierProvider(create: (context) => ChiTieuProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}


//bai1//import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'provider/sinhvien_provider.dart';
// import 'view/v_sinhvien.dart';
//
// void main() {
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => SinhVienProvider(),
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Quản lý Sinh Viên',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       home: const SinhVienListScreen(),
//     );
//   }
// }

//bai2//import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'provider/sinhvien_provider.dart';
// import 'provider/todo_provider.dart';
// import 'view/v_sinhvien.dart';
// import 'view/v_todo.dart';
//
// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => SinhVienProvider()),
//         ChangeNotifierProvider(create: (context) => TodoProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       home: const TodoScreen(), // đổi thành SinhVienListScreen() nếu muốn
//     );
//   }
// }

//bai3//import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'provider/sinhvien_provider.dart';
// import 'provider/todo_provider.dart';
// import 'provider/sanpham_provider.dart';
// import 'view/v_todo.dart';
// import 'view/v_sanpham.dart';
// import 'view/v_sinhvien.dart';
//
// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => SinhVienProvider()),
//         ChangeNotifierProvider(create: (context) => TodoProvider()),
//         ChangeNotifierProvider(create: (context) => SanPhamProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       home: const MainNavScreen(),
//     );
//   }
// }
//
// // ── Bottom Nav để chuyển giữa các màn hình ──────────────────────────
//
// class MainNavScreen extends StatefulWidget {
//   const MainNavScreen({super.key});
//
//   @override
//   State<MainNavScreen> createState() => _MainNavScreenState();
// }
//
// class _MainNavScreenState extends State<MainNavScreen> {
//   int _currentIndex = 0;
//
//   final List<Widget> _screens = const [
//     SinhVienListScreen(),
//     TodoScreen(),
//     SanPhamScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         selectedItemColor: Colors.blue,
//         onTap: (i) => setState(() => _currentIndex = i),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people),
//             label: 'Sinh Viên',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.checklist),
//             label: 'Todo',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.inventory),
//             label: 'Sản Phẩm',
//           ),
//         ],
//       ),
//     );
//   }
// }


//bai4//import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'provider/sinhvien_provider.dart';
// import 'provider/todo_provider.dart';
// import 'provider/sanpham_provider.dart';
// import 'provider/chitieu_provider.dart';
// import 'view/v_sinhvien.dart';
// import 'view/v_todo.dart';
// import 'view/v_sanpham.dart';
// import 'view/v_chitieu.dart';
//
// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => SinhVienProvider()),
//         ChangeNotifierProvider(create: (context) => TodoProvider()),
//         ChangeNotifierProvider(create: (context) => SanPhamProvider()),
//         ChangeNotifierProvider(create: (context) => ChiTieuProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       home: const MainNavScreen(),
//     );
//   }
// }
//
// class MainNavScreen extends StatefulWidget {
//   const MainNavScreen({super.key});
//
//   @override
//   State<MainNavScreen> createState() => _MainNavScreenState();
// }
//
// class _MainNavScreenState extends State<MainNavScreen> {
//   int _currentIndex = 0;
//
//   final List<Widget> _screens = [
//     const SinhVienListScreen(),
//     const TodoScreen(),
//     const SanPhamScreen(),
//     const ChiTieuScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         selectedItemColor: Colors.blue,
//         unselectedItemColor: Colors.grey,
//         type: BottomNavigationBarType.fixed,
//         onTap: (i) => setState(() => _currentIndex = i),
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.people),
//             label: 'Sinh Viên',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.checklist),
//             label: 'Todo',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.inventory),
//             label: 'Sản Phẩm',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.wallet),
//             label: 'Chi Tiêu',
//           ),
//         ],
//       ),
//     );
//   }
// }


//bai5//import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'provider/sinhvien_provider.dart';
// import 'provider/todo_provider.dart';
// import 'provider/sanpham_provider.dart';
// import 'provider/chitieu_provider.dart';
// import 'view/v_login.dart';
//
// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) => SinhVienProvider()),
//         ChangeNotifierProvider(create: (context) => TodoProvider()),
//         ChangeNotifierProvider(create: (context) => SanPhamProvider()),
//         ChangeNotifierProvider(create: (context) => ChiTieuProvider()),
//       ],
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter App',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       home: const LoginScreen(),
//     );
//   }
// }