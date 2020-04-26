class Package
{

  String package;


  Package({this.package});

  factory Package.fromJson(Map<String, dynamic> json)
  {
    return Package(
        package: json['package'] as String

    );
  }
}