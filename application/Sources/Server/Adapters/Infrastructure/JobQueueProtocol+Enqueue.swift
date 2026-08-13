import FeatherApplication
import Environment
import Jobs

extension JobQueueProtocol {

    func enqueueEmail(
        _ message: MailMessage
    ) async throws {
        try await push(
            EmailJobPayload(
                to: message.to.map(\.email),
                from: message.from.email,
                subject: message.subject,
                message: message.body
            )
        )
    }

    func enqueueMediaGenerateVariant(
        assetId: String,
        processorId: String
    ) async throws {
        _ = try await push(
            .init(MediaGenerateVariantJobPayload.jobName),
            parameters: MediaGenerateVariantJobPayload(
                assetId: assetId,
                processorId: processorId
            )
        )
    }
}

struct JobQueueMailSender: MailSender {
    let queue: any JobQueueProtocol

    func send(
        _ message: MailMessage
    ) async throws {
        try await queue.enqueueEmail(message)
    }
}
