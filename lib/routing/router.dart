import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ui/home/viewmodels/home_viewmodel.dart';
import '../ui/home/widgets/home_page.dart';
import 'routes.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return MyHomePage(
          viewmodel: HomeViewmodel(activityRepository: context.read()),
        );
      },
    ),
  ],
);
