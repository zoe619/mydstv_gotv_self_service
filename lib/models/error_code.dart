
class ErrorCode
{

  String id;
  String code;

  ErrorCode({this.id, this.code});

  factory ErrorCode.fromJson(Map<String, dynamic> json){
    return ErrorCode(
      id: json['id'] as String,
      code: json['code'] as String
    );
  }

}