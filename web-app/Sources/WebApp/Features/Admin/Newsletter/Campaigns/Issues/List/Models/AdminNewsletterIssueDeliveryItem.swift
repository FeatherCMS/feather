struct AdminNewsletterIssueDeliveryItem: Sendable {
    let issueSubject: String
    let subscriberEmail: String
    let status: String
    let sentAt: String
    let failureReason: String
}
