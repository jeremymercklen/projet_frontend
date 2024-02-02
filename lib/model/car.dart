class Car {
  late var make;
  late var model;
  late var isrunning;
  late var price;
  late var builddate;
  late var useraccount_id;

  Car(this.make, this.model, this.isrunning, this.price, this.builddate);

  Car.fromMap(Map<String, dynamic> map) {
    make = map['make'];
    model = map['model'];
    isrunning = map['isrunning'];
    price = map['price'];
    builddate = map['builddate'];
    useraccount_id = map['useraccount_id'];
  }

  toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['make'] = this.make;
    data['model'] = this.model;
    data['isrunning'] = this.isrunning;
    data['price'] = this.price;
    data['builddate'] = this.builddate;
    data['useraccount_id'] = this.useraccount_id;
    return data;
  }
}
