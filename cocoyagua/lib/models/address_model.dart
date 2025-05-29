class Address {
  String id;
  String country;
  String department;
  String province;
  String district;
  String streetAddress;
  String? reference;
  bool isPrimary;

  Address({
    required this.id,
    required this.country,
    required this.department,
    required this.province,
    required this.district,
    required this.streetAddress,
    this.reference,
    this.isPrimary = false,
  });

  Address copyWith({
    bool? isPrimary,
  }) {
    return Address(
        id: id,
        country: country,
        department: department,
        province: province,
        district: district,
        streetAddress: streetAddress,
        reference: reference,
        isPrimary: isPrimary ?? this.isPrimary);
  }
}
