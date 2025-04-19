import 'package:flutter/material.dart';

import '../../../data/repositories/activity_repository.dart';
import '../../../domain/models/activity/activity.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class HomeViewmodel extends ChangeNotifier {
  final ActivityRepository _activityRepository;

  List<Activity> _activities = [];
  List<Activity> get activities => _activities;

  late final Command1<void, String> loadActivities;

  HomeViewmodel({required ActivityRepository activityRepository})
    : _activityRepository = activityRepository {
    loadActivities = Command1(_load);
  }

  Future<Result<void>> _load(String type) async {
    var activitiesResult = await _activityRepository.getActivities(type);
    switch (activitiesResult) {
      case Ok<List<Activity>>():
        _activities = activitiesResult.value;
        notifyListeners();
      case Error<List<Activity>>():
      //TODO show toast
    }

    return activitiesResult;
  }
}
