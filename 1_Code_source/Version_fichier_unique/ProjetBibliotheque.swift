import Foundation

class Livre {
    let titre: String
    let auteur: String
    private(set) var estDisponible: Bool

    var libelleStatut: String {
        return estDisponible ? "Disponible" : "Emprunté"
    }

    init(titre: String, auteur: String) {
        self.titre = titre
        self.auteur = auteur
        self.estDisponible = true
    }

    func afficherInformations() {
        print("- Titre : \(titre) | Auteur : \(auteur) | Statut : \(libelleStatut)")
    }

    // Renvoie false si le livre est déjà emprunté
    @discardableResult
    func emprunter() -> Bool {
        guard estDisponible else {
            return false
        }
        estDisponible = false
        return true
    }

    // Renvoie false si le livre n'était pas emprunté
    @discardableResult
    func retourner() -> Bool {
        guard !estDisponible else {
            return false
        }
        estDisponible = true
        return true
    }
}

final class LivrePapier: Livre {
    let nombrePages: Int

    init(titre: String, auteur: String, nombrePages: Int) {
        self.nombrePages = nombrePages
        super.init(titre: titre, auteur: auteur)
    }

    override func afficherInformations() {
        super.afficherInformations()
        print("  Type : Livre papier | Nombre de pages : \(nombrePages)")
    }
}

final class LivreNumerique: Livre {
    let tailleFichierMo: Double

    init(titre: String, auteur: String, tailleFichierMo: Double) {
        self.tailleFichierMo = tailleFichierMo
        super.init(titre: titre, auteur: auteur)
    }

    override func afficherInformations() {
        super.afficherInformations()
        print("  Type : Livre numérique | Taille du fichier : \(tailleFichierMo) Mo")
    }
}

class Adherent {
    static let nombreMaximumEmprunts = 3

    let nom: String
    private(set) var livresEmpruntes: [Livre] = []

    init(nom: String) {
        self.nom = nom
    }

    @discardableResult
    func emprunterLivre(_ livre: Livre) -> Bool {
        if livresEmpruntes.contains(where: { $0 === livre }) {
            print("Refusé : \(nom) a déjà emprunté « \(livre.titre) ».")
            return false
        }

        guard livresEmpruntes.count < Adherent.nombreMaximumEmprunts else {
            print("Refusé : \(nom) a atteint la limite de \(Adherent.nombreMaximumEmprunts) livres empruntés.")
            return false
        }

        guard livre.emprunter() else {
            print("Refusé : « \(livre.titre) » n'est pas disponible (déjà emprunté).")
            return false
        }

        livresEmpruntes.append(livre)
        print("Succès : \(nom) a emprunté « \(livre.titre) ».")
        return true
    }

    @discardableResult
    func retournerLivre(_ livre: Livre) -> Bool {
        guard let position = livresEmpruntes.firstIndex(where: { $0 === livre }) else {
            print("Refusé : \(nom) n'a pas emprunté « \(livre.titre) ».")
            return false
        }

        livre.retourner()
        livresEmpruntes.remove(at: position)
        print("Succès : \(nom) a retourné « \(livre.titre) ».")
        return true
    }

    func afficherEmprunts() {
        print("Livres empruntés par \(nom) (\(livresEmpruntes.count)/\(Adherent.nombreMaximumEmprunts)) :")

        if livresEmpruntes.isEmpty {
            print("  Aucun livre emprunté.")
            return
        }

        for livre in livresEmpruntes {
            livre.afficherInformations()
        }
    }
}

class Bibliotheque {
    let nom: String
    private(set) var livres: [Livre] = []

    init(nom: String) {
        self.nom = nom
    }

    func ajouterLivre(_ livre: Livre) {
        if livres.contains(where: { $0 === livre }) {
            print("Information : « \(livre.titre) » est déjà dans le catalogue.")
            return
        }
        livres.append(livre)
        print("Livre ajouté : « \(livre.titre) » (\(livres.count) au catalogue).")
    }

    func afficherCatalogue() {
        let mot = livres.count > 1 ? "livres" : "livre"
        print("Catalogue de la bibliothèque \(nom) (\(livres.count) \(mot)) :")

        if livres.isEmpty {
            print("  Le catalogue est vide.")
            return
        }

        for livre in livres {
            livre.afficherInformations()
        }
    }

    // Ignore les majuscules et les accents, une partie du titre suffit
    func rechercherLivre(titre: String) -> Livre? {
        return livres.first(where: { livre in
            livre.titre.range(of: titre, options: [.caseInsensitive, .diacriticInsensitive]) != nil
        })
    }
}

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
