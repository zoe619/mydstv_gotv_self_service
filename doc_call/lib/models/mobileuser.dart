class MobileUser
{

  String id;
  String names;
  String email;
  String phone;
  String password;
  String date;
  MobileUser({this.id, this.names, this.email, this.phone, this.password, this.date});

  factory MobileUser.fromJson(Map<String, dynamic> json)
  {
    return MobileUser(
        id: json['id'] as String,
        names: json['names'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        password: json['password'] as String,
        date: json['date_registered'] as String

    );
  }

}