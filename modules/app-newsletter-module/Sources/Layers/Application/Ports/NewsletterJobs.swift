public import struct Foundation.Date

public protocol NewsletterJobs: Sendable {
    func enqueue(
        mailFrom: String,
        mailTo: String,
        subject: String,
        additionalHeaders: [String],
        messageBody: String,
        deliveryIssueId: String?,
        deliveryNewsletterId: String?,
        scheduledAt: Date?
    ) async throws
}
