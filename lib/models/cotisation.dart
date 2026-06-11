enum TypeTontine { hebdomadaire, bimensuelle, mensuelle }

/// Modèle de données.
class Cotisation {
  final String id;
  final String membre;
  final int montant;
  final int tour; // numéro du tour (1 à N)
  final DateTime date;
  bool paye;
  final TypeTontine
  type; // pour montrer l'usage d'un enum (respect des exigences dart du projet)

  /// Constructeur
  Cotisation({
    required this.id,
    required this.membre,
    required this.montant,
    required this.tour,
    required this.date,
    required this.paye,
    this.type = TypeTontine.mensuelle, // valeur par défaut
  });

  /// Calcule le montant total des cotisations payées par le membre courant.
  /// Parcourt la liste des cotisations, sélectionne uniquement celles
  /// associées au membre courant (`this.membre`) et marquées comme payées
  /// (`paye == true`), puis additionne leurs montants.
  /// Retourne la somme totale des montants des cotisations payées. */
  int montantTotalParMembre(List<Cotisation> toutesLesCotisations) {
    return toutesLesCotisations
        .where((c) => c.membre == this.membre && c.paye)
        .fold(0, (sum, c) => sum + c.montant);
  }

  /// Crée une nouvelle instance de Cotisation en conservant les valeurs
  /// actuelles et en remplaçant uniquement les champs fournis en paramètre.
  /// Cette méthode facilite la mise à jour d'une cotisation sans modifier
  /// l'objet d'origine.
  Cotisation copyWith({
    String? id,
    String? membre,
    int? montant,
    int? tour,
    DateTime? date,
    bool? paye,
    TypeTontine? type,
  }) {
    return Cotisation(
      id: id ?? this.id,
      membre: membre ?? this.membre,
      montant: montant ?? this.montant,
      tour: tour ?? this.tour,
      date: date ?? this.date,
      paye: paye ?? this.paye,
      type: type ?? this.type,
    );
  }

  /// Convertit l'objet Cotisation en une structure JSON.
  /// Cette méthode transforme les attributs de la cotisation en une
  /// `Map<String, dynamic>` afin de faciliter le stockage avec `shared_preferences`
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'membre': membre,
      'montant': montant,
      'tour': tour,
      'date': date.toIso8601String(), // format standard pour les dates
      'paye': paye,
      'type': type
          .toString()
          .split('.')
          .last, // stocker l'enum en tant que String
    };
  }

  /// Crée une instance de Cotisation à partir de données JSON.
  /// Cette méthode de fabrique reconstruit un objet Cotisation en
  /// convertissant les valeurs stockées dans une `Map<String, dynamic>`.
  /// La date est reconvertie en objet DateTime et le type de tontine
  /// est restauré sous forme d'énumération (TypeTontine).
  factory Cotisation.fromJson(Map<String, dynamic> json) {
    return Cotisation(
      id: json['id'],
      membre: json['membre'],
      montant: json['montant'],
      tour: json['tour'],
      date: DateTime.parse(json['date']), // reconvertir la String en DateTime
      paye: json['paye'],
      type: _typeFromString(
        json['type'],
      ), // retrouver l'enum à partir de la String
    );
  }
}

// Convertit un String en valeur de l'enum TypeTontine
TypeTontine _typeFromString(String type) {
  switch (type) {
    case 'hebdomadaire':
      return TypeTontine.hebdomadaire;
    case 'bimensuelle':
      return TypeTontine.bimensuelle;
    default:
      return TypeTontine.mensuelle;
  }
}
