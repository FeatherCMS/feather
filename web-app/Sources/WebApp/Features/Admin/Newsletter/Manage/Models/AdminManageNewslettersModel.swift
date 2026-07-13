struct AdminManageNewsletterItem: Sendable {
    let id: String
    let name: String
}

struct NewsletterEditForm: Decodable {
    let name: String
}
