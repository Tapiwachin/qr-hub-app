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
  });

  factory Dealer.fromJson(Map<String, dynamic> json) {
    return Dealer(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      location: json['location'],
      address: json['address'],
      contactNumber: json['contact_number'],
      email: json['email'],
      servicesOffered: json['services_offered'],
      isToyotaDealer: json['is_toyota_dealer'],
      thirdPartyAap: json['third_party_aap'],
    );
  }
}
