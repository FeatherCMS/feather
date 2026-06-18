import Application
import FeatherMail

struct FeatherMailSender: MailSender {

    let client: any MailClient

    func send(
        _ message: MailMessage
    ) async throws {
        try await client.send(
            .init(
                from: .init(
                    message.from.email,
                    name: message.from.name
                ),
                to: message.to.map {
                    .init($0.email, name: $0.name)
                },
                subject: message.subject,
                body: .plainText(message.body)
            )
        )
    }
}
