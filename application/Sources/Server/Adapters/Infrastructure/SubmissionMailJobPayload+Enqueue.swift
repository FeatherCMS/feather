import Environment
import Jobs

extension JobQueueProtocol {
    func enqueueSubmissionMail(
        mailFrom: String,
        mailTo: String,
        subject: String,
        additionalHeaders: String,
        messageBody: String,
        deliveryIssueId: String? = nil,
        deliveryNewsletterId: String? = nil
    ) async throws {
        _ = try await push(
            .init(SubmissionMailJobPayload.jobName),
            parameters: SubmissionMailJobPayload(
                mailFrom: mailFrom,
                mailTo: mailTo,
                subject: subject,
                additionalHeaders: additionalHeaders,
                messageBody: messageBody,
                deliveryIssueId: deliveryIssueId,
                deliveryNewsletterId: deliveryNewsletterId
            )
        )
    }
}
