class EmergencyContact {
  int? id;
  int? index;
  String? name;
  String? phoneNumber;
  int? user;

  EmergencyContact(
      {this.id, this.index, this.name, this.phoneNumber, this.user});

  EmergencyContact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    index = json['index'];
    name = json['name'];
    phoneNumber = json['phone_number'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['index'] = this.index;
    data['name'] = this.name;
    data['phone_number'] = this.phoneNumber;
    data['user'] = this.user;
    return data;
  }
}