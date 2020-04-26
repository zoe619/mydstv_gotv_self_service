class Channels{
  int id;
  String brand;
  String package;
  String channel;
  String channel_number;

  Channels({this.id, this.brand, this.package, this.channel, this.channel_number});

  factory Channels.fromJson(Map<String, dynamic> json)
  {

    return Channels(
        id: json['id'] as int,
        brand: json['brand'] as String,
        package: json['package'] as String,
        channel: json['channel'] as String,
        channel_number: json['channel_number'] as String
      );
  }
}