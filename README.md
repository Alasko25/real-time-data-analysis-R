# 📊 Real-Time Customer Churn Prediction System with Shiny & Keras

## 🧠 Concept et idée de base

Ce projet a pour objectif de développer un **système intelligent de prédiction du churn client** (désabonnement) en temps réel. À partir de données clients (comme la durée d’abonnement, le montant mensuel payé, etc.), un modèle de Deep Learning est entraîné pour prédire la probabilité qu’un client quitte l’entreprise.

Le système inclut :
- Un modèle Keras de classification binaire (`churn` / `no churn`)
- Une interface Shiny interactive pour la visualisation
- Un mécanisme de streaming simulé pour de la prédiction en **temps réel**
- Une génération automatisée de **rapports PDF**
- Une architecture modulaire pour une meilleure organisation et réutilisabilité

---

## 🔧 Requirements (bibliothèques)

Toutes les bibliothèques nécessaires sont listées dans [`requirements.txt`](requirements.txt). Voici leur rôle dans le projet :

### 🧰 Core
- **tidyverse, data.table, readr** : Manipulation efficace des données
- **lubridate** : Gestion des dates (timestamps, arrondis)
- **ggplot2, plotly** : Visualisation statique et interactive
- **DataExplorer** : Génération automatique de rapports exploratoires

### 🧠 Modélisation
- **keras, tensorflow** : Création et entraînement du modèle de Deep Learning
- **caret, rsample** : Préparation des données, échantillonnage, métriques

### 📄 Reporting
- **rmarkdown** : Génération de rapports PDF personnalisés
- **tinytex** : Moteur LaTeX pour PDF

### 🖥️ Application interactive
- **shiny** : Interface web utilisateur
- **DT** : Tableaux dynamiques
- **gapminder, gifski, gganimate** : Graphiques animés pour le suivi de la perte

📌 Installation des dépendances :
```r
source("install_requirements.R")
````

---

## 📁 Structure du projet

```
project-root/
│
├── app/
│   ├── models/               # Modèle Keras sauvegardé (.h5)
│   ├── stream_input/         # Dossier surveillé pour les fichiers simulés en temps réel
│   └── app.R                 # Interface Shiny principale
│
├── data/                     # Dataset source (data.csv)
│
├── outputs/
│   ├── plots/                # Graphiques générés (courbe de perte animée, etc.)
│   └── reports/              # Rapports PDF générés automatiquement
│
├── scripts/                  # Scripts R modulaires
│   ├── 01_load_data.R
│   ├── 02_exploratory_analysis.R
│   ├── 03_visualization.R
│   ├── 04_model_training.R
│   ├── 05_prediction_realtime.R
│   └── 06_report_generation.R
│
├── simulate_stream.R         # Simule le flux de données en copiant des fichiers
├── install_requirements.R    # Installe les dépendances listées
├── main.R                    # (optionnel) pour orchestrer l'exécution sans interface
├── README.md
└── requirements.txt
```

---

## 🚀 Utilisation du système

### 🔹 Mode script (manuel / console)

1. Charger les données depuis `data/`
2. Exécuter les scripts dans `scripts/` pour :

   * Charger / prétraiter les données
   * Entraîner le modèle (`04_model_training.R`)
   * Lancer la prédiction sur données de test ou streamées
   * Générer les rapports PDF (`06_report_generation.R`)

### 🔹 Mode final (interface graphique)

Lancer l’interface complète via main.R:

```r
source("scripts/simulate_stream.R") # lancement du simulateur d'injection de données
simulate_stream()

shiny::runApp("app")
```

Fonctionnalités de l’application :

* **📁 Data Preview** : Affichage de l’ensemble des données
* **📊 Data Visualization** : Graphiques de répartition client
* **📉 Model Training Loss** : Animation de la perte pendant l’entraînement
* **🔎 Real-Time Predictions** : Visualisation des prédictions live avec évolution dans le temps
* **📄 Generate PDF Report** : Rapport complet généré automatiquement

---

## 📦 Simulation du flux de données en temps réel

Le fichier `simulate_stream.R` permet de simuler des arrivées successives de fichiers clients :

```r
source("simulate_stream.R")
```

Il copie automatiquement des fichiers vers le dossier `stream_input/` toutes les 5 secondes pour être traités par le modèle en live.

---

## 📌 À savoir

* Le modèle Keras est sauvegardé et rechargé automatiquement depuis `app/models/keras_model.h5`.
* Tous les fichiers traités sont supprimés après prédiction.
* Le graphique de prédiction est mis à jour **progressivement** grâce à un compteur (`display_count`) pour rendre l'affichage fluide même avec peu de données.
* L’interface est conçue pour **une démonstration pédagogique ou professionnelle** de bout en bout.

---

## 👨‍💻 Auteur

### TOURE Alassane
Projet conçu dans un contexte de formation Data Science avancée avec R, Deep Learning, et visualisation dynamique en Shiny.

---

## 📬 Contact

Pour toute question ou suggestion, n'hésitez pas à me contacter via <p>
  <a href="https://linkedin.com/in/alassane-tour%C3%A9-4b462728a" target="_blank"><img src="https://img.shields.io/badge/LinkedIn-Connect-blue" /></a>
  <a href="mailto:alassanretou058@gmail.com"><img src="https://img.shields.io/badge/Email-Contact-red" /></a>
</p>.
