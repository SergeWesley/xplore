# XPlore

**Une application Flutter pour explorer les données astronomiques de la NASA**

[![Flutter](https://img.shields.io/badge/Flutter-3.9.2+-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2.svg)](https://dart.dev/)

---

## Description

XPlore est une application mobile multi-plateforme (iOS, Android, Web) permettant de découvrir et d'explorer les données astronomiques de la NASA. L'application exploite deux APIs principales pour offrir une expérience riche et interactive.

## Fonctionnalités

### Module APOD (Astronomy Picture of the Day)
- Affichage de l'image astronomique du jour
- Navigation dans l'historique (depuis 1995)
- Galerie responsive des 7 derniers jours
- Détails complets (titre, description, copyright)
- Gestion des favoris avec stockage local

### Module NEO (Near Earth Objects)
- Visualisation des astéroïdes sous forme de nuage de points interactif
- Taille proportionnelle au diamètre réel
- Code couleur pour les objets potentiellement dangereux
- Sélection de période personnalisée (max 7 jours, depuis 1974)
- Détails au tap : distance lunaire, vitesse, date de passage

---

## Architecture

Le projet suit la **Clean Architecture** de Robert C. Martin :

```
lib/
├── core/                    # Éléments partagés
│   ├── constants/           # Constantes (API, etc.)
│   ├── error/               # Exceptions et Failures
│   ├── network/             # Client HTTP (Dio)
│   ├── theme/               # Thèmes de l'application
│   ├── utils/               # Utilitaires
│   └── widgets/             # Widgets réutilisables
├── features/
│   ├── apod/                # Module APOD
│   │   ├── data/            # Datasources, Models, Repositories
│   │   ├── domain/          # Entities, Repositories, UseCases
│   │   └── presentation/    # Cubit, Pages, Widgets
│   └── neo/                 # Module NEO
│       └── ...              # Structure similaire
├── app.dart
├── injection_container.dart
└── main.dart
```

---

## Technologies

| Catégorie | Technologies |
|-----------|--------------|
| **Framework** | Flutter 3.9.2+ |
| **State Management** | flutter_bloc (Cubit) |
| **HTTP Client** | Dio |
| **Base de données** | Isar |
| **Injection de dépendances** | GetIt |
| **Programmation fonctionnelle** | fpdart (Either) |
| **Sérialisation** | json_serializable |

---

## Installation

### Prérequis

- Flutter SDK 3.9.2+
- Dart SDK 3.0+
- Clé API NASA ([Obtenir une clé](https://api.nasa.gov/))

### Étapes

1. **Cloner le repository**
   ```bash
   git clone https://github.com/votre-repo/xplore.git
   cd xplore
   ```

2. **Configurer les variables d'environnement**
   ```bash
   # Créer le fichier .env à la racine
   echo "NASA_API_KEY=votre_cle_api" > .env
   ```

3. **Installer les dépendances**
   ```bash
   flutter pub get
   ```

4. **Générer le code (Isar, JSON)**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

5. **Lancer l'application**
   ```bash
   flutter run
   ```

---

## Plateformes supportées

| Plateforme | Statut |
|------------|--------|
| Android | Supporté |
| iOS | Supporté |
| Web | Non supporté (limitation Isar) |
| macOS | Supporté |
| Windows | Supporté |
| Linux | Supporté |

---

## Auteur

**Apedo-Amah Wesley**

Développé dans le cadre de l'UE Technologies Mobiles - Master Informatique - Parcours E-Services, Université de Lille.

---

> *"The universe is under no obligation to make sense to you."* - Neil deGrasse Tyson
