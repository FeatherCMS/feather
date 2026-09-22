import FeatherContracts

struct NewsletterCampaignAddForm: Decodable {
    var name: String = ""
    var fromEmail: String = ""

    var normalizedName: String {
        name.whitespaceTrimmed
    }

    var normalizedFromEmail: String {
        fromEmail.whitespaceTrimmed
    }
}
