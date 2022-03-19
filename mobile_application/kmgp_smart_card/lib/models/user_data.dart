import 'package:flutter_smart_card/models/treatment.dart';

import 'disease.dart';
import 'emergency_contact.dart';
import 'profile.dart';

class UserData {
  int? id;
  Profile? profile;
  List<Treatment>? treatments;
  List<Disease>? diseases;
  List<EmergencyContact>? emergencyContacts;

  UserData(
      {this.id,
      this.profile,
      this.treatments,
      this.diseases,
      this.emergencyContacts});

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    profile =
        json['profile'] != null ? new Profile.fromJson(json['profile']) : null;
    if (json['treatments'] != null) {
      treatments = <Treatment>[];
      json['treatments'].forEach((v) {
        treatments!.add(new Treatment.fromJson(v));
      });
    }
    if (json['diseases'] != null) {
      diseases = <Disease>[];
      json['diseases'].forEach((v) {
        diseases!.add(new Disease.fromJson(v));
      });
    }
    if (json['emergency_contacts'] != null) {
      emergencyContacts = <EmergencyContact>[];
      json['emergency_contacts'].forEach((v) {
        emergencyContacts!.add(new EmergencyContact.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    if (this.treatments != null) {
      data['treatments'] = this.treatments!.map((v) => v.toJson()).toList();
    }
    if (this.diseases != null) {
      data['diseases'] = this.diseases!.map((v) => v.toJson()).toList();
    }
    if (this.emergencyContacts != null) {
      data['emergency_contacts'] =
          this.emergencyContacts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
