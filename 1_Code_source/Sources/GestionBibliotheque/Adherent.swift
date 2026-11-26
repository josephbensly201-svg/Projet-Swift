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
