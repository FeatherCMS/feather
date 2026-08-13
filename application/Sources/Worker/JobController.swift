//
//  File.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 04. 18..
//

import FeatherMail
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
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
    init(
        queue: some JobQueueProtocol,
        emailService: EmailService,
        database: any DatabaseClient
    ) {
        // This function demonstrates two different ways to register a job
        // Register Job with predefined job identifier
        queue.registerJob(parameters: EmailJobPayload.self) {
            parameters,
            context in
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
