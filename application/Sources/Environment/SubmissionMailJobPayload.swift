public struct SubmissionMailJobPayload: Codable, Sendable {
    public static let jobName = "send_contact_form_email"

    public let mailFrom: String
    public let mailTo: String
    public let subject: String
    public let additionalHeaders: String
    public let messageBody: String
    public let deliveryIssueId: String?
    public let deliveryNewsletterId: String?

    public init(
        mailFrom: String,
        mailTo: String,
        subject: String,
        additionalHeaders: String,
        messageBody: String,
        deliveryIssueId: String? = nil,
        deliveryNewsletterId: String? = nil
    ) {
        self.mailFrom = mailFrom
        self.mailTo = mailTo
        self.subject = subject
        self.additionalHeaders = additionalHeaders
        self.messageBody = messageBody
        self.deliveryIssueId = deliveryIssueId
        self.deliveryNewsletterId = deliveryNewsletterId
    }
}
