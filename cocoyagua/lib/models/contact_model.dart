class Contact {
  String id;
  String name;
  String relationship;
  String? type;
  String? phone;
  String? email;
  String? description;
  bool isEmergencyContact;

  Contact({
    required this.id,
    required this.name,
    required this.relationship,
    this.type,
    this.phone,
    this.email,
    this.description,
    this.isEmergencyContact = false,
  });

  Contact copyWith({
    String? id,
    String? name,
    String? relationship,
    String? phone,
    String? email,
    bool? isEmergencyContact,
    String? type,
    String? description,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      type: type ?? this.type,
      description: description ?? this.description,
      isEmergencyContact: isEmergencyContact ?? this.isEmergencyContact,
    );
  }
}
