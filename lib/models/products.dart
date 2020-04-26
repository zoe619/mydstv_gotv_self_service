
class Products
{
  final String pid;
  final String name;
  final String plus;
  final String brief;
  final String detail;
  final String price;
  final String brand;
  final String pic;
  final String category;
  final String mprice;
  final String condi;
  final String discount;
  final String install;
  final String promo;
  final String swop;
  final String upgrade;
  final String bouq;
  final String maint;
  final String cprice;
  final String branded;

  Products({this.pid, this.name, this.plus, this.brief, this.detail, this.price, this.brand, this.pic,
    this.category, this.mprice, this.condi, this.discount, this.install, this.promo, this.swop, this.upgrade, this.bouq, this.maint, this.cprice, this.branded

  });


  factory Products.fromJson(Map<String, dynamic> json)
  {
    return Products(
        pid: json['pid'] as String,
        name: json['name'] as String,
        plus: json['plus'] as String,
        detail: json['detail'] as String,
        price: json['price'] as String,
        brand: json['brand'] as String,
        pic: json['pic'] as String,
        category: json['category'] as String,
        mprice: json['mprice'] as String,
        condi: json['condi'] as String,
        discount: json['discount'] as String,
        install: json['instal'] as String,
        promo: json['promo'] as String,
        swop: json['swop'] as String,
        upgrade: json['upgrade'] as String,
        bouq: json['bouq'] as String,
        maint: json['maint'] as String,
        cprice: json['cprice'] as String,
        branded: json['branded'] as String,
        brief: json['brief'] as String,


    );
  }

}