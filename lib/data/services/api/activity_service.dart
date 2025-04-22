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
      final response = await _apiClient.get<List<dynamic>>(
        path,
        queryParameters: parameters,
      );

      // Map the response data to a list of ActivityApiModel objects
      final List<dynamic> responseData = response.data ?? [];
      final activities =
          responseData
              .map(
                (json) =>
                    ActivityApiModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();

      return Result.ok(activities);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
