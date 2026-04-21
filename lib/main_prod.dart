import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/features/auth/viewmodel/auth_view_model.dart';
import 'package:velo_toulose/features/booking/viewmodel/pass_viewmode.dart';
import 'package:velo_toulose/features/booking/viewmodel/user_pass_viewmodel.dart';
import 'package:velo_toulose/features/map/viewmodel/map_view_model.dart';
import 'package:velo_toulose/features/notification/viewmodel/notification_view_model.dart';
import 'package:velo_toulose/features/ride/viewmodel/ride_view_model.dart';
import 'package:velo_toulose/main_common.dart';
import 'package:velo_toulose/repositories/abstract/notification_repository.dart';
import 'package:velo_toulose/repositories/abstract/pass_repository.dart';
import 'package:velo_toulose/repositories/abstract/payment_repository.dart';
import 'package:velo_toulose/repositories/abstract/ride_repository.dart';
import 'package:velo_toulose/repositories/abstract/station_repostiory.dart';
import 'package:velo_toulose/repositories/abstract/user_repository.dart';
import 'package:velo_toulose/repositories/firesbase/notification_repository_firebase.dart';
import 'package:velo_toulose/repositories/firesbase/pass_repository_firebase.dart';
import 'package:velo_toulose/repositories/firesbase/payment_repository_firebase.dart';
import 'package:velo_toulose/repositories/firesbase/ride_repository_firebase.dart';
import 'package:velo_toulose/repositories/firesbase/station_repository_firebase.dart';
import 'package:velo_toulose/repositories/firesbase/user_repository_firebase.dart';
import 'package:velo_toulose/repositories/local/pref_repository.dart';
// TODO: uncomment after running `flutterfire configure`
// import 'firebase_options.dart';

List<InheritedProvider> get prodProviders {
  final StationRepostiory stationRepo = StationRepositoryFirebase();
  final UserRepository userRepository = UserRepositoryFirebase();
  final RideRepository rideRepository = RideRepositoryFirebase();
  final PassRepository passRepository = PassRepositoryFirebase();
  final NotificationRepository notifRepo = NotificationRepositoryFirebase();
  final PaymentRepository paymentRepo = PaymentRepositoryFirebase();

  return [
    // repositories
    Provider<PassRepository>(create: (_) => passRepository),
    Provider<StationRepostiory>(create: (_) => stationRepo),
    Provider<UserRepository>(create: (_) => userRepository),
    Provider<PreferencesRepository>(create: (_) => PreferencesRepository()),
    Provider<RideRepository>(create: (_) => rideRepository),
    Provider<NotificationRepository>(create: (_) => notifRepo),
    Provider<PaymentRepository>(create: (_) => paymentRepo),

    // Global State
    ChangeNotifierProvider<AuthViewModel>(
      create: (_) => AuthViewModel(userRepository),
    ),
    ChangeNotifierProvider<UserPassViewModel>(
      create: (context) => UserPassViewModel(
        repository: context.read<PassRepository>(),
        authViewModel: context.read<AuthViewModel>(),
      ),
    ),
    ChangeNotifierProvider<PassViewModel>(
      create: (_) => PassViewModel(passRepository: passRepository),
    ),
    ChangeNotifierProvider<MapViewModel>(
      create: (context) => MapViewModel(context.read<StationRepostiory>()),
    ),
    ChangeNotifierProvider<RideViewModel>(
      create: (context) =>
          RideViewModel(rideRepository, context.read<MapViewModel>()),
    ),
    ChangeNotifierProvider<NotificationViewModel>(
      create: (_) => NotificationViewModel(notifRepo),
    ),
  ];
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // TODO: uncomment after running `flutterfire configure`
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  

  // Point to your Realtime Database instance
  FirebaseDatabase.instance.databaseURL =
      'https://velotoulouse-382ac-default-rtdb.asia-southeast1.firebasedatabase.app';

  final prefRepo = PreferencesRepository();
  final onboardingDone = await prefRepo.isOnboardingDone();
  mainCommon(prodProviders, onboardingDone: onboardingDone);
}
