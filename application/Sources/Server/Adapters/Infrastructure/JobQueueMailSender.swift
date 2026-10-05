import FeatherApplication
import Environment
import Jobs

struct JobQueueMailSender: MailSender {
    let queue: any JobQueueProtocol

    func send(
        _ message: MailMessage
    ) async throws {
        try await queue.push(
            EmailJobPayload(
                to: message.to.map(\.email),
                from: message.from.email,
                subject: message.subject,
                message: message.body
            )
        )
    }
}
