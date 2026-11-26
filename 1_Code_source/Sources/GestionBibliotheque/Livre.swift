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
