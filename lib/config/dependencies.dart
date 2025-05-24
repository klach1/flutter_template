import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../data/repositories/events_repository.dart';
import '../data/services/api/events_service.dart';
import '../data/services/api_client.dart';
import '../ui/events/viewmodels/events_viewmodel.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => ApiClient()),
    Provider(create: (context) => EventsService(apiClient: context.read())),
    Provider(
      create: (context) => EventsRepository(service: context.read()),
    ),
    ChangeNotifierProvider(
      create: (context) => EventsViewModel(repository: context.read()),
    ),
  ];
}
