import 'package:flutter/material.dart';
import 'package:tontine_app/main.dart';
import '../services/tontine_service.dart';

class DetailScreen extends StatelessWidget {
  final String cotisationId;

  const DetailScreen({super.key, required this.cotisationId});

  @override
  Widget build(BuildContext context) {
    final cotisation = tontineService.trouverParId(cotisationId);
    if (cotisation == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Détail')),
        body: Center(
          child: Text('Cotisation non trouvée (ID: $cotisationId)'),
        ), // affiche l'ID
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Détail de ${cotisation.membre}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Membre : ${cotisation.membre}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text('Montant : ${cotisation.montant} FCFA'),
            Text('Tour n° : ${cotisation.tour}'),
            Text('Date : ${cotisation.date.toString().split(' ')[0]}'),
            Text('Statut : ${cotisation.paye ? "Payé" : "Impayé"}'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.pushNamed(
                      context,
                      '/form',
                      arguments: cotisation.id,
                    );
                    if (result == true) {
                      Navigator.pop(
                        // ignore: use_build_context_synchronously
                        context,
                        true,
                      ); // retour à la liste pour rafraîchir
                    }
                  },
                  child: Text('Modifier'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirmation'),
                        content: Text('Supprimer cette cotisation ?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: Text('Annuler'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: Text('Supprimer'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await tontineService.supprimer(cotisation.id); // await
                      Navigator.pop(
                        // ignore: use_build_context_synchronously
                        context,
                        true,
                      ); // retour à la liste en signalant rafraîchissement
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Supprimer'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
