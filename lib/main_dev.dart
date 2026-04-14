import 'package:provider/provider.dart';
import 'package:velo_toulose/features/map/viewmodel/map_view_model.dart';
import 'package:velo_toulose/main_common.dart';
import 'package:velo_toulose/repositories/local/pref_repository.dart';

List<InheritedProvider> get devProviders {
  // final appSettingsRepository = AppSettingsRepositoryMock();
  // final songRepository = SongRepositoryFirebase();
  return [
    // // 1 - Inject repositories
    // Provider<SongRepository>(create: (_) => songRepository),
    // Provider<ArtistRepository>(create: (_) => ArtistRepositoryFirebase(
    //     songRepository: songRepository,
    //   )),

    // // 2 - Inject the player state
    // ChangeNotifierProvider<PlayerState>(create: (_) => PlayerState()),

    // // 3 - Inject the  app setting state
    // ChangeNotifierProvider<AppSettingsState>(
    //   create: (_) => AppSettingsState(repository: appSettingsRepository),

    ChangeNotifierProvider<MapViewModel>(create: (_) => MapViewModel()),
    Provider<PreferencesRepository>(create: (_) => PreferencesRepository()),


  ];
}

void main() {
  mainCommon(devProviders);
}
