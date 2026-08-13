import Jobs
import NewsletterBackend

struct JobNewsletterMailQueue: NewsletterMailQueue {
    let queue: any JobQueueProtocol

    func enqueue(
        mailFrom: String,
        mailTo: String,
        subject: String,
        additionalHeaders: String,
        messageBody: String,
        deliveryIssueId: String?,
        deliveryNewsletterId: String?
    ) async throws {
        try await queue.enqueueSubmissionMail(
            mailFrom: mailFrom,
            mailTo: mailTo,
            subject: subject,
            additionalHeaders: additionalHeaders,
            messageBody: messageBody,
            deliveryIssueId: deliveryIssueId,
            deliveryNewsletterId: deliveryNewsletterId
        )
    }
}
