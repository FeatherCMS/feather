import FeatherContracts
import FeatherMail

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
        additionalHeaders: [String],
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

    private func parseHeaders(_ values: [String]) -> [String: [String]] {
        values.reduce(into: [:]) { result, line in
            let parts = line.split(separator: ":", maxSplits: 1)
                .map(String.init)
            guard parts.count == 2 else { return }
            let key = parts[0]
                .whitespaceTrimmed
                .lowercased()
            guard ["cc", "bcc", "reply-to"].contains(key) else { return }
            result[key, default: []] += parts[1]
                .split(separator: ",")
                .map { $0.whitespaceTrimmed }
        }
    }
}
