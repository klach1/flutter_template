import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'config/dependencies.dart';
import 'routing/routes.dart';
import 'ui/events/pages/event_detail_page.dart';
import 'ui/events/pages/events_list_page.dart';
import 'ui/events/viewmodels/event_detail_viewmodel.dart';

void main() {
  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

final GoRouter _router = GoRouter(
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
              create: (context) => EventDetailViewModel(
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
