import FeatherDatabase
import FeatherInfrastructure
import Environment
import Foundation
import Jobs
import NewsletterDomain
import NewsletterInfrastructure

struct JobController {
    init(
        queue: some JobQueueProtocol,
        emailService: EmailService,
        database: any DatabaseClient
    ) {
        queue.registerJob(parameters: EmailJobPayload.self) {
            parameters,
            _ in
            try await Self.sendEmail(
                parameters: parameters,
                emailService: emailService
            )
        }
        queue.registerJob(
            name: .init(SubmissionMailJobPayload.jobName),
            parameters: SubmissionMailJobPayload.self,
            retryStrategy: .exponentialJitter(maxAttempts: 5)
        ) {
            parameters,
            _ in
            do {
                try await Self.sendContactFormEmail(
                    parameters: parameters,
                    emailService: emailService
                )
                try await Self.updateNewsletterDelivery(
                    database: database,
                    parameters: parameters,
                    status: .sent,
                    failureReason: nil
                )
            }
            catch {
                try? await Self.updateNewsletterDelivery(
                    database: database,
                    parameters: parameters,
                    status: .failed,
                    failureReason: String(describing: error)
                )
                throw error
            }
        }
    }

    static func sendEmail(
        parameters: EmailJobPayload,
        emailService: EmailService
    ) async throws {
        try await emailService.sendEmail(
            to: parameters.to,
            from: parameters.from,
            subject: parameters.subject,
            message: parameters.message
        )
    }

    static func sendContactFormEmail(
        parameters: SubmissionMailJobPayload,
        emailService: EmailService
    ) async throws {
        try await emailService.sendContactFormEmail(
            to: parameters.mailTo,
            from: parameters.mailFrom,
            subject: parameters.subject,
            additionalHeaders: parameters.additionalHeaders,
            message: parameters.messageBody
        )
    }

    private static func updateNewsletterDelivery(
        database: any DatabaseClient,
        parameters: SubmissionMailJobPayload,
        status: Delivery.Status,
        failureReason: String?
    ) async throws {
        guard let issueId = parameters.deliveryIssueId else { return }
        try await database.withConnection { connection in
            let repository = DeliveryDatabaseRepository(
                context: .init(
                    connection: connection,
                    idGenerator: NanoIDGenerator()
                )
            )
            guard
                var delivery = try await repository.findBy(
                    issueId: issueId,
                    subscriberEmail: parameters.mailTo
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
