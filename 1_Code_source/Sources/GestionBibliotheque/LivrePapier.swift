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
