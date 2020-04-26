class Transactions
{

  String id;
  String transaction_id;
  String customer_id;
  String email;
  String amount;
  String period;
  String type;
  String status;

  Transactions({this.id, this.transaction_id, this.customer_id, this.email, this.amount, this.period, this.type, this.status});


  factory Transactions.fromJson(Map<String, dynamic> json)
  {
    return Transactions(
        id: json['id'] as String,
        transaction_id: json['transaction_id'] as String,
        customer_id: json['customer_id'] as String,
        email: json['email'] as String,
        amount: json['amount'] as String,
        period: json['period'] as String,
        type: json['type'] as String,
        status: json['status'] as String


    );
  }

}