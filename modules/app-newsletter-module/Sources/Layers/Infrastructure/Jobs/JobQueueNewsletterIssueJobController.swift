public import FeatherInfrastructure
public import FeatherMail
public import Jobs
public import FeatherApplication
public import NewsletterApplication
public import struct Foundation.Date

public struct JobQueueNewsletterIssueJobController: NewsletterIssueJobController {
    public let queue: any JobQueueProtocol
    public let mailJobs: any SendMailJobController

    public init(
        queue: any JobQueueProtocol,
        mailJobs: any SendMailJobController
    ) {
        self.queue = queue
        self.mailJobs = mailJobs
    }

    public static func register(
        on queue: some JobQueueProtocol,
        databaseContext: DatabaseClientContext,
        mailClient: any MailClient
    ) {
        SendNewsletterIssueJobHandler.register(
            on: queue,
            databaseContext: databaseContext,
            mailClient: mailClient
        )
    }

    public func enqueueIssue(
        mail: Mail,
        issueId: String,
        newsletterId: String,
        scheduledAt: Date?
    ) async throws {
        try await queue.push(
            SendNewsletterIssueJobParameter(
                mail: makeParameters(for: mail),
                issueId: issueId,
                newsletterId: newsletterId
            ),
            scheduledAt: scheduledAt
        )
    }

    public func enqueue(_ mail: Mail) async throws {
        try await mailJobs.enqueue(mail)
    }

    private func makeParameters(for mail: Mail) -> SendMailJobParameters {
        let body: (value: String, contentType: SendMailJobParameters.ContentType)
        switch mail.body {
        case .plainText(let value):
            body = (value, .plainText)
        case .html(let value):
            body = (value, .html)
        }
        return SendMailJobParameters(
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
    }

}
