class Bus {
  String? busRegNo;
  int? busNo;
  String? id;

  Bus({this.busRegNo, this.busNo, this.id});

  Bus.fromJson(Map<String, dynamic> map)
      : this(busRegNo: map['bus_registration'], busNo: map['bus_no'], id: map['_id']);

  Map<String, dynamic> toJson() {
    return {'bus_registration': busRegNo, 'bus_no': busNo, '_id': id};
  }
}

class DriverBusMappingClass {
  String driverName;
  String driverId;
  String busRegNo;
  int busNo;

  DriverBusMappingClass(
      {required this.driverName, required this.driverId, required this.busRegNo, required this.busNo});

  DriverBusMappingClass.fromJson(Map<String, dynamic> map)
      : this(
          driverName: map['driver']['name'],
          driverId: map['driver']['id'],
          busRegNo: map['bus']['busRegNo'],
          busNo: map['bus']['busNo'],
        );

  Map<String, dynamic> toJson() {
    return {
      'driver': {
        'name': driverName,
        'id': driverId,
      },
      'bus': {'busRegNo': busRegNo, 'busNo': busNo}
    };
  }

  void printDriverBusMapping() {
    print('driver');
    print('----> name: $driverName');
    print('----> id: $driverId');
    print('bus');
    print('----> busRegNo: $busRegNo');
    print('----> busNo: $busNo');
  }
}
