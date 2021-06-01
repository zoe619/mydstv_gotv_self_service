class History
{

  String id;
  String code;
  String request_date;
  String expired_date;
  String duration;
  String destination;
  String reason;
  String persons;
  String type;
  String status;


  History({this.id, this.code, this.request_date, this.expired_date, this.duration, this.destination, this.reason, this.persons, this.type, this.status});


  factory History.fromJson(Map<String, dynamic> json)
  {
    return History(
        id: json['id'] as String,
        code: json['code'] as String,
        request_date: json['request_date'] as String,
        expired_date: json['expired_date'] as String,
        duration: json['duration'] as String,
        destination: json['destination'] as String,
        reason: json['reason'] as String,
        persons: json['persons'] as String,
        type: json['type'] as String,
        status: json['status'] as String
    );
  }

}