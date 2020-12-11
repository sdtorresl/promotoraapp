import 'package:flutter/material.dart';

import 'package:promotoraapp/Common/contacts_management.dart';
import 'package:promotoraapp/Model/contacts_model.dart';

class ContactsList extends StatelessWidget {
  final List<ContactsModel> contacts;

  ContactsList({@required this.contacts});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ContactsManagementList(
            name: contacts[index].name,
            surname: contacts[index].surname,
            company: contacts[index].company,
            id: contacts[index].company,
          );
        },
      ),
    );
  }
}
