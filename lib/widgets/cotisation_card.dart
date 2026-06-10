import 'package:flutter/material.dart';
import '../models/cotisation.dart';

class CotisationCard extends StatelessWidget {
  final Cotisation cotisation;
  final VoidCallback onCheckboxChanged;
  final VoidCallback onTap;

  const CotisationCard({
    super.key,
    required this.cotisation,
    required this.onCheckboxChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: cotisation.paye ? Colors.green.shade50 : Colors.red.shade50,
      child: ListTile(
        leading: CircleAvatar(child: Text('${cotisation.tour}')),
        title: Text(cotisation.membre),
        subtitle: Text(
          'Montant: ${cotisation.montant} FCFA - ${cotisation.date.toString().split(' ')[0]}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: cotisation.paye,
              onChanged: (_) => onCheckboxChanged(),
            ),
            IconButton(icon: Icon(Icons.arrow_forward), onPressed: onTap),
          ],
        ),
      ),
    );
  }
}
