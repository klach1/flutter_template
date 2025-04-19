import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../data/services/api/activity_service.dart';
import '../data/services/api_client.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(create: (context) => ApiClient()),
    Provider(create: (context) => ActivityService(apiClient: context.read())),
  ];
}
