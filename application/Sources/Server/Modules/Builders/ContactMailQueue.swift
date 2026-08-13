import ContactBackend
import Jobs

struct JobContactMailQueue: ContactMailQueue {
    let queue: any JobQueueProtocol

    func enqueue(
        mailFrom: String,
        mailTo: String,
        subject: String,
        additionalHeaders: String,
        messageBody: String
    ) async throws {
        try await queue.enqueueSubmissionMail(
            mailFrom: mailFrom,
            mailTo: mailTo,
            subject: subject,
            additionalHeaders: additionalHeaders,
            messageBody: messageBody
        )
    }
}
