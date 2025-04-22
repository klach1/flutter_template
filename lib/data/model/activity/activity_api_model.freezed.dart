// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_api_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityApiModel {

// Based on the JSON example and previous context
 String get activity; double get availability; String get type; int get participants; double get price; String get accessibility; String get duration; bool get kidFriendly; String get link; String get key;
/// Create a copy of ActivityApiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ActivityApiModelCopyWith<ActivityApiModel> get copyWith => _$ActivityApiModelCopyWithImpl<ActivityApiModel>(this as ActivityApiModel, _$identity);

  /// Serializes this ActivityApiModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ActivityApiModel&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.availability, availability) || other.availability == availability)&&(identical(other.type, type) || other.type == type)&&(identical(other.participants, participants) || other.participants == participants)&&(identical(other.price, price) || other.price == price)&&(identical(other.accessibility, accessibility) || other.accessibility == accessibility)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.kidFriendly, kidFriendly) || other.kidFriendly == kidFriendly)&&(identical(other.link, link) || other.link == link)&&(identical(other.key, key) || other.key == key));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activity,availability,type,participants,price,accessibility,duration,kidFriendly,link,key);

@override
String toString() {
  return 'ActivityApiModel(activity: $activity, availability: $availability, type: $type, participants: $participants, price: $price, accessibility: $accessibility, duration: $duration, kidFriendly: $kidFriendly, link: $link, key: $key)';
}


}

/// @nodoc
abstract mixin class $ActivityApiModelCopyWith<$Res>  {
  factory $ActivityApiModelCopyWith(ActivityApiModel value, $Res Function(ActivityApiModel) _then) = _$ActivityApiModelCopyWithImpl;
@useResult
$Res call({
 String activity, double availability, String type, int participants, double price, String accessibility, String duration, bool kidFriendly, String link, String key
});




}
/// @nodoc
class _$ActivityApiModelCopyWithImpl<$Res>
    implements $ActivityApiModelCopyWith<$Res> {
  _$ActivityApiModelCopyWithImpl(this._self, this._then);

  final ActivityApiModel _self;
  final $Res Function(ActivityApiModel) _then;

/// Create a copy of ActivityApiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? activity = null,Object? availability = null,Object? type = null,Object? participants = null,Object? price = null,Object? accessibility = null,Object? duration = null,Object? kidFriendly = null,Object? link = null,Object? key = null,}) {
  return _then(_self.copyWith(
activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as String,availability: null == availability ? _self.availability : availability // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,accessibility: null == accessibility ? _self.accessibility : accessibility // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,kidFriendly: null == kidFriendly ? _self.kidFriendly : kidFriendly // ignore: cast_nullable_to_non_nullable
as bool,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ActivityApiModel implements ActivityApiModel {
  const _ActivityApiModel({required this.activity, required this.availability, required this.type, required this.participants, required this.price, required this.accessibility, required this.duration, required this.kidFriendly, required this.link, required this.key});
  factory _ActivityApiModel.fromJson(Map<String, dynamic> json) => _$ActivityApiModelFromJson(json);

// Based on the JSON example and previous context
@override final  String activity;
@override final  double availability;
@override final  String type;
@override final  int participants;
@override final  double price;
@override final  String accessibility;
@override final  String duration;
@override final  bool kidFriendly;
@override final  String link;
@override final  String key;

/// Create a copy of ActivityApiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ActivityApiModelCopyWith<_ActivityApiModel> get copyWith => __$ActivityApiModelCopyWithImpl<_ActivityApiModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ActivityApiModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ActivityApiModel&&(identical(other.activity, activity) || other.activity == activity)&&(identical(other.availability, availability) || other.availability == availability)&&(identical(other.type, type) || other.type == type)&&(identical(other.participants, participants) || other.participants == participants)&&(identical(other.price, price) || other.price == price)&&(identical(other.accessibility, accessibility) || other.accessibility == accessibility)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.kidFriendly, kidFriendly) || other.kidFriendly == kidFriendly)&&(identical(other.link, link) || other.link == link)&&(identical(other.key, key) || other.key == key));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,activity,availability,type,participants,price,accessibility,duration,kidFriendly,link,key);

@override
String toString() {
  return 'ActivityApiModel(activity: $activity, availability: $availability, type: $type, participants: $participants, price: $price, accessibility: $accessibility, duration: $duration, kidFriendly: $kidFriendly, link: $link, key: $key)';
}


}

/// @nodoc
abstract mixin class _$ActivityApiModelCopyWith<$Res> implements $ActivityApiModelCopyWith<$Res> {
  factory _$ActivityApiModelCopyWith(_ActivityApiModel value, $Res Function(_ActivityApiModel) _then) = __$ActivityApiModelCopyWithImpl;
@override @useResult
$Res call({
 String activity, double availability, String type, int participants, double price, String accessibility, String duration, bool kidFriendly, String link, String key
});




}
/// @nodoc
class __$ActivityApiModelCopyWithImpl<$Res>
    implements _$ActivityApiModelCopyWith<$Res> {
  __$ActivityApiModelCopyWithImpl(this._self, this._then);

  final _ActivityApiModel _self;
  final $Res Function(_ActivityApiModel) _then;

/// Create a copy of ActivityApiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? activity = null,Object? availability = null,Object? type = null,Object? participants = null,Object? price = null,Object? accessibility = null,Object? duration = null,Object? kidFriendly = null,Object? link = null,Object? key = null,}) {
  return _then(_ActivityApiModel(
activity: null == activity ? _self.activity : activity // ignore: cast_nullable_to_non_nullable
as String,availability: null == availability ? _self.availability : availability // ignore: cast_nullable_to_non_nullable
as double,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as int,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as double,accessibility: null == accessibility ? _self.accessibility : accessibility // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as String,kidFriendly: null == kidFriendly ? _self.kidFriendly : kidFriendly // ignore: cast_nullable_to_non_nullable
as bool,link: null == link ? _self.link : link // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
