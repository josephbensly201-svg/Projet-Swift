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
