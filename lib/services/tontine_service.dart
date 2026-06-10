import 'dart:convert'; // import pour jsonEncode/jsonDecode
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cotisation.dart';
import 'package:flutter/foundation.dart';

// Clé pour stocker la liste dans SharedPreferences
const String _storageKey = 'cotisations_list';

/// Service de gestion des cotisations d'une tontine.
///
/// Cette classe assure :
/// - la persistance des données avec SharedPreferences ;
/// - les opérations CRUD (ajout, modification, suppression) ;
/// - la recherche et les calculs sur les cotisations.
class TontineService {
  // Une liste qui stocke les cotisations
  List<Cotisation> _cotisations = [];

  // Une instance de SharedPreferences sera utilisée pour la persistance
  late SharedPreferences _prefs;

  /// Initialise le service et charge les cotisations enregistrées
  /// dans le stockage local.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadCotisations(); // Charge les données au démarrage
  }

  /// Charge les cotisations sauvegardées depuis le stockage local.
  /// Si aucune donnée n'est trouvée ou en cas d'erreur,
  /// une liste vide est utilisée.
  Future<void> _loadCotisations() async {
    final String? jsonString = _prefs.getString(_storageKey);
    if (jsonString == null) {
      _cotisations = [];
      return;
    }

    try {
      // Décode la chaîne JSON en une Liste de Maps
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _cotisations = jsonList.map((json) => Cotisation.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Erreur lors du chargement des données : $e");
      _cotisations = [];
    }
  }

  /// Convertit la liste des cotisations en JSON puis l'enregistre
  /// dans le stockage local afin de conserver les données entre
  /// les exécutions de l'application.
  Future<void> _saveCotisations() async {
    final List<Map<String, dynamic>> jsonList = _cotisations
        .map((c) => c.toJson())
        .toList();
    final String jsonString = jsonEncode(jsonList);
    await _prefs.setString(_storageKey, jsonString);
  }

  /// Retourne une copie non modifiable de la liste des cotisations.
  List<Cotisation> get cotisations => List.unmodifiable(_cotisations);

  /// Ajoute une nouvelle cotisation à la liste puis sauvegarde
  /// automatiquement les modifications.
  Future<void> ajouter(Cotisation cotisation) async {
    _cotisations.add(cotisation);
    await _saveCotisations();
  }

  /// Met à jour une cotisation existante identifiée par son id,
  /// puis sauvegarde les modifications.
  Future<void> modifier(Cotisation cotisationModifiee) async {
    final index = _cotisations.indexWhere((c) => c.id == cotisationModifiee.id);
    if (index != -1) {
      _cotisations[index] = cotisationModifiee;
      await _saveCotisations();
    }
  }

  /// Supprime la cotisation correspondant à l'identifiant fourni
  /// puis sauvegarde les modifications.
  Future<void> supprimer(String id) async {
    _cotisations.removeWhere((c) => c.id == id);
    await _saveCotisations();
  }

  /// Recherche une cotisation à partir de son identifiant.
  /// Retourne la cotisation trouvée ou null si elle n'existe pas.
  Cotisation? trouverParId(String id) {
    try {
      return _cotisations.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Calcule et retourne le montant total des cotisations payées.
  int totalCotise() {
    return _cotisations
        .where((c) => c.paye)
        .fold(0, (sum, c) => sum + c.montant);
  }

  /// Retourne la liste des cotisations dont le paiement
  /// n'a pas encore été effectué.
  List<Cotisation> get impayees {
    return _cotisations.where((c) => !c.paye).toList();
  }
}
