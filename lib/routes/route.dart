import 'package:bloomy/views/add_song_to_album/add_song_view.dart';
import 'package:bloomy/views/add_to_playlist/add_playlist_view.dart';
import 'package:bloomy/views/create_new/create_view.dart';
import 'package:bloomy/views/folder/folder_view.dart';
import 'package:bloomy/views/home/home_view.dart';
import 'package:bloomy/views/login/login_view.dart';
import 'package:bloomy/views/main/main_view.dart';
import 'package:bloomy/views/menu/menu_logic.dart';
import 'package:bloomy/views/menu/menu_view.dart';
import 'package:bloomy/views/music_local/music_view.dart';
import 'package:bloomy/views/playlist/playlist_view.dart';
import 'package:bloomy/views/queue/queue_view.dart';
import 'package:bloomy/views/signIn/singIn_view.dart';
import 'package:bloomy/views/song/song_view.dart';
import 'package:bloomy/views/stat/stat_view.dart';
import 'package:bloomy/views/welcome/welcome_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../views/splash/splash_view.dart';

class RoutePath {
  final String singlePath;
  final RoutePath? parent;

  String get path => parent != null
      ? '${parent != null ? parent!.path : ''}$singlePath'
      : singlePath;

  String get p => path;

  String get sp => singlePath;

  const RoutePath(this.singlePath, {this.parent});

  @override
  String toString() => path;
}

class SpecialRoute {
  final String route;
  final bool requiredSupportedChain;
  final bool requiredConnected;

  final bool? except;

  SpecialRoute(
    this.route, {
    //dùng bool để nó có thể truyền vô requiredSupport, bởi vì nó là final, không thể gán giá trị nhiều lần
    bool requiredSupportedChain = false,
    this.requiredConnected = false,
    this.except,
  }) : requiredSupportedChain = requiredConnected || requiredSupportedChain;
}

abstract class Routes {
  static const splash = RoutePath('/');
  static const home = RoutePath('/home');
  static const stat = RoutePath('/stat');
  static const folder = RoutePath('/folder');
  static const playlist = RoutePath('/playlist');
  static const song = RoutePath('/song');
  static const menu = RoutePath('/menu');
  static const addPlaylist = RoutePath('/addPlaylist');
  static const queue = RoutePath('/queue');
  static const create = RoutePath('/create');
  static const welcome = RoutePath('/welcome');
  static const signIn = RoutePath('/signIn');
  static const login = RoutePath('/login');
  static const main = RoutePath('/main');
  static const musicLocal = RoutePath('/musicLocal');
  static const addSong = RoutePath('/addSong');
}

final List<GetPage> getPages = [
  GetPage(
    name: Routes.splash.sp,
    page: () => SplashView(),
    binding: SplashBinding(),
  ),
  GetPage(
    name: Routes.home.sp,
    page: () => HomeView(),
    // binding: SplashBinding(),
  ),
  GetPage(
    name: Routes.stat.sp,
    page: () => StatView(),
    // binding: SplashBinding(),
  ),
  GetPage(
    name: Routes.folder.sp,
    page: () => FolderView(),
    binding: FolderBinding(),
  ),
  GetPage(
    name: Routes.playlist.sp,
    page: () => PlaylistView(),
    binding: PlaylistBinding(),
  ),
  GetPage(
    name: Routes.song.sp,
    page: () => SongView(),
    binding: SongBinding(),
  ),
  GetPage(
    name: Routes.menu.sp,
    page: () => MenuView(),
    binding: MenuBinding(),
  ),
  GetPage(
    name: Routes.addPlaylist.sp,
    page: () => AddPlaylistView(),
    binding: AddPlaylistBinding(),
  ),
  GetPage(
    name: Routes.queue.sp,
    page: () => QueueView(),
    binding: QueueBinding(),
  ),
  GetPage(
    name: Routes.create.sp,
    page: () => CreateView(),
    binding: CreateBinding(),
  ),
  GetPage(
    name: Routes.addSong.sp,
    page: () => AddSongView(),
    binding: AddSongBinding(),
  ),
  GetPage(
    name: Routes.welcome.sp,
    page: () => WelcomeView(),
    // binding: SplashBinding(),
  ),
  GetPage(
    name: Routes.signIn.sp,
    page: () => SignInView(),
    // binding: SplashBinding(),
  ),
  GetPage(
    name: Routes.login.sp,
    page: () => LoginView(),
    // binding: SplashBinding(),
  ),
  GetPage(
    name: Routes.main.sp,
    page: () => CustomNavigationBar(),
  ),
  GetPage(
    name: Routes.musicLocal.sp,
    page: () => OfflineMusicPlayer(),
  ),
].toList();
