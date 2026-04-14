import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/core/constant/app_color.dart';
import 'package:velo_toulose/core/widgets/navbar.dart';
import 'package:velo_toulose/features/map/map_screen.dart';
import 'package:velo_toulose/features/map/viewmodel/map_view_model.dart';
import 'package:velo_toulose/features/map/widgets/bottom_sheet_widget.dart';
import 'package:velo_toulose/features/onBoarding/view/on-boarding_screen.dart';
import 'package:velo_toulose/features/profile/profile_screen.dart';
import 'package:velo_toulose/features/splash/view/splash_screen.dart';

void mainCommon(List<InheritedProvider> providers,{required bool onboardingDone}) {

  runApp(
    MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false, 
        theme: ThemeData(fontFamily: 'PlusJakartaSans'),
        home: onboardingDone ? 
        SplashScreen(nextScreen: MyApp(),):
        SplashScreen(nextScreen: OnBoardingScreen())
        ),
    ),
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
    final viewModel = context.watch<MapViewModel>();

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.background,
        body: 
        Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: _page,
            ),

         if (viewModel.selectedStation != null)
            Positioned.fill(
              child: Visibility(
                visible: _selectedIndex == 0,
                maintainState: true,
                child: DraggableScrollableSheet(
                  initialChildSize: 0.4,
                  minChildSize: 0.0,
                  maxChildSize: 0.8,
                  snap: true,
                  snapSizes: const [0.0, 0.4, 0.8],
                  builder: (context, scrollController) {
                    return NotificationListener<
                      DraggableScrollableNotification
                    >(
                      onNotification: (notification) {
                        if (notification.extent < 0.05) {
                          viewModel.clearSelectedStation();
                        }
                        return true;
                      },
                      child: BottomSheetWidget(
                        station: viewModel.selectedStation!,
                        viewModel: viewModel,
                        scrollController: scrollController,
                      ),
                    );
                  },
                ),
              ),
            ),
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
