struct AdminManageNewsletterSubscriberItem: Sendable {
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
