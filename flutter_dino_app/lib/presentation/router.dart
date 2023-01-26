import 'package:flutter/material.dart';
import 'package:flutter_dino_app/domain/models/seed.dart';
import 'package:flutter_dino_app/presentation/forest_screen/forest_screen_widget.dart';
import 'package:flutter_dino_app/presentation/friends_screen/friends_screen_widget.dart';
import 'package:flutter_dino_app/presentation/growing_screen/growing_grow_screen_widget.dart';
import 'package:flutter_dino_app/presentation/growing_screen/growing_screen_widget.dart';
import 'package:flutter_dino_app/presentation/seeds_screen/seed_details_screen_widget.dart';
import 'package:flutter_dino_app/presentation/seeds_screen/seeds_screen_widget.dart';
import 'package:flutter_dino_app/presentation/settings_screen/settings_screen_widget.dart';
import 'package:flutter_dino_app/presentation/shop_screen/shop_screen_widget.dart';
import 'package:flutter_dino_app/presentation/theme/theme.dart';
import 'package:flutter_dino_app/presentation/widgets/navigation_drawer.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: RouteNames.growing,
  routes: [
    GoRoute(
      path: RouteNames.forest,
      builder: (context, state) =>
          _scaffoldedWidget("Forêt", const ForestScreenWidget()),
    ),
    GoRoute(
      path: RouteNames.friends,
      builder: (context, state) =>
          _scaffoldedWidget("Amis", const FriendsScreenWidget()),
    ),
    GoRoute(
      path: RouteNames.growing,
      builder: (context, state) =>
          _scaffoldedWidget("Garden Pomodoro", const GrowingScreenWidget()),
    ),
    GoRoute(
      path: RouteNames.growingGrow,
      builder: (context, state) => GrowingGrowScreenWidget(
        seed: state.extra as Seed,
      ),
    ),
    GoRoute(
      path: RouteNames.seeds,
      builder: (context, state) =>
          _scaffoldedWidget("Graines", const SeedsScreenWidget()),
    ),
    GoRoute(
      path: RouteNames.seedDetails,
      builder: (context, state) => _scaffoldedWidget(
          "Graines",
          SeedDetailsScreenWidget(
            seed: state.extra as Seed,
          )),
    ),
    GoRoute(
      path: RouteNames.settings,
      builder: (context, state) =>
          _scaffoldedWidget("Paramètres", const SettingsScreenWidget()),
    ),
    GoRoute(
      path: RouteNames.shop,
      builder: (context, state) =>
          _scaffoldedWidget("Boutique", const ShopScreenWidget()),
    ),
  ],
  redirect: (context, state) {
    debugPrint("Going to ${state.location}");
    return null;
  },
);

Widget _scaffoldedWidget(String title, Widget widget) {
  return Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: Text(title),
    ),
    backgroundColor: PomodoroTheme.background,
    drawer: const NavigationDrawerWidget(),
    body: Container(
      padding: const EdgeInsets.all(10),
      child: widget,
    ),
  );
}

abstract class RouteNames {
  static const String root = '/';
  static const String forest = '/forest';
  static const String friends = '/friends';
  static const String growing = '/growing';
  static const String growingGrow = '/growing/grow';
  static const String seeds = '/seeds';
  static const String seedDetails = '/seeds/view';
  static const String settings = '/settings';
  static const String shop = '/shop';
}
