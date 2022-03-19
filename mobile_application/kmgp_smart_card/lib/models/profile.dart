class Profile {
  String? name;
  String? phoneNumber;
  String? profileImage;
  String? address;
  String? bloodType;
  bool? isAddictive;
  int? nationalId;
  String? facebook;
  String? instagram;
  String? whatsapp;
  int? user;

  Profile(
      {this.name,
        this.phoneNumber,
        this.profileImage,
        this.address,
        this.bloodType,
        this.isAddictive,
        this.nationalId,
        this.facebook,
        this.instagram,
        this.whatsapp,
        this.user});

  Profile.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phone_number'];
    profileImage = json['profile_image'];
    address = json['address'];
    bloodType = json['blood_type'];
    isAddictive = json['is_addictive'];
    nationalId = json['national_id'];
    facebook = json['facebook'];
    instagram = json['instagram'];
    whatsapp = json['whatsapp'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone_number'] = this.phoneNumber;
    data['profile_image'] = this.profileImage;
    data['address'] = this.address;
    data['blood_type'] = this.bloodType;
    data['is_addictive'] = this.isAddictive;
    data['national_id'] = this.nationalId;
    data['facebook'] = this.facebook;
    data['instagram'] = this.instagram;
    data['whatsapp'] = this.whatsapp;
    data['user'] = this.user;
    return data;
  }
}