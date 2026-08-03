//
//  File.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 04. 18..
//

import FeatherMail
import FeatherDatabase
import Environment
import Foundation
import Jobs
import NewsletterDomain
import NewsletterInfrastructure

struct EmailService {
    let client: any MailClient

    func sendEmail(
        to: [String],
        from: String,
        subject: String,
        message: String
    ) async throws {
        try await client.send(
            .init(
                from: .init(from),
                to: to.map { .init($0) },
                subject: subject,
                body: .plainText(message)
            )
        )
    }

    func sendContactFormEmail(
        to: String,
        from: String,
        subject: String,
        additionalHeaders: String,
        message: String
    ) async throws {
        let headers = parseHeaders(additionalHeaders)
        try await client.send(
            .init(
                from: .init(from),
                to: [.init(to)],
                cc: headers["cc", default: []].map { .init($0) },
                bcc: headers["bcc", default: []].map { .init($0) },
                replyTo: headers["reply-to", default: []].map { .init($0) },
                subject: subject,
                body: .html(message)
            )
        )
    }

    private func parseHeaders(_ value: String) -> [String: [String]] {
        value.split(whereSeparator: \.isNewline)
            .reduce(into: [:]) { result, line in
                let parts = line.split(separator: ":", maxSplits: 1)
                    .map(String.init)
                guard parts.count == 2 else { return }
                let key = parts[0]
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .lowercased()
                guard ["cc", "bcc", "reply-to"].contains(key) else { return }
                result[key, default: []] += parts[1]
                    .split(separator: ",")
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            }
    }
}

struct JobController {
    // parameters required to run email job
    struct EmailParameters: JobParameters {
        static let jobName = "send_email"
        let to: [String]
        let from: String
        let subject: String
        let message: String
    }

    init(
        queue: some JobQueueProtocol,
        emailService: EmailService,
        database: any DatabaseClient
    ) {
        // This function demonstrates two different ways to register a job
        // Register Job with predefined job identifier
        queue.registerJob(parameters: EmailParameters.self) {
            parameters,
            context in
            try await emailService.sendEmail(
                to: parameters.to,
                from: parameters.from,
                subject: parameters.subject,
                message: parameters.message
            )
        }
        queue.registerJob(
            name: .init(UserInvitationMailJobPayload.jobName),
            parameters: UserInvitationMailJobPayload.self,
            retryStrategy: .exponentialJitter(maxAttempts: 5)
        ) { parameters, _ in
            try await UserInvitationMailJob.send(
                parameters: parameters,
                emailService: emailService
            )
        }
        queue.registerJob(
            name: .init(ContactFormMailJobPayload.jobName),
            parameters: ContactFormMailJobPayload.self,
            retryStrategy: .exponentialJitter(maxAttempts: 5)
        ) {
            parameters,
            _ in
            do {
                try await emailService.sendContactFormEmail(
                    to: parameters.mailTo,
                    from: parameters.mailFrom,
                    subject: parameters.subject,
                    additionalHeaders: parameters.additionalHeaders,
                    message: parameters.messageBody
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

    private static func updateNewsletterDelivery(
        database: any DatabaseClient,
        parameters: ContactFormMailJobPayload,
        status: NewsletterCampaignDelivery.Status,
        failureReason: String?
    ) async throws {
        guard let issueId = parameters.deliveryIssueId else { return }
        try await database.withConnection { connection in
            let repository = DatabaseNewsletterCampaignDeliveryRepository(
                connection: connection
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
