import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulose/features/map/viewmodel/map_view_model.dart';
import 'package:velo_toulose/features/payment/viewmodel/pass_viewmode.dart';
import 'package:velo_toulose/main_common.dart';
import 'package:velo_toulose/repositories/abstract/pass_repository.dart';
import 'package:velo_toulose/repositories/local/pref_repository.dart';
import 'package:velo_toulose/repositories/mock/pass_repository_mock.dart';

List<InheritedProvider> get devProviders {
  final passRepository = PassRepositoryMock();

  return [
    // 1 - Inject repositories
    Provider<PassRepository>(create: (_) => passRepository),

    // 2 - Inject ViewModels
    ChangeNotifierProvider<MapViewModel>(create: (_) => MapViewModel()),
    ChangeNotifierProvider<PassViewModel>(create: (_) => PassViewModel(repository: passRepository)..fetchPasses(),),
    Provider<PreferencesRepository>(create: (_) => PreferencesRepository()),
  ];
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final prefRepo = PreferencesRepository();
  final onboardingDone = await prefRepo.isOnboardingDone();
  mainCommon(devProviders,onboardingDone: onboardingDone);
}
