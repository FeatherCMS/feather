struct NewsletterIssueTestEmailForm: Decodable {
    let email: String
    let subject: String
    let content: String
}
