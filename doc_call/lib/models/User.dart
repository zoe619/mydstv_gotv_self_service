
class User
{

  String id;
  String name;
  String email;
  String phone;
  String type;
  String license;
  String company;
  String address;
  String code;
  String imageUrl;
  String account;
  String bank;
  String sex;
  String plan;
  String agent_email;

  User({this.id, this.name, this.email, this.phone, this.type, this.license, this.company,
    this.address,this.code, this.imageUrl, this.account, this.bank, this.plan, this.sex, this.agent_email});

  factory User.fromJson(Map<String, dynamic> json)
  {
    return User(

      name: json['names'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      type: json['type'] as String,
      license: json['license'] as String,
      company: json['company'] as String,
      address: json['address'] as String,
      code: json['code'] as String,
      imageUrl: json['picture'] as String,
      account: json['account'] as String,
      bank: json['bank'] as String,
      sex: json['sex'] as String,
      plan: json['plan'] as String,
      agent_email: json['agent_email']as String


    );
  }

}