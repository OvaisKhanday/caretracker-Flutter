class Parent {
  String? name;
  String? phoneNo;
  String? gender;
  String? residence;
  String? username;
  String? id;

  Parent({
    this.name,
    this.phoneNo,
    this.gender,
    this.residence,
    this.username,
    this.id,
  });

  Parent.fromJson(Map<String, dynamic> map)
      : this(
            name: map['name'],
            phoneNo: map['phone_no'],
            gender: map['gender'],
            residence: map['residence'],
            username: map['username'],
            id: map['_id']);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_no': phoneNo,
      'gender': gender,
      'residence': residence,
      'username': username,
      '_id': id
    };
  }
}
