import Environment
import Jobs
import struct Foundation.Date

extension JobQueueProtocol {
    func enqueueSubmissionMail(
        mailFrom: String,
        mailTo: String,
        subject: String,
        additionalHeaders: [String],
        messageBody: String,
        deliveryIssueId: String? = nil,
        deliveryNewsletterId: String? = nil,
        scheduledAt: Date? = nil
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
            ),
            options: .init(delayUntil: scheduledAt ?? .now)
        )
    }
}
