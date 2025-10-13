class Agent {
  final String? id;
  final String firstname;
  final String middlename;
  final String lastname;
  final String dob;
  final String nationality;
  final String identification;
  final String phonenumber;
  final String email;
  final String statusId;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Agent({
    this.id,
    required this.firstname,
    required this.middlename,
    required this.lastname,
    required this.dob,
    required this.nationality,
    required this.identification,
    required this.phonenumber,
    required this.email,
    required this.statusId,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'firstname': firstname,
      'middlename': middlename,
      'lastname': lastname,
      'dob': dob,
      'nationality': nationality,
      'identification': identification,
      'phonenumber': phonenumber,
      'email': email,
      'statusId': statusId,
      'createdBy': createdBy,
    };
  }

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'],
      firstname: json['firstname'] ?? '',
      middlename: json['middlename'] ?? '',
      lastname: json['lastname'] ?? '',
      dob: json['dob'] ?? '',
      nationality: json['nationality'] ?? '',
      identification: json['identification'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      email: json['email'] ?? '',
      statusId: json['statusId'] ?? 'b8641bcd-07d5-4919-b459-5a081dee449b',
      createdBy: json['createdBy'] ?? 'admin',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}