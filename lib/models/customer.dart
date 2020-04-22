//class Customer {
//  final String name;
//  final List<Data> data;
//  Customer({this.name, this.data});
//
//
//  factory Customer.fromJson(Map<String, dynamic> json){
//    return Customer(
//        name : json["name"],
//        data : Data
//    );
//  }
//}
//
//class Data {
//  final custId;
//  final historyId;
//  final double latitude;
//  final longitude;
//  final type;
//  final distance;
//  final time;
//  final indicator;
//
//  Data(
//      {this.custId,
//      this.historyId,
//      this.latitude,
//      this.longitude,
//      this.type,
//      this.distance,
//      this.time,
//      this.indicator});
//
//  factory Data.fromJson(Map<String, dynamic> json){
//    return Data(
//      custId: json["custId"]
//    );
//  }
//}
