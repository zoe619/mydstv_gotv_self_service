class MobileCustomer
{

  String id;
  String names;
  String email;
  String phone;
  String password;
  String date;
  MobileCustomer({this.id, this.names, this.email, this.phone, this.password, this.date});

  factory MobileCustomer.fromJson(Map<String, dynamic> json)
  {
    return MobileCustomer(
        id: json['id'] as String,
        names: json['names'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        password: json['password'] as String,
        date: json['date_registered'] as String

    );
  }

}