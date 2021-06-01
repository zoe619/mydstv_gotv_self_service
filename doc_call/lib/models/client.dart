class Client
{

  int id;
  String names;
  String email;
  String phone;
  String age;
  String referer;
  String sex;
  String p_status;
  String amount;
  String date_added;

  Client({this.id, this.names, this.email, this.phone, this.age, this.referer,
    this.sex, this.p_status, this.amount,this.date_added});

  factory Client.fromJson(Map<String, dynamic> json)
  {
    return Client(
        id: json['id'] as int,
        names: json['names'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        age: json['age'] as String,
        referer: json['referer'] as String,
        sex: json['sex'] as String,
        p_status: json['p_status'] as String,
        amount: json['amount']as String,
        date_added: json['date_added'] as String
    );
  }

}