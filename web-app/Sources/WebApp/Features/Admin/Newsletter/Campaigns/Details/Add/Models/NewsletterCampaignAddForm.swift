struct NewsletterCampaignAddForm: Decodable {
    var name: String = ""
    var fromEmail: String = ""

    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var normalizedFromEmail: String {
        fromEmail.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
