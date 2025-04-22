// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:freezed_annotation/freezed_annotation.dart';
// Add this import

part 'activity_api_model.freezed.dart';
part 'activity_api_model.g.dart';

@freezed
abstract class ActivityApiModel with _$ActivityApiModel {
  const factory ActivityApiModel({
    // Based on the JSON example and previous context
    required String activity,
    required double availability,
    required String type,
    required int participants,
    required double price,
    required String accessibility,
    required String duration,
    required bool kidFriendly,
    required String link,
    required String key,
  }) = _ActivityApiModel;

  factory ActivityApiModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityApiModelFromJson(json);
}
