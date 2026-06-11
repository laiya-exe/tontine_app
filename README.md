
# Rapport – Application de gestion de tontine

- **Auteur** : Akinlaiya G. AKPONIKPE
- **Date** : Vendredi 12 Juin 2026
- **Contexte** : Module développement multiplateforme – ODD 1 : Pas de pauvreté  
- **Sujet** : - [Enoncé du sujet](SUJET.md)

---

## 1. Présentation de l’application

L'application permet de gérer les cotisations d’une tontine de quartier à Dakar. Elle répond à l’**ODD 1 (Pas de pauvreté)** en favorisant l’épargne solidaire et en assurant un suivi clair des paiements entre membres. L’utilisateur peut enregistrer chaque cotisation (membre, montant, numéro de tour, date, statut payé/impayé), visualiser le total collecté, filtrer les impayés, et consulter le détail des cotisations d’un membre particulier. Les données sont persistantes après redémarrage grâce à `shared_preferences`.

---

## 2. Données réelles collectées

- **Source** : Tontine de jeunes – quartier de Dakar, Sénégal.  
- **Description** : 8 membres (Awa, Binta, Cheikh, Diarra, Moussa, Mohamed, Fatou, Aïda), montant par tour : 10 000 FCFA, périodicité hebdomadaire, durée totale 2 mois (8 tours).  
- **Date de collecte** : 12 juin 2026.  
- **Preuves** : photos dans le dossier `assets/proofs/`.

---

## 3. Modèle de données

**Fichier** : `lib/models/cotisation.dart`

```dart
enum TypeTontine { hebdomadaire, bimensuelle, mensuelle }

class Cotisation {
  final String id;
  final String membre;
  final int montant;
  final int tour;
  final DateTime date;
  bool paye;
  final TypeTontine type;
}
```

- **Champs** : `id` (identifiant unique), `membre` (nom), `montant` (FCFA), `tour` (numéro de tour), `date` (DateTime), `paye` (bool), `type` (enum).  
- **Pourquoi ces types ?** : `String` pour le texte, `int` pour les valeurs numériques (pas de décimales), `DateTime` pour la date, `bool` pour l’état de paiement, `enum` pour restreindre le type de tontine.  
- **Enum** : `TypeTontine` (ligne 1) – illustre l’utilisation d’un type énuméré.  
- **Méthode de calcul** : `totalCotise()` dans le service (voir section suivante).  
- **Sérialisation** : `toJson()` et `fromJson()` et quelques autres fonctions utilitaires pour la persistance (lignes 63-109).

---

## 4. Stateless / Stateful

| Widget               | Type        | Fichier + ligne                     | Justification |
|----------------------|-------------|-------------------------------------|---------------|
| `ListeScreen`        | Stateful    | `lib/screens/liste_screen.dart` ligne 5  | La liste évolue (ajout, suppression, filtre, case à cocher) → besoin de `setState`. |
| `MembreDetailScreen` | Stateful    | `lib/screens/membre_detail_screen.dart` ligne 4 | Le détail d’un membre affiche ses cotisations et permet des actions (check, modifier, supprimer) → `setState` utilisé. |
| `FormulaireScreen`   | Stateful    | `lib/screens/form_screen.dart` ligne 5  | Gère les champs et la validation → nécessite un état mutable. |
| `AboutScreen`        | Stateless   | `lib/screens/about_screen.dart` ligne 3  | Simple affichage d’informations, aucune interaction → widget pur. |

**Appel de `setState`** :  
- Dans `ListeScreen`, après le filtre, la case à cocher, l’ajout ou la suppression (méthode `_refresh`).  
- Dans `MembreDetailScreen`, après modification/suppression/ajout d’une cotisation (méthode `_refresh`).

---

## 5. CRUD complet

Toutes les opérations sont implémentées dans `lib/services/tontine_service.dart` et utilisées dans les écrans.

| Opération | Méthode dans le service | UI associée |
|-----------|-------------------------------------------|-------------------------------|
| **Créer** | `ajouter()` (ligne 52) | `FormulaireScreen` – bouton "Enregistrer" (ligne 238) |
| **Lire**  | `cotisations` (getter, ligne 49) et `trouverParId()` (ligne 74) | `ListeScreen` (build, ligne 23) et `MembreDetailScreen` (build, ligne 18) |
| **Modifier** | `modifier()` (ligne 58) | `FormulaireScreen` (modification, ligne 240) ; case à cocher dans `MembreDetailScreen` (ligne 185) |
| **Supprimer** | `supprimer()` (ligne 68) | `MembreDetailScreen` – dialogue de confirmation (lignes 245) |

- **Validation** : dans `FormulaireScreen`, les champs sont vérifiés (non vides, montant > 0, tour > 0).  
- **Confirmation de suppression** : `showDialog` avec `AlertDialog` (boutons Annuler/Supprimer).

---

## 6. Routage

**Fichier** : `lib/main.dart`

- Routes nommées via `onGenerateRoute` (lignes 26 à 58).  
- **3 écrans principaux** :  
  - `/` → `ListeScreen`  
  - `/membre` → `MembreDetailScreen` (reçoit `membreNom` en argument)  
  - `/form` → `FormulaireScreen` (reçoit `cotisationId` ou `prefillMembre`)

**Passage d’argument** :  
- Dans `liste_screen.dart`, au clic sur une cotisation :  
  ```dart
  Navigator.pushNamed(context, '/membre', arguments: cotisation.membre);
  ```
- Récupération dans `main.dart` :  
  ```dart
  case '/membre':
    final nom = settings.arguments as String?;
    return MaterialPageRoute(builder: (context) => MembreDetailScreen(membreNom: nom));
  ```

**Avec paramètres multiples** :  
- Passage d’une `Map` contenant `id` et `prefillMembre`.

---

## 7. Personnalisation de l’interface

- **Thème** : `primarySwatch: Colors.green`.  
- **Widget réutilisable** : `CotisationCard` dans `lib/widgets/cotisation_card.dart` – utilisé dans `ListeScreen`. Il accepte `cotisation`, `onCheckboxChanged` et `onTap` en paramètres.  
- **Code couleur** :  
  - Carte verte claire (`Colors.green.shade50`) pour les cotisations payées.  
  - Carte rouge claire (`Colors.red.shade50`) pour les impayées.  
- **En‑tête du total** : affiché avec un fond vert pâle, calculé dynamiquement.  
- **Écran À propos** : accessible via un `IconButton` dans l’`AppBar` de la liste.

---

## 8. Principale difficulté rencontrée

**Problème** : Persistance des données sur le navigateur. À chaque `flutter run`, le serveur de développement utilisait un port différent, ce qui créait une nouvelle origine et donc un `localStorage` différent. Les données ajoutées n’étaient pas retrouvées au redémarrage.

**Solution** : Fixer le port du serveur web avec la commande :  
```bash
flutter run -d chrome --web-port=8080
```
Ainsi l’URL reste identique (`http://localhost:8080`) et les données sont bien conservées.  
Cette astuce permet de bénéficier de `shared_preferences` sur le web sans perte de session.

**Autre difficulté** : `LateInitializationError` dans `FormulaireScreen` car les champs étaient déclarés `late` mais pas initialisés avant le `build`. J’ai corrigé en leur donnant des valeurs par défaut et en chargeant les données existantes dans `initState` de manière asynchrone.

---

## 9. Captures d’écran

**Écran 1 – Liste des cotisations**  
![Liste](https://github.com/laiya-exe/tontine_app/blob/main/assets/screenshots/liste.png)

**Écran 2 – Détail d’un membre (Awa)**  
![Détail membre](https://github.com/laiya-exe/tontine_app/blob/main/assets/screenshots/detail_membre.png)

**Écran 3 – Formulaire d’ajout**  
![Formulaire](https://github.com/laiya-exe/tontine_app/blob/main/assets/screenshots/formulaire.png)

**Écran 4 – A propos**  
![Formulaire](https://github.com/laiya-exe/tontine_app/blob/main/assets/screenshots/a_propos.png)

---

## Conclusion

L’application remplit toutes les exigences du sujet : CRUD complet, routage nommé, état géré avec `StatefulWidget` et `setState`, UI personnalisée et d’une méthode de calcul, persistance des données. Elle est fonctionnelle sur le web (avec port fixe) et répond au besoin réel de gestion d’une tontine sénégalaise.