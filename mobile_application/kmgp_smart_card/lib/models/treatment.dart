class Treatment {
  int? id;
  String? treatment;
  bool? isHealed;
  String? dose;
  int? user;

  Treatment({this.id, this.treatment, this.isHealed, this.dose, this.user});

  Treatment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    treatment = json['treatment'];
    isHealed = json['is_healed'];
    dose = json['dose'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['treatment'] = this.treatment;
    data['is_healed'] = this.isHealed;
    data['dose'] = this.dose;
    data['user'] = this.user;
    return data;
  }
}