public import FeatherMail
import Foundation
public import Jobs
import Logging

public enum SendMailJobHandler {

    public static func register(
        on queue: some JobQueueProtocol,
        mailClient: any MailClient
    ) {
        queue.registerJob(
            parameters: SendMailJobParameters.self,
            retryStrategy: .exponentialJitter(maxAttempts: 5)
        ) { parameters, context in
            do {
                try await handle(
                    parameters: parameters,
                    mailClient: mailClient
                )
            }
            catch {
                context.logger.error(
                    "Mail delivery failed",
                    metadata: [
                        "jobID": .string(context.jobID),
                        "attempt": .string(String(context.attempt)),
                        "error": .string(String(describing: error)),
                    ]
                )
                throw error
            }
        }
    }

    public static func handle(
        parameters: SendMailJobParameters,
        mailClient: any MailClient
    ) async throws {
        let headers = parseAddressHeaders(parameters.additionalHeaders)
        let customHeaders = parseCustomHeaders(parameters.additionalHeaders)
        let body: Body
        switch parameters.contentType {
        case .plainText:
            body = .plainText(parameters.body)
        case .html:
            body = .html(parameters.body)
        }
        try await mailClient.send(
            .init(
                from: .init(parameters.from, name: parameters.fromName),
                to: parameters.to.map { .init($0) },
                cc: headers["cc", default: []].map { .init($0) },
                bcc: headers["bcc", default: []].map { .init($0) },
                replyTo: headers["reply-to", default: []].map { .init($0) },
                subject: parameters.subject,
                body: body,
                customHeaders: customHeaders
            )
        )
    }

    private static func parseAddressHeaders(
        _ values: [String]
    ) -> [String: [String]] {
        values.reduce(into: [:]) { result, line in
            let parts = line.split(separator: ":", maxSplits: 1)
                .map(String.init)
            guard parts.count == 2 else { return }
            let key = parts[0]
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased()
            guard ["cc", "bcc", "reply-to"].contains(key) else { return }
            result[key, default: []] += parts[1]
                .split(separator: ",")
                .map {
                    $0.trimmingCharacters(in: .whitespacesAndNewlines)
                }
        }
    }

    private static func parseCustomHeaders(
        _ values: [String]
    ) -> [MailHeader] {
        values.compactMap { line in
            let parts = line.split(separator: ":", maxSplits: 1)
                .map(String.init)
            guard parts.count == 2 else { return nil }
            let name = parts[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let key = name.lowercased()
            guard
                ![
                    "cc", "bcc", "reply-to", "from", "to", "subject", "date",
                    "message-id", "content-type", "mime-version",
                ]
                .contains(key)
            else {
                return nil
            }
            return MailHeader(
                name: name,
                value: parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
            )
        }
    }
}
