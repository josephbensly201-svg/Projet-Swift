import Foundation

let bibliotheque = Bibliotheque(nom: "CHCL")
var adherents: [Adherent] = []

// nil si l'entrée est fermée (Ctrl+D)
func lireLigne(_ invite: String) -> String? {
    print(invite, terminator: " : ")
    guard let ligne = readLine() else {
        return nil
    }
    return ligne.trimmingCharacters(in: .whitespaces)
}

func lireTexteObligatoire(_ invite: String) -> String? {
    while true {
        guard let texte = lireLigne(invite) else { return nil }
        if !texte.isEmpty { return texte }
        print("  Saisie vide : veuillez réessayer.")
    }
}

func lireEntierPositif(_ invite: String) -> Int? {
    while true {
        guard let texte = lireLigne(invite) else { return nil }
        if let valeur = Int(texte), valeur > 0 { return valeur }
        print("  Veuillez saisir un nombre entier positif.")
    }
}

// accepte la virgule ou le point
func lireDecimalPositif(_ invite: String) -> Double? {
    while true {
        guard let texte = lireLigne(invite) else { return nil }
        if let valeur = Double(texte.replacingOccurrences(of: ",", with: ".")), valeur > 0 {
            return valeur
        }
        print("  Veuillez saisir un nombre positif (ex. 2.4).")
    }
}

func choisirLivre(_ invite: String) -> Livre? {
    let livres = bibliotheque.livres
    if livres.isEmpty {
        print("  Le catalogue est vide.")
        return nil
    }
    for (index, livre) in livres.enumerated() {
        print("  \(index + 1). \(livre.titre) (\(livre.libelleStatut))")
    }
    while true {
        guard let texte = lireLigne(invite) else { return nil }
        if texte == "0" { return nil }
        if let numero = Int(texte), numero >= 1, numero <= livres.count {
            return livres[numero - 1]
        }
        print("  Numéro invalide (0 pour annuler).")
    }
}

func choisirAdherent(_ invite: String) -> Adherent? {
    if adherents.isEmpty {
        print("  Aucun adhérent enregistré.")
        return nil
    }
    for (index, adherent) in adherents.enumerated() {
        print("  \(index + 1). \(adherent.nom) (\(adherent.livresEmpruntes.count)/\(Adherent.nombreMaximumEmprunts) livres)")
    }
    while true {
        guard let texte = lireLigne(invite) else { return nil }
        if texte == "0" { return nil }
        if let numero = Int(texte), numero >= 1, numero <= adherents.count {
            return adherents[numero - 1]
        }
        print("  Numéro invalide (0 pour annuler).")
    }
}

func actionAjouterLivrePapier() {
    print("-- Nouveau livre papier --")
    guard let titre = lireTexteObligatoire("Titre"),
          let auteur = lireTexteObligatoire("Auteur"),
          let pages = lireEntierPositif("Nombre de pages") else { return }
    bibliotheque.ajouterLivre(LivrePapier(titre: titre, auteur: auteur, nombrePages: pages))
}

func actionAjouterLivreNumerique() {
    print("-- Nouveau livre numérique --")
    guard let titre = lireTexteObligatoire("Titre"),
          let auteur = lireTexteObligatoire("Auteur"),
          let taille = lireDecimalPositif("Taille du fichier en Mo") else { return }
    bibliotheque.ajouterLivre(LivreNumerique(titre: titre, auteur: auteur, tailleFichierMo: taille))
}

func actionEnregistrerAdherent() {
    print("-- Nouvel adhérent --")
    guard let nom = lireTexteObligatoire("Nom de l'adhérent") else { return }
    if adherents.contains(where: { $0.nom.caseInsensitiveCompare(nom) == .orderedSame }) {
        print("  Un adhérent portant ce nom existe déjà.")
        return
    }
    adherents.append(Adherent(nom: nom))
    print("Adhérent « \(nom) » enregistré (\(adherents.count) adhérent(s)).")
}

func actionEmprunter() {
    print("-- Emprunt --")
    guard let adherent = choisirAdherent("Numéro de l'adhérent (0 pour annuler)") else { return }
    guard let livre = choisirLivre("Numéro du livre (0 pour annuler)") else { return }
    adherent.emprunterLivre(livre)
}

func actionRetourner() {
    print("-- Retour --")
    guard let adherent = choisirAdherent("Numéro de l'adhérent (0 pour annuler)") else { return }
    if adherent.livresEmpruntes.isEmpty {
        print("  Cet adhérent n'a aucun livre à rendre.")
        return
    }
    print("Livres empruntés par \(adherent.nom) :")
    for (index, livre) in adherent.livresEmpruntes.enumerated() {
        print("  \(index + 1). \(livre.titre)")
    }
    guard let texte = lireLigne("Numéro du livre à rendre (0 pour annuler)") else { return }
    if let numero = Int(texte), numero >= 1, numero <= adherent.livresEmpruntes.count {
        adherent.retournerLivre(adherent.livresEmpruntes[numero - 1])
    } else if texte != "0" {
        print("  Numéro invalide.")
    }
}

func actionRechercher() {
    guard let titre = lireTexteObligatoire("Titre recherché (une partie suffit)") else { return }
    if let livre = bibliotheque.rechercherLivre(titre: titre) {
        livre.afficherInformations()
    } else {
        print("  Aucun livre trouvé pour « \(titre) ».")
    }
}

func afficherMenu() {
    print("")
    print("========== MENU - Bibliothèque CHCL ==========")
    print("1. Ajouter un livre papier")
    print("2. Ajouter un livre numérique")
    print("3. Enregistrer un adhérent")
    print("4. Emprunter un livre")
    print("5. Retourner un livre")
    print("6. Afficher le catalogue")
    print("7. Afficher les emprunts d'un adhérent")
    print("8. Rechercher un livre par titre")
    print("9. Lancer le scénario de tests automatiques")
    print("0. Quitter")
}

var continuer = true
while continuer {
    afficherMenu()
    guard let choix = lireLigne("Votre choix") else {
        break
    }
    switch choix {
    case "1": actionAjouterLivrePapier()
    case "2": actionAjouterLivreNumerique()
    case "3": actionEnregistrerAdherent()
    case "4": actionEmprunter()
    case "5": actionRetourner()
    case "6": bibliotheque.afficherCatalogue()
    case "7":
        if let adherent = choisirAdherent("Numéro de l'adhérent (0 pour annuler)") {
            adherent.afficherEmprunts()
        }
    case "8": actionRechercher()
    case "9": lancerScenarioDeTests()
    case "0": continuer = false
    default: print("Choix invalide.")
    }
}

print("Au revoir.")
