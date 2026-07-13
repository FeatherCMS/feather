struct ContactNewsletterAddForm: Decodable {
    var name: String = ""

    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
