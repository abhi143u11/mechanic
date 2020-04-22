class Mechanic {
  String name;
  String email;
  String password;
  String mobileno;
  String address;
  bool bike;
  bool car;
  bool bus;
  bool truck;
  bool tacter;
  bool autoer;
  bool toe;
  bool org;
  Mechanic(
      {this.name,
      this.email,
      this.password,
      this.mobileno,
      this.address,
      this.bike = false,
      this.car = false,
      this.bus = false,
      this.truck = false,
      this.tacter = false,
      this.autoer = false,
      this.org = false,
      this.toe = false});
}
