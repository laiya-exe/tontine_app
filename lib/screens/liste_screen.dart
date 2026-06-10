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
    final toutesLesCotisations = tontineService.cotisations;

    final cotisationsAffichees = _afficherImpayees
        ? toutesLesCotisations.where((c) => !c.paye).toList()
        : toutesLesCotisations;

    final total = tontineService.totalCotise();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: const Text('Gestion Tontine'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: Icon(
              _afficherImpayees
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            onPressed: () {
              setState(() {
                _afficherImpayees = !_afficherImpayees;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total cotisé',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '$total FCFA',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: cotisationsAffichees.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucune cotisation à afficher',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: cotisationsAffichees.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final cotisation = cotisationsAffichees[index];

                        return CotisationCard(
                          cotisation: cotisation,
                          onCheckboxChanged: () async {
                            final modifiee = cotisation.copyWith(
                              paye: !cotisation.paye,
                            );
                            await tontineService.modifier(modifiee);
                            _refresh();
                          },
                          onTap: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              '/membre',
                              arguments: cotisation.membre,
                            );
                            if (result == true) _refresh();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        elevation: 1,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/form');
          if (result == true) _refresh();
        },
      ),
    );
  }
}
