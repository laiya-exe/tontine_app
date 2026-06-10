# 1. Présentation et objectifs

Dans le cadre du module de développement multiplateforme, chaque étudiant réalise individuellement une application Flutter complète sur une thématique qui lui est propre (voir votre fiche personnelle en fin de document), en lien avec un Objectif de Développement Durable (ODD) et le contexte sénégalais.  
L'objectif est de démontrer votre maîtrise des fondamentaux de Flutter à travers une application fonctionnelle, personnelle et bien documentée, que vous êtes capable de présenter et d'expliquer.


# 2. Calendrier et livrables

## Calendrier

- Remise du sujet au responsable : lundi 1er juin 2026  
- Date limite de rendu (projet + rapport + vidéo) : vendredi 12 juin 2026

## Livrables attendus

1. **Le projet** : code source de l'application sur un dépôt Git (GitHub ou GitLab), avec des commits réguliers et datés tout au long du travail (et non un dépôt déposé en une seule fois).  
2. **Un écran « À propos »** dans l'application affichant votre nom, la source de vos données et la date de collecte.  
3. **Un rapport individuel** (2 à 3 pages) suivant le modèle de la section 5.  
4. **Une vidéo de présentation** de 10 minutes (voir section 4).  
5. **Le jeu de données réel** que vous avez collecté (selon votre fiche), avec ses preuves : photos datées et lieu.


# 3. Compétences et fonctionnalités attendues

Quel que soit votre sujet, votre application doit démontrer clairement les cinq notions suivantes. Ces exigences sont les mêmes pour tous.

| Notion | Exigence |
|--------|----------|
| **Dart** | Au moins une classe modèle avec constructeur et paramètres nommés ; usage de `List` et `Map` ; null safety correcte ; au moins un `enum` ; au moins une méthode qui calcule (total, moyenne, durée…). |
| **Stateless / Stateful** | Les deux présents et justifiés. Au moins un `StatefulWidget` avec `setState` pour une interaction réelle (ajout, suppression, filtre, calcul) ; les widgets d'affichage purs restent `StatelessWidget`. |
| **Customisation de l'UI** | Un `ThemeData` personnalisé (couleur principale propre à votre thème) ; au moins un widget réutilisable que vous avez créé (ex. carte d'élément) ; une mise en page soignée. |
| **CRUD complet** | Créer (formulaire avec validation), Lire (liste + détail), Modifier (formulaire pré-rempli), Supprimer (avec dialogue de confirmation). Le stockage en mémoire est accepté ; `shared_preferences` ou `sqflite` constituent un bonus. |
| **Routage** | Au moins 3 écrans. Navigation par routes nommées (`routes` de `MaterialApp` / `onGenerateRoute` + `Navigator`) ou `go_router`. Le passage d'arguments entre écrans est exigé au moins une fois. |


# 4. La vidéo de présentation (10 minutes)

La vidéo dure 10 minutes au total et se divise en deux parties égales. Votre voix doit être audible, votre écran lisible, et vous annoncez votre nom au début. Une seule prise continue est recommandée.

## Partie 1 — Présentation du projet et du code (5 min)

- Démonstration de l'application en fonctionnement : le CRUD complet et la navigation entre vos écrans.
- Parcours de votre code en expliquant les concepts demandés : votre modèle Dart, le choix Stateless / Stateful et l'appel à `setState`, la personnalisation de l'interface, le CRUD et le routage.

## Partie 2 — Live coding (5 min)

- Vous codez et expliquez « comment » vous réalisez les fonctionnalités propres à votre projet (listées sur votre fiche personnelle), en montrant l'éditeur et le résultat (hot reload).
- Expliquez vos choix au fur et à mesure : pourquoi tel widget, où l'état est mis à jour, comment l'argument est passé entre écrans.

**Important :** votre vidéo et votre rapport doivent correspondre à votre code. Toute incohérence entre ce que vous présentez et ce que fait réellement votre application sera pénalisée.


# 5. Modèle de rapport individuel (2 à 3 pages)

Rédigez le rapport avec vos propres mots. Lorsque c'est demandé, citez le fichier et la ligne exacte de votre code.

1. **Présentation de votre application** en un paragraphe et son lien avec l'ODD de votre sujet.

2. **Le jeu de données réel collecté** : source, lieu et date (joignez les preuves : photos datées).

3. **Votre modèle de données** : la classe, ses champs et leurs types, et pourquoi ces types.

4. **Stateless / Stateful** : citez un widget de chaque dans votre code (fichier + ligne) et justifiez le choix. Indiquez où `setState` est appelé et ce qui se met à jour.

5. **CRUD** : expliquez votre logique de création (validation) et de suppression (confirmation), fichiers et lignes à l'appui.

6. **Routage** : expliquez comment vous naviguez entre vos écrans et comment vous passez un argument (fichier + ligne).

7. **Personnalisation de l'interface** : ce que vous avez personnalisé (thème, widget réutilisable).

8. **La principale difficulté rencontrée** et comment vous l'avez résolue (avec vos propres mots).

9. **Captures d'écran** de vos écrans.


# 6. Modalités d'évaluation — barème sur 20

| Critère | Points |
|---------|--------|
| CRUD complet et correct | 3 pts |
| Routage (3 écrans + passage d'arguments) | 2 pts |
| Stateful / Stateless + qualité du code Dart | 2 pts |
| Personnalisation de l'interface | 2 pts |
| Données réelles collectées + preuves + écran « À propos » | 1 pt |
| Rapport individuel (clarté, exactitude, cohérence avec le code) | 4 pts |
| Vidéo — présentation du projet et explication des concepts | 3 pts |
| Vidéo — live coding des fonctionnalités et explication du « comment » | 3 pts |
| **TOTAL** | **20 pts** |


# 7. Règles à respecter

- Le projet est strictement individuel. Deux applications identiques ou quasi identiques (mêmes écrans, même logique, seules les couleurs ou les noms changeant) seront sanctionnées pour les deux étudiants.

- Rédigez votre rapport et préparez votre vidéo avec vos propres mots et vos propres données. Tout rapport qui mentionne le nom, le sujet ou les données d'un autre étudiant — signe d'un copier-coller — sera pénalisé pour les deux étudiants concernés.

- Vous devez maîtriser l'intégralité de votre code : votre rapport et votre vidéo doivent démontrer que vous comprenez ce que vous avez écrit.

- N'utilisez pas de package qui génère automatiquement l'interface ou le CRUD à votre place : les cinq notions doivent être implémentées par vous.

- Votre application doit utiliser vos propres données réelles collectées, et non des données fictives génériques.

- Respectez votre sujet : une application qui ne correspond pas à la fiche attribuée n'est pas recevable.


# 8. Sujet - Gestion d'une tontine de quartier – ODD 1 : Pas de pauvreté

| Élément | Description |
|---------|-------------|
| **Contexte** | Une tontine permet à des membres de cotiser à tour de rôle. Il faut suivre les cotisations et savoir qui a payé. |
| **Données de l'application** | Cotisation — membre (texte), montant en FCFA (entier), numéro de tour (entier), date (date), payé (booléen) |
| **Écrans** | Écran 1 : liste des cotisations. <br> Écran 2 : détail d’un membre. <br> Écran 3 : formulaire. |
| **Navigation** | Routes nommées (ou go_router) ; le nom du membre est passé en argument. |
| **Interaction dynamique (Stateful)** | Total cotisé recalculé en temps réel ; case à cocher payé/impayé qui met à jour la liste. |
| **Personnalisation de l’interface** | Somme totale affichée en en-tête ; code couleur payé (vert) / impayé (rouge). |
| **Données réelles à collecter** | Décrire le fonctionnement réel d’une tontine connue de l’étudiant : montant, périodicité, nombre de membres (dans le README). |
| **À coder en live (vidéo)** | Dans les 5 min de live coding, codez et expliquez le « comment » de : <br> 1. La création (avec validation) et la suppression (avec confirmation) d’un élément « Cotisation ». <br> 2. Total cotisé recalculé en temps réel ; case à cocher payé/impayé qui met à jour la liste. <br> 3. N’afficher que les cotisations impayées. <br> Montrez aussi le passage d’argument entre écrans. |