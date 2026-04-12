import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/widgets/navbar.dart';
import 'package:velo_toulose/features/map/view/map_screen.dart';
import 'package:velo_toulose/features/profile/view/profile_screen.dart';

void mainCommon(List<InheritedProvider> providers) {
  runApp(
    // MultiProvider(
    //   providers: providers,
    //   child: MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()),
    // ),
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'PlusJakartaSans'),
      home: MyApp(),
  )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _page = [MapScreen(), ProfileScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.background,
        body: 
        Stack(
          children: [
            _page[_selectedIndex],  
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Navbar(selectedIndex: _selectedIndex, onItemTapped: _onItemTapped))
          ],
        )

        
        
      
    );
  }


}
