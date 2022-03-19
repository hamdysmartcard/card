class Disease {
  int? id;
  String? disease;
  String? discoverDate;
  bool? isHealed;
  int? user;

  Disease(
      {this.id, this.disease, this.discoverDate, this.isHealed, this.user});

  Disease.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    disease = json['disease'];
    discoverDate = json['discover_date'];
    isHealed = json['is_healed'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['disease'] = this.disease;
    data['discover_date'] = this.discoverDate;
    data['is_healed'] = this.isHealed;
    data['user'] = this.user;
    return data;
  }
}