
class Billing{
  int id;
  String title;
  String customerAcct;
  String previousRead;
  String currentRead;
  String readMonth;
  String readYear;
  String picture;

  Billing({
    this.title,
    this.customerAcct,
    this.previousRead,
    this.currentRead,
    this.readMonth,
    this.readYear,
    this.picture
  });

//  Named constructor
  Billing.withId({
    this.id,
    this.title,
    this.customerAcct,
    this.previousRead,
    this.currentRead,
    this.readMonth,
    this.readYear,
    this.picture
  });

//  function to store the crime as a map into the database
  Map<String, dynamic>toMap(){

    final map = Map <String, dynamic>();
    if(id != null)
    {
      map['id'] = id;
    }

    map['title'] = title;
    map['account'] = customerAcct;
    map['previous'] = previousRead;
    map['current'] = currentRead;
    map['month'] = readMonth;
    map['year'] = readYear;
    map['picture'] = picture;
    return map;

  }

//  function to read crime from database and convert it to a Crime object

  factory Billing.fromMap(Map<String, dynamic> map){
    return Billing.withId(
        id: map['id'],
        title: map['title'],
        customerAcct: map['account'],
        previousRead: map['previous'],
        currentRead: map['current'],
        readMonth: map['month'],
        readYear: map['year'],
        picture: map['picture']
    );
  }
}