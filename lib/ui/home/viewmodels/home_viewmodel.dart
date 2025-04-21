import 'package:flutter/material.dart';

import '../../../data/repositories/activity_repository.dart';
import '../../../domain/exceptions/dividable_exception.dart';
import '../../../domain/models/activity/activity.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

class HomeViewmodel extends ChangeNotifier {
  final ActivityRepository _activityRepository;

  List<Activity> _activities = [];
  List<Activity> get activities => _activities;

  int counter = 0;

  late final Command1<void, String> loadActivities;
  late final Command0<int> incrementCounter;

  HomeViewmodel({required ActivityRepository activityRepository})
    : _activityRepository = activityRepository {
    loadActivities = Command1(_load);
    incrementCounter = Command0(_incrementCounter);
  }

  Future<Result<int>> _incrementCounter() async {
    try {
      await Future.delayed(Duration(seconds: 2));

      counter++;

      if (counter % 2 == 0) {
        return Result.ok(counter);
      } else {
        return Result.error(
          DividableException('Number is not dividable by two'),
        );
      }
    } on Exception catch (e) {
      return Result.error(e);
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _load(String type) async {
    final activitiesResult = await _activityRepository.getActivities(type);
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
