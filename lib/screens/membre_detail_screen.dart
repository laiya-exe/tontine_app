import 'package:flutter/material.dart';
import 'package:tontine_app/main.dart';

class MembreDetailScreen extends StatefulWidget {
  final String membreNom;

  const MembreDetailScreen({super.key, required this.membreNom});

  @override
  State<MembreDetailScreen> createState() => _MembreDetailScreenState();
}

class _MembreDetailScreenState extends State<MembreDetailScreen> {
  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final toutes = tontineService.cotisations;

    final cotisationsMembre = toutes
        .where((c) => c.membre == widget.membreNom)
        .toList();

    final totalPaye = cotisationsMembre
        .where((c) => c.paye)
        .fold<int>(0, (sum, c) => sum + c.montant);

    final totalImpaye = cotisationsMembre
        .where((c) => !c.paye)
        .fold<int>(0, (sum, c) => sum + c.montant);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: Text(widget.membreNom),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Résumé
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                // ignore: deprecated_member_use
                border: Border.all(color: Colors.grey.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '$totalPaye FCFA',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('Payé'),
                      ],
                    ),
                  ),

                  Container(width: 1, height: 40, color: Colors.grey.shade300),

                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '$totalImpaye FCFA',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text('Impayé'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Liste des cotisations
            Expanded(
              child: cotisationsMembre.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucune cotisation pour ce membre',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: cotisationsMembre.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final c = cotisationsMembre[index];

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              // ignore: deprecated_member_use
                              color: Colors.grey.withOpacity(0.15),
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),

                            leading: CircleAvatar(
                              backgroundColor: c.paye
                                  ? Colors.green.shade50
                                  : Colors.red.shade50,
                              child: Text(
                                '${c.tour}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            title: Text(
                              '${c.montant} FCFA',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),

                                Text(c.date.toString().split(' ')[0]),

                                const SizedBox(height: 6),

                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: c.paye
                                        ? Colors.green.shade50
                                        : Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    c.paye ? 'Payé' : 'Impayé',
                                    style: TextStyle(
                                      color: c.paye ? Colors.green : Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Checkbox(
                                  value: c.paye,
                                  onChanged: (value) async {
                                    final modifiee = c.copyWith(paye: value);

                                    await tontineService.modifier(modifiee);

                                    _refresh();
                                  },
                                ),

                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () async {
                                    final result = await Navigator.pushNamed(
                                      context,
                                      '/form',
                                      arguments: c.id,
                                    );

                                    if (result == true) {
                                      _refresh();
                                    }
                                  },
                                ),

                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        title: const Text('Confirmation'),
                                        content: const Text(
                                          'Supprimer cette cotisation ?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx, false),
                                            child: const Text('Annuler'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(ctx, true),
                                            child: const Text(
                                              'Supprimer',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      await tontineService.supprimer(c.id);

                                      _refresh();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black87,
        elevation: 1,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.pushNamed(
            context,
            '/form',
            arguments: {'prefillMembre': widget.membreNom},
          );

          if (result == true) {
            _refresh();
          }
        },
      ),
    );
  }
}
