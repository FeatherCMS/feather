struct AdminAddNewsletterIssueModel: Sendable {
    let subject: String
    let content: String
    let scheduledAt: String
    let newsletterId: String
    let error: String?
}
