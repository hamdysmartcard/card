import 'package:flutter/material.dart';
import 'package:flutter_smart_card/models/disease.dart';
import 'package:flutter_smart_card/models/emergency_contact.dart';

import '../../widgets/app_button.dart';
import '../../widgets/app_light_text_form_field.dart';

class AddOrUpdateDiseasePopup {
  static Future<Disease?> showPopup(BuildContext context,
      {Disease? disease}) async {
    var newDisease = disease ??
        Disease(
            id: null,
            user: null,
            disease: null,
            discoverDate: null,
            isHealed: false);
    var doAction = false;

    return await showDialog<EmergencyContact>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add Emergency Contact'),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: SingleChildScrollView(
              child: Container(
                child: ListBody(
                  children: <Widget>[
                    AppLightTextFormField(
                        initialValue: newDisease.disease ?? '',
                        hintText: 'Name',
                        onChanged: (value) {
                          newDisease.disease = value;
                        }),
                    AppLightTextFormField(
                        initialValue: newDisease.discoverDate ?? '',
                        hintText: 'Date (ex: 2020-01-25)',
                        onChanged: (value) {
                          newDisease.discoverDate = value;
                        }),
                    CheckboxListTile(
                      title: Text("Is Healed"),
                      value: newDisease.isHealed,
                      onChanged: (newValue) {
                        setState(() {
                          newDisease.isHealed = newValue ?? false;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      checkColor: Colors.white,
                      activeColor: Colors.black,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    AppButton(
                      text: disease?.id != null ? 'Update' : 'Add',
                      onTap: () {
                        doAction = true;
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
      },
    ).then((value) => doAction ? newDisease : null);
  }
}
