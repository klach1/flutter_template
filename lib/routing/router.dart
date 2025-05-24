import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../ui/events/pages/events_list_page.dart';
import '../ui/events/pages/event_detail_page.dart';
import '../ui/events/viewmodels/event_detail_viewmodel.dart';
import 'routes.dart';

GoRouter createRouter() {
  return GoRouter(
    initialLocation: Routes.events,
    routes: [
      GoRoute(
        path: Routes.events,
        builder: (context, state) {
          return const EventsListPage();
        },
        routes: [
          GoRoute(
            path: ':eventId',
            builder: (context, state) {
              final eventId = state.pathParameters['eventId']!;
              return ChangeNotifierProvider(
                create:
                    (context) => EventDetailViewModel(
                      repository: context.read(),
                      eventId: eventId,
                    ),
                child: EventDetailPage(eventId: eventId),
              );
            },
          ),
        ],
      ),
    ],
  );
}
