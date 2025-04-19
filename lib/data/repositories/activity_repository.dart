import '../../domain/models/activity/activity.dart';
import '../../utils/result.dart';
import '../model/activity/activity_api_model.dart';
import '../services/api/activity_service.dart';

class ActivityRepository {
  final ActivityService _activityService;

  ActivityRepository({required ActivityService activityService})
    : _activityService = activityService;

  Future<Result<List<Activity>>> getActivities(String type) async {
    try {
      final activitiesResult = await _activityService.getActivities(type);

      switch (activitiesResult) {
        case Ok<List<ActivityApiModel>>():
          final activities = activitiesResult.value;

          return Result.ok(
            activities
                .map(
                  (activity) => Activity(
                    activity.activity,
                    activity.availability,
                    activity.participants,
                    activity.price,
                    activity.accessibility,
                    activity.duration,
                    activity.kidFriendly,
                    activity.link,
                    activity.key,
                  ),
                )
                .toList(),
          );
        case Error<List<ActivityApiModel>>():
          return Result.error(activitiesResult.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
