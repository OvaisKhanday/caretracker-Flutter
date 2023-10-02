class Driver {
  String? name;
  String? phoneNo;
  String? residence;
  String? username;
  String? id;
  int? age;
  int? busNo;

  Driver({this.name, this.phoneNo, this.residence, this.username, this.id, this.age, this.busNo});

  Driver.fromJson(Map<String, dynamic> map)
      : this(
          name: map['name'],
          phoneNo: map['phone_no'] ?? '',
          residence: map['residence'] ?? '',
          username: map['username'],
          id: map['_id'],
          age: map['age'] ?? -1,
          busNo: map['bus_id'] != null ? map['bus_id']['bus_no'] : -1,
        );

  Map<String, dynamic> toJson() {
    return {'name': name, 'residence': residence, 'phone_no': phoneNo, 'age': age};
  }
}

class DriverNameAndId {
  final String name;
  final String id;

  DriverNameAndId({required this.name, required this.id});
  DriverNameAndId.fromJson(Map<String, dynamic> map)
      : this(
          name: map['name'],
          id: map['id'],
        );

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }
}
