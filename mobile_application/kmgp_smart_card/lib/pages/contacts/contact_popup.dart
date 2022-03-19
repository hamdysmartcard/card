import 'package:flutter/material.dart';
import 'package:flutter_smart_card/models/emergency_contact.dart';

import '../../widgets/app_button.dart';
import '../../widgets/app_light_text_form_field.dart';

class AddOrUpdateContactPopup {
  static Future<EmergencyContact?> showPopup(BuildContext context,
      {EmergencyContact? contact}) async {
    var newContact = contact ?? EmergencyContact(id: null,
        index: null,
        user: null,
        name: '',
        phoneNumber: '');
    var doAction = false;

    return await showDialog<EmergencyContact>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Emergency Contact'),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          content: SingleChildScrollView(
            child: Container(
              child: ListBody(
                children: <Widget>[
                  AppLightTextFormField(
                      initialValue: newContact.name ?? '',
                      hintText: 'Name',
                      onChanged: (value) {
                        newContact.name = value;
                      }),
                  AppLightTextFormField(
                      initialValue: newContact.phoneNumber ?? '',
                      hintText: 'Phone Number',
                      onChanged: (value) {
                        newContact.phoneNumber = value;
                      }),
                  AppLightTextFormField(
                      initialValue: newContact.index?.toString() ?? '',
                      keyboardType: TextInputType.number,
                      hintText: 'Priority/Order',
                      onChanged: (value) {
                        newContact.index = int.tryParse(value) ?? 0;
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  AppButton(
                    text: contact?.id != null ? 'Update' : 'Add',
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
      },
    ).then((value) => doAction ? newContact : null);
  }
}
