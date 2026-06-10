import 'package:flutter/material.dart';
import 'package:tontine_app/main.dart';
import 'package:tontine_app/widgets/cotisation_card.dart';

class ListeScreen extends StatefulWidget {
  const ListeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListeScreenState createState() => _ListeScreenState();
}

class _ListeScreenState extends State<ListeScreen> {
  bool _afficherImpayees = false;

  // force le rafraîchissement de l'interface
  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Récupérer toutes les cotisations depuis le service global
    final toutesLesCotisations = tontineService.cotisations;

    // Appliquer le filtre si nécessaire
    final cotisationsAffichees = _afficherImpayees
        ? toutesLesCotisations.where((c) => !c.paye).toList()
        : toutesLesCotisations;

    // Calcul du total cotisé (toutes cotisations payées)
    final total = tontineService.totalCotise();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion Tontine'),
        actions: [
          // Bouton pour afficher uniquement les impayées
          IconButton(
            icon: Icon(
              _afficherImpayees ? Icons.visibility_off : Icons.visibility,
            ),
            tooltip: 'Afficher uniquement les impayées',
            onPressed: () {
              setState(() {
                _afficherImpayees = !_afficherImpayees;
              });
            },
          ),
          // Écran "À propos"
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // En-tête avec le total
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.green.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total cotisé :',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$total FCFA',
                  style: TextStyle(fontSize: 18, color: Colors.green.shade800),
                ),
              ],
            ),
          ),
          // Liste des cotisations
          Expanded(
            child: cotisationsAffichees.isEmpty
                ? Center(child: Text('Aucune cotisation à afficher'))
                : ListView.builder(
                    itemCount: cotisationsAffichees.length,
                    itemBuilder: (context, index) {
                      final cotisation = cotisationsAffichees[index];
                      return CotisationCard(
                        cotisation: cotisation,
                        onCheckboxChanged: () async {
                          // Inverser l'état payé
                          final cotisationModifiee = cotisation.copyWith(
                            paye: !cotisation.paye,
                          );
                          await tontineService.modifier(cotisationModifiee);
                          _refresh(); // rafraîchir l'affichage
                        },
                        onTap: () async {
                          // Naviguer vers l'écran de détail
                          final result = await Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: cotisation.id,
                          );
                          if (result == true) _refresh();
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/form');
          if (result == true) _refresh();
        },
      ),
    );
  }
}
