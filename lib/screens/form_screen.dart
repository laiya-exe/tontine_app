import 'package:flutter/material.dart';
import '../models/cotisation.dart';
import 'package:tontine_app/main.dart';

class FormulaireScreen extends StatefulWidget {
  final String? cotisationId;
  final String? prefillMembre;

  const FormulaireScreen({super.key, this.cotisationId, this.prefillMembre});

  @override
  State<FormulaireScreen> createState() => _FormulaireScreenState();
}

class _FormulaireScreenState extends State<FormulaireScreen> {
  final _formKey = GlobalKey<FormState>();

  String _membre = '';
  int _montant = 0;
  int _tour = 1;
  DateTime _date = DateTime.now();
  bool _paye = false;

  @override
  void initState() {
    super.initState();

    if (widget.prefillMembre != null && widget.cotisationId == null) {
      _membre = widget.prefillMembre!;
    }

    if (widget.cotisationId != null) {
      _loadCotisation();
    }
  }

  Future<void> _loadCotisation() async {
    final cotisation = tontineService.trouverParId(widget.cotisationId!);

    if (cotisation != null) {
      setState(() {
        _membre = cotisation.membre;
        _montant = cotisation.montant;
        _tour = cotisation.tour;
        _date = cotisation.date;
        _paye = cotisation.paye;
      });
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        // ignore: deprecated_member_use
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black54),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        title: Text(
          widget.cotisationId == null
              ? 'Ajouter une cotisation'
              : 'Modifier la cotisation',
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    // ignore: deprecated_member_use
                    border: Border.all(color: Colors.grey.withOpacity(0.15)),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _membre,
                        enabled: widget.cotisationId == null,
                        decoration: _inputDecoration('Nom du membre').copyWith(
                          fillColor: widget.cotisationId == null
                              ? Colors.grey.shade50
                              : Colors.grey.shade100,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Champ obligatoire';
                          }
                          return null;
                        },
                        onSaved: (value) => _membre = value!,
                      ),

                      const SizedBox(height: 12),

                      TextFormField(
                        initialValue: _montant == 0 ? '' : _montant.toString(),
                        decoration: _inputDecoration('Montant (FCFA)'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Champ obligatoire';
                          }

                          if (int.tryParse(value) == null ||
                              int.parse(value) <= 0) {
                            return 'Montant valide requis';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _montant = int.parse(value!);
                        },
                      ),

                      const SizedBox(height: 12),

                      TextFormField(
                        initialValue: _tour.toString(),
                        decoration: _inputDecoration('Numéro de tour'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Champ obligatoire';
                          }

                          if (int.tryParse(value) == null ||
                              int.parse(value) <= 0) {
                            return 'Tour valide requis';
                          }

                          return null;
                        },
                        onSaved: (value) {
                          _tour = int.parse(value!);
                        },
                      ),

                      const SizedBox(height: 16),

                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.calendar_today_outlined),
                        title: const Text('Date de la cotisation'),
                        subtitle: Text(
                          _date.toString().split(' ')[0],
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _date,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );

                          if (picked != null) {
                            setState(() {
                              _date = picked;
                            });
                          }
                        },
                      ),

                      const Divider(),

                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Payé'),
                        value: _paye,
                        activeColor: Colors.green,
                        onChanged: (value) {
                          setState(() {
                            _paye = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          final newCotisation = Cotisation(
                            id:
                                widget.cotisationId ??
                                DateTime.now().millisecondsSinceEpoch
                                    .toString(),
                            membre: _membre,
                            montant: _montant,
                            tour: _tour,
                            date: _date,
                            paye: _paye,
                          );

                          if (widget.cotisationId == null) {
                            await tontineService.ajouter(newCotisation);
                          } else {
                            await tontineService.modifier(newCotisation);
                          }

                          if (mounted) {
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context, true);
                          }
                        }
                      },
                      child: const Text('Enregistrer'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
