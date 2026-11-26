# Projet Swift - Gestion d'une bibliothèque (CHCL)

Cours : Programmation orientée objet - Langage : Swift

Application console pour gérer les livres de la bibliothèque CHCL. On saisit les données au clavier :
ajout de livres papier ou numériques, adhérents, emprunts et retours, affichage du catalogue
et des emprunts, recherche par titre.

## Structure du projet

```
1_Code_source/
├── Package.swift
├── Sources/GestionBibliotheque/
│   ├── Livre.swift
│   ├── LivrePapier.swift
│   ├── LivreNumerique.swift
│   ├── Adherent.swift          (3 livres maximum)
│   ├── Bibliotheque.swift
│   ├── TestsScenario.swift     (tests 1 à 8 et A à E)
│   └── main.swift              (menu interactif)
└── Version_fichier_unique/
    └── ProjetBibliotheque.swift   (même code dans un seul fichier)
```

## Lancer le programme

Avec le terminal (Swift 5.9 ou plus récent) :

```bash
cd 1_Code_source
swift run
```

Avec un seul fichier :

```bash
swiftc Version_fichier_unique/ProjetBibliotheque.swift -o bibliotheque
./bibliotheque
```

On peut aussi coller le contenu de `Version_fichier_unique/ProjetBibliotheque.swift` dans un projet
Command Line Tool de Xcode, ou dans un Playground.

## Menu

1. Ajouter un livre papier
2. Ajouter un livre numérique
3. Enregistrer un adhérent
4. Emprunter un livre
5. Retourner un livre
6. Afficher le catalogue
7. Afficher les emprunts d'un adhérent
8. Rechercher un livre par titre
9. Lancer les tests automatiques
0. Quitter

Les données restent en mémoire pendant l'exécution seulement. Rien n'est sauvegardé dans un fichier.

## Notions de POO utilisées

- Classes et objets : `Livre`, `Adherent`, `Bibliotheque`.
- Encapsulation : `estDisponible`, `livresEmpruntes` et `livres` sont en `private(set)`. On peut les lire
  mais pas les modifier de l'extérieur. La limite de 3 livres est vérifiée dans `Adherent.emprunterLivre(_:)`.
- Héritage : `LivrePapier` et `LivreNumerique` héritent de `Livre`.
- Polymorphisme : `afficherInformations()` est redéfinie dans chaque sous-classe, et le catalogue
  affiche tous les livres avec la même boucle.

## Quelques choix

- `emprunter()` et `retourner()` de `Livre` renvoient un `Bool`. Les messages sont affichés par `Adherent`.
- Un emprunt est refusé si l'adhérent a déjà le livre, s'il a déjà 3 livres ou si le livre est pris.
- On ne peut pas enregistrer deux adhérents avec le même nom (majuscules ignorées).
- `rechercherLivre(titre:)` renvoie le premier livre trouvé. Elle ignore les majuscules et les accents.
- Le code est entièrement en français.
