import Environment
import Jobs

extension JobQueueProtocol {
    func enqueueContactFormMail(
        mailFrom: String,
        mailTo: String,
        subject: String,
        additionalHeaders: String,
        messageBody: String
    ) async throws {
        _ = try await push(
            .init(ContactFormMailJobPayload.jobName),
            parameters: ContactFormMailJobPayload(
                mailFrom: mailFrom,
                mailTo: mailTo,
                subject: subject,
                additionalHeaders: additionalHeaders,
                messageBody: messageBody
            )
        )
    }
}
