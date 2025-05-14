import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medired/core/value_objects/value_objects_export.dart';

class IdentificationCard extends StatelessWidget {
  const IdentificationCard({
    required this.firstName,
    required this.lastName,
    required this.documentValue,
    required this.birthdate,
    required this.documentType,
    required this.country,
    required this.sex,
    super.key,
  });

  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  final String firstName;
  final String lastName;
  final String documentValue;
  final DateTime birthdate;
  final DocumentType documentType;
  final Country country;
  final Sex? sex;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // radius of the border
      ),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${countryToEmoji[country]} ${countryToString[country]}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text('${documentTypeToString[documentType]}')
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: Theme.of(context).textTheme.titleLarge!.fontSize!,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  child: Icon(
                    Icons.person,
                    size: Theme.of(context).textTheme.titleLarge!.fontSize!,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: ListTile(
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                                title: Text(
                                  'NOMBRES:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(firstName),
                                dense: true,
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                                title: Text(
                                  'APELLIDOS:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(lastName),
                                dense: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              flex: 5,
                              child: ListTile(
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                                title: Text(
                                  'NACIMIENTO:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(_dateFormat.format(birthdate)),
                                dense: true,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: ListTile(
                                visualDensity:
                                    const VisualDensity(vertical: -4),
                                title: Text(
                                  'SEXO:',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(sexToString[sex]![0]),
                                dense: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -4),
                        title: Text(
                          'NUMERO DE DOCUMENTO:',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(documentValue),
                        dense: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
