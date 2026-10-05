import Environment
import Jobs
import NewsletterApplication
import struct Foundation.Date

struct NewsletterWorkerJobs: NewsletterJobs {
    let queue: any JobQueueProtocol

    func enqueue(
        mailFrom: String,
        mailTo: String,
        subject: String,
        additionalHeaders: [String],
        messageBody: String,
        deliveryIssueId: String?,
        deliveryNewsletterId: String?,
        scheduledAt: Date?
    ) async throws {
        try await SubmissionMailJobPayload.enqueue(
            on: queue,
            mailFrom: mailFrom,
            mailTo: mailTo,
            subject: subject,
            additionalHeaders: additionalHeaders,
            messageBody: messageBody,
            deliveryIssueId: deliveryIssueId,
            deliveryNewsletterId: deliveryNewsletterId,
            scheduledAt: scheduledAt
        )
    }
}
