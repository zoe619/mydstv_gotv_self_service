
class Doctor
{

  String name;
  String email;
  String phone;
  String type;
  String license;


  Doctor({this.name, this.email, this.phone, this.type, this.license});

  factory Doctor.fromJson(Map<String, dynamic> json)
  {
    return Doctor(

        name: json['names'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        type: json['type'] as String,
        license: json['license'] as String,



    );
  }

}