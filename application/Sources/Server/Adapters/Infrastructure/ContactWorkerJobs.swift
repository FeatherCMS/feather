import ContactApplication
import Environment
import Jobs

struct ContactWorkerJobs: ContactJobs {
    let queue: any JobQueueProtocol

    func enqueueSubmissionMail(
        mailFrom: String,
        mailTo: String,
        subject: String,
        additionalHeaders: [String],
        messageBody: String
    ) async throws {
        try await SubmissionMailJobPayload.enqueue(
            on: queue,
            mailFrom: mailFrom,
            mailTo: mailTo,
            subject: subject,
            additionalHeaders: additionalHeaders,
            messageBody: messageBody
        )
    }
}
