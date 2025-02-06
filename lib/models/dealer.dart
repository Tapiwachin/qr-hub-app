class Dealer {
  final String id;
  final String name;
  final String? location;
  final String? address;
  final String? contactNumber;
  final String? email;
  final String? servicesOffered;
  final bool? isToyotaDealer;
  final bool? thirdPartyAap;
  final double? latitude;
  final double? longitude;

  Dealer({
    required this.id,
    required this.name,
    this.location,
    this.address,
    this.contactNumber,
    this.email,
    this.servicesOffered,
    this.isToyotaDealer,
    this.thirdPartyAap,
    this.latitude,
    this.longitude,
  });

  factory Dealer.fromJson(Map<String, dynamic> json) {
    return Dealer(
      id: json['id'].toString(), // Always convert ID to string
      name: json['name'] ?? '', // Provide a default empty string if null
      location: json['location'] as String?, // Cast explicitly to String?
      address: json['address'] as String?,
      contactNumber: json['contact_number'] as String?,
      email: json['email'] as String?,
      servicesOffered: json['services_offered'] as String?,
      isToyotaDealer: json['is_toyota_dealer'] as bool?,
      thirdPartyAap: json['third_party_aap'] as bool?,
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString()) // Safely parse to double
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString()) // Safely parse to double
          : null,
    );
  }
}
