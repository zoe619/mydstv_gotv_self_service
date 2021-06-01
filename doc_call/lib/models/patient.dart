class Patient
{


  String prescription;
  String prescription_date;
  String picture;
  String name;
  String email;
  String phone;
  String code;


  Patient({
    this.prescription,
    this.prescription_date,
    this.picture,
    this.name,
    this.email,
    this.phone,
    this.code

  });

  factory Patient.fromJson(Map<String, dynamic> json)
  {
    return Patient(
        prescription: json['prescription'] as String,
        prescription_date: json['prescription_date'] as String,
        picture: json['picture'] as String,
        name: json['names'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        code: json['code'] as String
    );
  }
}