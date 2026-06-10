import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cotisation.dart';

const String _storageKey = 'cotisations_list';

class TontineService {
  List<Cotisation> _cotisations = [];
  late SharedPreferences _prefs;

  /// Initialise le service et charge les données stockées
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadCotisations();
  }

  /// Charge les cotisations depuis le stockage local
  Future<void> _loadCotisations() async {
    final String? jsonString = _prefs.getString(_storageKey);

    if (jsonString == null) {
      _cotisations = [];
      return;
    }

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _cotisations = jsonList.map((json) => Cotisation.fromJson(json)).toList();
    } catch (_) {
      _cotisations = [];
    }
  }

  /// Sauvegarde les cotisations dans le stockage local
  Future<void> _saveCotisations() async {
    try {
      final List<Map<String, dynamic>> jsonList = _cotisations
          .map((c) => c.toJson())
          .toList();

      final String jsonString = jsonEncode(jsonList);
      await _prefs.setString(_storageKey, jsonString);
    } catch (_) {
      // Erreur silencieuse (optionnel: log externe)
    }
  }

  /// Liste en lecture seule des cotisations
  List<Cotisation> get cotisations => List.unmodifiable(_cotisations);

  /// Ajoute une nouvelle cotisation
  Future<void> ajouter(Cotisation cotisation) async {
    _cotisations.add(cotisation);
    await _saveCotisations();
  }

  /// Modifie une cotisation existante
  Future<void> modifier(Cotisation cotisationModifiee) async {
    final index = _cotisations.indexWhere((c) => c.id == cotisationModifiee.id);

    if (index != -1) {
      _cotisations[index] = cotisationModifiee;
      await _saveCotisations();
    }
  }

  /// Supprime une cotisation par son ID
  Future<void> supprimer(String id) async {
    _cotisations.removeWhere((c) => c.id == id);
    await _saveCotisations();
  }

  /// Recherche une cotisation par ID
  Cotisation? trouverParId(String id) {
    try {
      return _cotisations.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Calcule le total des cotisations payées
  int totalCotise() {
    return _cotisations
        .where((c) => c.paye)
        .fold(0, (sum, c) => sum + c.montant);
  }
}
