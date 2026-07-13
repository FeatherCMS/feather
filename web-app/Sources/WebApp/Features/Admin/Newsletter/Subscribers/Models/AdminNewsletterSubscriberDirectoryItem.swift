struct AdminNewsletterSubscriberDirectoryItem: Sendable {
    let email: String
    let name: String
    let newsletters: [NewsletterSubscriberDirectoryNewsletter]
}

struct NewsletterSubscriberDirectoryNewsletter: Sendable {
    let id: String
    let name: String
    let status: String
}
