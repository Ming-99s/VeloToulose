import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/features/auth/viewmodel/auth_view_model.dart';
import 'package:velo_toulose/features/booking/viewmodel/user_pass_viewmodel.dart';
import 'package:velo_toulose/features/map/viewmodel/map_view_model.dart';
import 'package:velo_toulose/features/booking/viewmodel/pass_viewmode.dart';
import 'package:velo_toulose/features/ride/viewmodel/ride_view_model.dart';
import 'package:velo_toulose/features/notification/viewmodel/notification_view_model.dart';
import 'package:velo_toulose/main_common.dart';
import 'package:velo_toulose/repositories/abstract/notification_repository.dart';
import 'package:velo_toulose/repositories/abstract/pass_repository.dart';
import 'package:velo_toulose/repositories/abstract/payment_repository.dart';
import 'package:velo_toulose/repositories/abstract/ride_repository.dart';
import 'package:velo_toulose/repositories/abstract/station_repostiory.dart';
import 'package:velo_toulose/repositories/abstract/user_repository.dart';
import 'package:velo_toulose/repositories/local/pref_repository.dart';
import 'package:velo_toulose/repositories/mock/notification_repository_mock.dart';
import 'package:velo_toulose/repositories/mock/pass_repository_mock.dart';
import 'package:velo_toulose/repositories/mock/payment_repository_mock.dart';
import 'package:velo_toulose/repositories/mock/ride_repository_mock.dart';
import 'package:velo_toulose/repositories/mock/station_repository_mock.dart';
import 'package:velo_toulose/repositories/mock/user_repository_mock.dart';

List<InheritedProvider> devProviders(UserRepository userRepository) {
  final stationRepo = StationRepositoryMock();
  final rideRepository = RideRepositoryMock(stationRepo);
  final passRepository = PassRepositoryMock();
  final notifRepo = NotificationRepositoryMock();
  final paymentRepo = PaymentRepositoryMock();

  final notifViewModel = NotificationViewModel(notifRepo);

  // create without authViewModel first
  final userPassViewModel = UserPassViewModel(repository: passRepository);

  final authViewModel = AuthViewModel(
    userRepository,
    userPassViewModel: userPassViewModel,
    notificationViewModel: notifViewModel,
  );

  // break the cycle after both are created
  userPassViewModel.setAuthViewModel(authViewModel); 

  return [
    Provider<PassRepository>(create: (_) => passRepository),
    Provider<StationRepostiory>(create: (_) => stationRepo),
    Provider<UserRepository>(create: (_) => userRepository),
    Provider<PreferencesRepository>(create: (_) => PreferencesRepository()),
    Provider<RideRepository>(create: (_) => rideRepository),
    Provider<NotificationRepository>(create: (_) => notifRepo),
    Provider<PaymentRepository>(create: (_) => paymentRepo),
    ChangeNotifierProvider<AuthViewModel>.value(value: authViewModel),
    ChangeNotifierProvider<UserPassViewModel>.value(value: userPassViewModel),
    ChangeNotifierProvider<PassViewModel>(
      create: (_) => PassViewModel(
        passRepository: passRepository,
        authViewModel: authViewModel,
      ),
    ),
    ChangeNotifierProvider<MapViewModel>(
      create: (_) => MapViewModel(stationRepo),
    ),
    ChangeNotifierProvider<RideViewModel>(
      create: (_) => RideViewModel(rideRepository, MapViewModel(stationRepo)),
    ),
    ChangeNotifierProvider<NotificationViewModel>.value(value: notifViewModel),
  ];
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('users_box');
  await Hive.openBox('user_passes_box');

  final userRepository = UserRepositoryMock();
  final prefRepo = PreferencesRepository();
  final onboardingDone = await prefRepo.isOnboardingDone();

  mainCommon(
    devProviders(userRepository),
    onboardingDone: onboardingDone,
  ); 
}
