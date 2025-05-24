class Location {
  final String address;
  final double latitude;
  final double longitude;

  const Location({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          runtimeType == other.runtimeType &&
          address == other.address &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  int get hashCode => address.hashCode ^ latitude.hashCode ^ longitude.hashCode;

  @override
  String toString() => 'Location(address: $address, lat: $latitude, lng: $longitude)';
}
