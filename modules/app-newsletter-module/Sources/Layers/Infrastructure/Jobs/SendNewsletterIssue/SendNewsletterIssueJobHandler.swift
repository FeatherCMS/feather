import FeatherDBAL
import FeatherDatabase
public import FeatherInfrastructure
public import FeatherMail
public import Foundation
public import Jobs
import NewsletterDomain
import NewsletterModule

public enum SendNewsletterIssueJobHandler {
    private static let maxAttempts = 5

    public static func register(
        on queue: some JobQueueProtocol,
        databaseContext: DatabaseClientContext,
        mailClient: any MailClient,
        publicBaseURL: URL
    ) {
        queue.registerJob(
            parameters: SendNewsletterIssueJobParameter.self,
            retryStrategy: .exponentialJitter(maxAttempts: maxAttempts)
        ) { parameters, context in
            try await handle(
                parameters: parameters,
                databaseContext: databaseContext,
                mailClient: mailClient,
                publicBaseURL: publicBaseURL,
                attempt: context.attempt
            )
        }
    }

    static func handle(
        parameters: SendNewsletterIssueJobParameter,
        databaseContext: DatabaseClientContext,
        mailClient: any MailClient,
        publicBaseURL: URL,
        attempt: Int = 1
    ) async throws {
        do {
            try await SendMailJobHandler.handle(
                parameters: makeMailParameters(
                    parameters: parameters,
                    publicBaseURL: publicBaseURL
                ),
                mailClient: mailClient
            )
            try await updateNewsletterDelivery(
                databaseContext: databaseContext,
                parameters: parameters,
                status: .sent,
                failureReason: nil
            )
        }
        catch {
            try? await updateNewsletterDelivery(
                databaseContext: databaseContext,
                parameters: parameters,
                status: attempt < maxAttempts ? .pending : .failed,
                failureReason: deliveryFailureReason(for: error)
            )
            throw error
        }
    }

    static func makeMailParameters(
        parameters: SendNewsletterIssueJobParameter,
        publicBaseURL: URL
    ) -> SendMailJobParameters {
        guard let unsubscribeToken = parameters.unsubscribeToken else {
            return parameters.mail
        }
        let unsubscribeURL =
            publicBaseURL
            .appending(path: "newsletter")
            .appending(path: "unsubscribe")
            .appending(path: unsubscribeToken)
        let url = unsubscribeURL.absoluteString
        return SendMailJobParameters(
            from: parameters.mail.from,
            to: parameters.mail.to,
            subject: parameters.mail.subject,
            additionalHeaders: parameters.mail.additionalHeaders + [
                "List-Unsubscribe: <\(url)>",
                "List-Unsubscribe-Post: List-Unsubscribe=One-Click",
            ],
            body: parameters.mail.body
                + "\n\n<p>To stop receiving these emails, <a href=\"\(url)\">unsubscribe</a>.</p>",
            contentType: parameters.mail.contentType
        )
    }

    private static func deliveryFailureReason(for error: any Error) -> String {
        let description = String(describing: error)
        guard description.contains("MessageRejected") else {
            return description
        }
        return
            "Amazon SES rejected the message. Verify the sender identity and sending permissions in the configured SES region."
    }

    private static func updateNewsletterDelivery(
        databaseContext: DatabaseClientContext,
        parameters: SendNewsletterIssueJobParameter,
        status: Delivery.Model.Status,
        failureReason: String?
    ) async throws {
        try await databaseContext.database.withConnection { connection in
            guard let subscriberEmail = parameters.mail.to.first else {
                return
            }
            let context = DatabaseTransactionContext(
                platform: databaseContext.platform,
                connection: connection,
                idGenerator: databaseContext.idGenerator
            )
            let repository = Delivery.Repository.Database(
                context: context
            )
            guard
                var delivery = try await repository.findBy(
                    issueId: parameters.issueId,
                    subscriberEmail: subscriberEmail
                )
            else {
                return
            }
            delivery.status = status
            delivery.sentDate = status == .sent ? Date() : nil
            delivery.failureReason = failureReason
            _ = try await repository.update(delivery)

            let deliveries = try await repository.list(
                issueId: parameters.issueId
            )
            guard !deliveries.isEmpty else { return }

            guard
                var issue = try await Issue.Repository.Database(
                    context: context
                ).findBy(id: parameters.issueId)
            else {
                return
            }
            if deliveries.contains(where: { $0.status == .pending }) {
                issue.status = .sending
                issue.sentDate = nil
            }
            else {
                issue.status = deliveries.contains {
                    $0.status == .failed || $0.status == .bounced
                } ? .failed : .sent
                issue.sentDate = issue.status == .sent ? Date() : nil
            }
            _ = try await Issue.Repository.Database(context: context).update(
                issue
            )
        }
    }
}
