import 'package:flutter/material.dart';
import '../models/cotisation.dart';
import '../services/tontine_service.dart';
import 'package:tontine_app/main.dart'; // pour accéder à tontineService declaré dans main.fart

class FormulaireScreen extends StatefulWidget {
  final String? cotisationId;

  const FormulaireScreen({super.key, this.cotisationId});

  @override
  // ignore: library_private_types_in_public_api
  _FormulaireScreenState createState() => _FormulaireScreenState();
}

class _FormulaireScreenState extends State<FormulaireScreen> {
  final _formKey = GlobalKey<FormState>();
  final TontineService _service = TontineService();

  late String _membre;
  late int _montant;
  late int _tour;
  late DateTime _date;
  late bool _paye;

  @override
  void initState() {
    super.initState();
    if (widget.cotisationId != null) {
      final existing = _service.trouverParId(widget.cotisationId!);
      if (existing != null) {
        _membre = existing.membre;
        _montant = existing.montant;
        _tour = existing.tour;
        _date = existing.date;
        _paye = existing.paye;
      }
    } else {
      _membre = '';
      _montant = 0;
      _tour = 1;
      _date = DateTime.now();
      _paye = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.cotisationId == null
              ? 'Ajouter une cotisation'
              : 'Modifier la cotisation',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _membre,
                decoration: InputDecoration(labelText: 'Nom du membre'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Champ obligatoire' : null,
                onSaved: (value) => _membre = value!,
              ),
              TextFormField(
                initialValue: _montant.toString(),
                decoration: InputDecoration(labelText: 'Montant (FCFA)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Champ obligatoire';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Montant valide requis';
                  }
                  return null;
                },
                onSaved: (value) => _montant = int.parse(value!),
              ),
              TextFormField(
                initialValue: _tour.toString(),
                decoration: InputDecoration(labelText: 'Numéro de tour'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Champ obligatoire';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Tour valide requis';
                  }
                  return null;
                },
                onSaved: (value) => _tour = int.parse(value!),
              ),
              ListTile(
                title: Text('Date de la cotisation'),
                subtitle: Text(_date.toString().split(' ')[0]),
                trailing: Icon(Icons.calendar_today),
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
              CheckboxListTile(
                title: Text('Payé'),
                value: _paye,
                onChanged: (value) {
                  setState(() {
                    _paye = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newCotisation = Cotisation(
                      id:
                          widget.cotisationId ??
                          DateTime.now().millisecondsSinceEpoch.toString(),
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
                    Navigator.pop(
                      // ignore: use_build_context_synchronously
                      context,
                      true,
                    ); // true pour rafraîchir la liste
                  }
                },
                child: Text('Enregistrer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
