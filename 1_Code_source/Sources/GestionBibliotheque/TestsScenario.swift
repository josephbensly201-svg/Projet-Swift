import Foundation

func afficherTitre(_ texte: String) {
    let ligne = String(repeating: "=", count: 64)
    print("")
    print(ligne)
    print(texte)
    print(ligne)
}

func verifier(_ description: String, _ condition: Bool) {
    let resultat = condition ? "OK" : "ÉCHEC"
    print("  Vérification : \(description) -> \(resultat)")
}

func lancerScenarioDeTests() {
    afficherTitre("Test 1 : Créer une bibliothèque")
    let bibliotheque = Bibliotheque(nom: "CHCL")
    print("Bibliothèque « \(bibliotheque.nom) » créée.")
    verifier("le catalogue est vide au départ", bibliotheque.livres.isEmpty)

    afficherTitre("Test 2 : Ajouter au moins trois livres")
    let gouverneursDeLaRosee = LivrePapier(titre: "Gouverneurs de la rosée", auteur: "Jacques Roumain", nombrePages: 224)
    let compereGeneralSoleil = LivrePapier(titre: "Compère Général Soleil", auteur: "Jacques Stephen Alexis", nombrePages: 366)
    let petitPrince = LivreNumerique(titre: "Le Petit Prince", auteur: "Antoine de Saint-Exupéry", tailleFichierMo: 2.4)
    let paysSansChapeau = LivreNumerique(titre: "Pays sans chapeau", auteur: "Dany Laferrière", tailleFichierMo: 1.8)

    bibliotheque.ajouterLivre(gouverneursDeLaRosee)
    bibliotheque.ajouterLivre(compereGeneralSoleil)
    bibliotheque.ajouterLivre(petitPrince)
    bibliotheque.ajouterLivre(paysSansChapeau)
    verifier("le catalogue contient 4 livres", bibliotheque.livres.count == 4)

    afficherTitre("Test 3 : Créer un adhérent")
    let adherent = Adherent(nom: "Mathieu Pierre")
    print("Adhérent « \(adherent.nom) » créé.")
    verifier("il n'a aucun livre emprunté", adherent.livresEmpruntes.isEmpty)

    afficherTitre("Test 4 : Afficher le catalogue")
    bibliotheque.afficherCatalogue()

    afficherTitre("Test 5 : Emprunter un livre")
    adherent.emprunterLivre(gouverneursDeLaRosee)
    adherent.emprunterLivre(compereGeneralSoleil)
    adherent.emprunterLivre(petitPrince)
    verifier("« Gouverneurs de la rosée » n'est plus disponible", !gouverneursDeLaRosee.estDisponible)
    verifier("l'adhérent a 3 livres empruntés", adherent.livresEmpruntes.count == 3)

    afficherTitre("Test 6 : Essayer d'emprunter un livre déjà emprunté")
    let empruntReussi = adherent.emprunterLivre(gouverneursDeLaRosee)
    verifier("l'emprunt est refusé", !empruntReussi)
    verifier("l'adhérent a toujours 3 livres empruntés", adherent.livresEmpruntes.count == 3)

    afficherTitre("Test 7 : Retourner un livre")
    adherent.retournerLivre(gouverneursDeLaRosee)
    verifier("« Gouverneurs de la rosée » est de nouveau disponible", gouverneursDeLaRosee.estDisponible)
    verifier("l'adhérent a 2 livres empruntés", adherent.livresEmpruntes.count == 2)

    afficherTitre("Test 8 : Afficher les livres empruntés par l'adhérent")
    adherent.afficherEmprunts()

    afficherTitre("Test complémentaire A : limite de trois livres par adhérent")
    adherent.emprunterLivre(gouverneursDeLaRosee)
    let quatriemeEmpruntReussi = adherent.emprunterLivre(paysSansChapeau)
    verifier("le 3e emprunt est accepté (3 livres)", adherent.livresEmpruntes.count == 3)
    verifier("le 4e emprunt est refusé", !quatriemeEmpruntReussi)
    verifier("« Pays sans chapeau » est resté disponible", paysSansChapeau.estDisponible)

    afficherTitre("Test complémentaire B : livre déjà emprunté par un autre adhérent")
    let deuxiemeAdherent = Adherent(nom: "Marie Joseph")
    print("Adhérent « \(deuxiemeAdherent.nom) » créé.")
    let empruntConcurrentReussi = deuxiemeAdherent.emprunterLivre(compereGeneralSoleil)
    verifier("l'emprunt est refusé", !empruntConcurrentReussi)
    deuxiemeAdherent.emprunterLivre(paysSansChapeau)
    verifier("« Pays sans chapeau » est maintenant emprunté", !paysSansChapeau.estDisponible)

    afficherTitre("Test complémentaire C : retour d'un livre non emprunté")
    let retourInvalideReussi = deuxiemeAdherent.retournerLivre(petitPrince)
    verifier("le retour est refusé", !retourInvalideReussi)
    verifier("« Le Petit Prince » reste emprunté (par Mathieu Pierre)", !petitPrince.estDisponible)
    adherent.retournerLivre(compereGeneralSoleil)
    verifier("« Compère Général Soleil » est de nouveau disponible", compereGeneralSoleil.estDisponible)

    afficherTitre("Test complémentaire D : rechercher un livre par son titre")
    let titresCherches = ["petit prince", "général soleil", "Les Misérables"]
    for titreCherche in titresCherches {
        if let livreTrouve = bibliotheque.rechercherLivre(titre: titreCherche) {
            print("Recherche « \(titreCherche) » : livre trouvé.")
            livreTrouve.afficherInformations()
        } else {
            print("Recherche « \(titreCherche) » : aucun livre trouvé.")
        }
    }

    afficherTitre("Test complémentaire E : état final")
    bibliotheque.afficherCatalogue()
    adherent.afficherEmprunts()
    deuxiemeAdherent.afficherEmprunts()

    print("")
    print("Fin du programme.")
}
