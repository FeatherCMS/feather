struct AdminManageNewsletterSubscriberItem: Sendable {
    let id: String
    let email: String
    let firstName: String
    let lastName: String
    let status: String
}

struct NewsletterSubscriberForm: Decodable {
    let email: String
    let firstName: String
    let lastName: String
    let status: String
}
