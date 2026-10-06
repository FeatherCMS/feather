public import FeatherApplication
public import FeatherMail
public import Jobs

public struct JobQueueSendMailJobController: SendMailJobController {
    public let queue: any JobQueueProtocol

    public init(queue: any JobQueueProtocol) {
        self.queue = queue
    }

    public func enqueue(_ mail: Mail) async throws {
        let body:
            (value: String, contentType: SendMailJobParameters.ContentType)
        switch mail.body {
        case .plainText(let value):
            body = (value, .plainText)
        case .html(let value):
            body = (value, .html)
        }
        try await queue.push(
            SendMailJobParameters(
                from: mail.from.email,
                to: mail.to.map(\.email),
                subject: mail.subject,
                additionalHeaders:
                    mail.cc.map { "Cc: \($0.email)" }
                    + mail.bcc.map { "Bcc: \($0.email)" }
                    + mail.replyTo.map { "Reply-To: \($0.email)" },
                body: body.value,
                contentType: body.contentType
            )
        )
    }

    public static func register(
        on queue: some JobQueueProtocol,
        mailClient: any MailClient
    ) {
        SendMailJobHandler.register(
            on: queue,
            mailClient: mailClient
        )
    }
}
