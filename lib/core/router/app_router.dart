import 'package:go_router/go_router.dart';

import 'package:bayan/features/root_family/root_family_screen.dart';
import 'package:bayan/features/search/search_screen.dart';
import 'package:bayan/features/settings/settings_screen.dart';

/// Named route identifiers — use these constants everywhere to avoid typos.
abstract final class Routes {
  static const search = '/';
  static const rootFamily = '/root/:rootId';
  static const settings = '/settings';
}

final appRouter = GoRouter(
  initialLocation: Routes.search,
  routes: [
    GoRoute(
      path: Routes.search,
      name: 'search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: Routes.rootFamily,
      name: 'rootFamily',
      builder: (context, state) {
        final rootId = int.tryParse(state.pathParameters['rootId'] ?? '') ?? 0;
        return RootFamilyScreen(rootId: rootId);
      },
    ),
    GoRoute(
      path: Routes.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
