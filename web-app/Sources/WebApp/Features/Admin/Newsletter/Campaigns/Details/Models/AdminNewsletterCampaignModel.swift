struct AdminNewsletterCampaignItem: Sendable {
    let id: String
    let name: String
    let fromEmail: String
}

struct NewsletterEditForm: Decodable {
    let name: String
    let fromEmail: String
}
