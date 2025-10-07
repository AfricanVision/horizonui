class UserRegistration {
  String firstname;
  String middlename;
  String lastname;
  String dob;
  String nationality;
  String identification;
  String phonenumber;
  String email;
  String statusId;
  String createdBy;

  UserRegistration({
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
  });

  Map<String, dynamic> toJson() {
    return {
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

  factory UserRegistration.fromJson(Map<String, dynamic> json) {
    return UserRegistration(
      firstname: json['firstname'] ?? '',
      middlename: json['middlename'] ?? '',
      lastname: json['lastname'] ?? '',
      dob: json['dob'] ?? '',
      nationality: json['nationality'] ?? '',
      identification: json['identification'] ?? '',
      phonenumber: json['phonenumber'] ?? '',
      email: json['email'] ?? '',
      statusId: json['statusId'] ?? '',
      createdBy: json['createdBy'] ?? '',
    );
  }
}