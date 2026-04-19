import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/features/auth/viewmodel/auth_view_model.dart';
import 'package:velo_toulose/features/map/viewmodel/map_view_model.dart';
import 'package:velo_toulose/features/booking/viewmodel/pass_viewmode.dart';
import 'package:velo_toulose/features/ride/viewmodel/ride_view_model.dart';
import 'package:velo_toulose/features/notification/viewmodel/notification_view_model.dart';
import 'package:velo_toulose/main_common.dart';
import 'package:velo_toulose/repositories/abstract/pass_repository.dart';
import 'package:velo_toulose/repositories/abstract/ride_repository.dart';
import 'package:velo_toulose/repositories/abstract/station_repostiory.dart';
import 'package:velo_toulose/repositories/abstract/user_repository.dart';
import 'package:velo_toulose/repositories/local/pref_repository.dart';
import 'package:velo_toulose/repositories/mock/ride_repository_mock.dart';
import 'package:velo_toulose/repositories/mock/station_repository_mock.dart';
import 'package:velo_toulose/repositories/mock/user_repository_mock.dart';

List<InheritedProvider> get devProviders {
  final StationRepostiory stationRepo = StationRepositoryMock();
  final UserRepository userRepository = UserRepositoryMock();
  final RideRepository rideRepository = RideRepositoryMock();

  return [
    // repositories
    Provider<StationRepostiory>(create: (_) => stationRepo),
    Provider<UserRepository>(create: (_) => userRepository),
    Provider<PreferencesRepository>(create: (_) => PreferencesRepository()),
    Provider<RideRepository>(create: (_) => rideRepository),

    // Gobal State
    ChangeNotifierProvider<AuthViewModel>(
      create: (_) => AuthViewModel(userRepository),
    ),

    ChangeNotifierProvider<MapViewModel>(
      create: (context) => MapViewModel(context.read<StationRepostiory>()),
    ),
    ChangeNotifierProvider<RideViewModel>(
      create: (_) => RideViewModel(rideRepository),
    ),
    ChangeNotifierProvider<NotificationViewModel>(
      create: (_) => NotificationViewModel(),
    ),
  ];
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefRepo = PreferencesRepository();
  final onboardingDone = await prefRepo.isOnboardingDone();
  mainCommon(devProviders, onboardingDone: onboardingDone);
}
