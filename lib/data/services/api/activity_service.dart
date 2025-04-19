import '../../../utils/result.dart';
import '../../model/activity/activity_api_model.dart';
import '../api_client.dart';

class ActivityService {
  final ApiClient _apiClient;

  ActivityService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Result<List<ActivityApiModel>>> getActivities(String type) async {
    final path = "filter";
    final parameters = <String, dynamic>{"type": type};

    try {
      final response = await _apiClient.get<List<ActivityApiModel>>(
        path,
        queryParameters: parameters,
      );

      return Result.ok(response.data ?? []);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
