import FeatherDatabase
public import FeatherInfrastructure
public import FeatherMail
import Foundation
public import Jobs
import NewsletterDomain

public enum SendNewsletterIssueJobHandler {

    public static func register(
        on queue: some JobQueueProtocol,
        databaseContext: DatabaseClientContext,
        mailClient: any MailClient
    ) {
        queue.registerJob(
            parameters: SendNewsletterIssueJobParameter.self,
            retryStrategy: .exponentialJitter(maxAttempts: 5)
        ) { parameters, _ in
            try await handle(
                parameters: parameters,
                databaseContext: databaseContext,
                mailClient: mailClient
            )
        }
    }

    private static func handle(
        parameters: SendNewsletterIssueJobParameter,
        databaseContext: DatabaseClientContext,
        mailClient: any MailClient
    ) async throws {
        do {
            try await SendMailJobHandler.handle(
                parameters: parameters.mail,
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
                status: .failed,
                failureReason: String(describing: error)
            )
            throw error
        }
    }

    private static func updateNewsletterDelivery(
        databaseContext: DatabaseClientContext,
        parameters: SendNewsletterIssueJobParameter,
        status: Delivery.Status,
        failureReason: String?
    ) async throws {
        try await databaseContext.database.withConnection { connection in
            guard let subscriberEmail = parameters.mail.to.first else {
                return
            }
            let repository = DeliveryDatabaseRepository(
                context: .init(
                    connection: connection,
                    idGenerator: databaseContext.idGenerator
                )
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
        }
    }
}
