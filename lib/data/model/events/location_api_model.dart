class LocationApiModel {
  final String address;
  final double latitude;
  final double longitude;

  LocationApiModel({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory LocationApiModel.fromJson(Map<String, dynamic> json) {
    return LocationApiModel(
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
