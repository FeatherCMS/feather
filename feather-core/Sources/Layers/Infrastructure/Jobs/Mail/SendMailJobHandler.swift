public import FeatherMail
import Foundation
public import Jobs

public enum SendMailJobHandler {

    public static func register(
        on queue: some JobQueueProtocol,
        mailClient: any MailClient
    ) {
        queue.registerJob(
            parameters: SendMailJobParameters.self,
            retryStrategy: .exponentialJitter(maxAttempts: 5)
        ) { parameters, _ in
            try await handle(
                parameters: parameters,
                mailClient: mailClient
            )
        }
    }

    public static func handle(
        parameters: SendMailJobParameters,
        mailClient: any MailClient
    ) async throws {
        let headers = parseHeaders(parameters.additionalHeaders)
        let body: Body
        switch parameters.contentType {
        case .plainText:
            body = .plainText(parameters.body)
        case .html:
            body = .html(parameters.body)
        }
        try await mailClient.send(
            .init(
                from: .init(parameters.from),
                to: parameters.to.map { .init($0) },
                cc: headers["cc", default: []].map { .init($0) },
                bcc: headers["bcc", default: []].map { .init($0) },
                replyTo: headers["reply-to", default: []].map { .init($0) },
                subject: parameters.subject,
                body: body
            )
        )
    }

    private static func parseHeaders(
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
}
