import Foundation

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
