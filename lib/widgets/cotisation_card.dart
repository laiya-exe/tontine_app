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
    final statutColor = cotisation.paye ? Colors.green : Colors.red;

    final statutBackground = cotisation.paye
        ? Colors.green.shade50
        : Colors.red.shade50;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          // ignore: deprecated_member_use
          border: Border.all(color: Colors.grey.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: statutBackground,
              child: Text(
                '${cotisation.tour}',
                style: TextStyle(
                  color: statutColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cotisation.membre,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    cotisation.date.toString().split(' ')[0],
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text(
                        '${cotisation.montant} FCFA',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(width: 10),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statutBackground,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          cotisation.paye ? 'Payé' : 'Impayé',
                          style: TextStyle(
                            color: statutColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                  value: cotisation.paye,
                  onChanged: (_) => onCheckboxChanged(),
                ),

                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, size: 18),
                  onPressed: onTap,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
