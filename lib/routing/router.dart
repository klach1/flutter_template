import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ui/home/viewmodels/home_viewmodel.dart';
import '../ui/home/widgets/home_page.dart';
import '../ui/user/viewmodel/user_viewmodel.dart';
import '../ui/user/widget/user_page.dart';
import 'routes.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Return the widget that has the navigation shell and the bottom navigation bar
        return ScaffoldWithBottomNavBar(navigationShell: navigationShell);
      },
      branches: [
        // Home branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.home,
              builder: (context, state) {
                return MyHomePage(
                  viewmodel: HomeViewmodel(activityRepository: context.read()),
                );
              },
              // Add any nested routes for Home here if needed
              routes: [
                // Example: GoRoute(path: 'details/:id', builder: ...)
              ],
            ),
          ],
        ),
        // User branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.user,
              builder: (context, state) {
                return UserPage(
                  viewmodel: UserViewmodel(username: 'Kryštof Lach'),
                );
              },
              // Add any nested routes for User here if needed
              routes: [
                // Example: GoRoute(path: 'settings', builder: ...)
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

// Widget that contains the navigation shell and the bottom navigation bar
class ScaffoldWithBottomNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithBottomNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          // Navigate to the tab at the specified index
          navigationShell.goBranch(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'User'),
        ],
      ),
    );
  }
}
