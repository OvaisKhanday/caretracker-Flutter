class Student {
  final String name;
  final String class_;
  final int rollNo;
  final String gender;
  final int age;
  final int busNo;
  final String? id;

  Student({
    required this.name,
    required this.class_,
    required this.rollNo,
    required this.gender,
    required this.busNo,
    required this.age,
    this.id,
  });

  Student.fromJson(Map<String, dynamic> map)
      : this(
            name: map['name'],
            class_: map['class'],
            rollNo: map['roll_no'],
            gender: map['gender'],
            busNo: map['bus_no'] ?? -1,
            age: map['age'],
            id: map['_id']);

  Map<String, dynamic> toJson() {
    return {'name': name, 'class': class_, 'roll_no': rollNo, 'gender': gender, 'bus_no': busNo, 'age': age, '_id': id};
  }
}
