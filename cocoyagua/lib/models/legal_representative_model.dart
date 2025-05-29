class LegalRepresentative {
  String id;
  String fullName;
  String documentType;
  String documentNumber;
  String position;
  String? phone;
  String? email;

  LegalRepresentative({
    required this.id,
    required this.fullName,
    required this.documentType,
    required this.documentNumber,
    required this.position,
    this.phone,
    this.email,
  });

  LegalRepresentative copyWith({
    String? fullName,
    String? documentType,
    String? documentNumber,
    String? position,
    String? phone,
    String? email,
  }) {
    return LegalRepresentative(
      id: id,
      fullName: fullName ?? this.fullName,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
      position: position ?? this.position,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }
}
