import 'package:flutter/material.dart';
import 'package:flutter_smart_card/models/disease.dart';
import 'package:flutter_smart_card/models/emergency_contact.dart';
import 'package:flutter_smart_card/models/treatment.dart';

import '../../widgets/app_button.dart';
import '../../widgets/app_light_text_form_field.dart';

class AddOrUpdateTreatmentPopup {
  static Future<Treatment?> showPopup(BuildContext context,
      {Treatment? treatment}) async {
    var newTreatment = treatment ??
        Treatment(
            id: null,
            user: null,
            treatment: null,
            dose: null,
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
                        initialValue: newTreatment.treatment ?? '',
                        hintText: 'Treatment',
                        onChanged: (value) {
                          newTreatment.treatment = value;
                        }),
                    AppLightTextFormField(
                        initialValue: newTreatment.dose ?? '',
                        hintText: 'Dose',
                        onChanged: (value) {
                          newTreatment.dose = value;
                        }),
                    CheckboxListTile(
                      title: Text("Is Healed"),
                      value: newTreatment.isHealed,
                      onChanged: (newValue) {
                        setState(() {
                          newTreatment.isHealed = newValue ?? false;
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
                      text: treatment?.id != null ? 'Update' : 'Add',
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
    ).then((value) => doAction ? newTreatment : null);
  }
}
