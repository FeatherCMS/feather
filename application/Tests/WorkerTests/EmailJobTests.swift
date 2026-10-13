import FeatherInfrastructure
import FeatherMail
import FeatherMailEphemeral
import Testing

@testable import Worker

@Suite
struct EmailJobTests {

    @Test
    func sendsGenericEmail() async throws {
        let mailbox = EphemeralMailbox()
        let mailClient = MailClientEphemeral(mailbox: mailbox)

        try await SendMailJobHandler.handle(
            parameters: .init(
                from: "sender@example.com",
                to: ["recipient@example.com"],
                subject: "Test subject",
                additionalHeaders: [],
                body: "Test message",
                contentType: .plainText
            ),
            mailClient: mailClient
        )

        let messages = await mailbox.getMessages()
        #expect(messages.count == 1)
        guard let message = messages.first else {
            Issue.record("Generic email was not delivered")
            return
        }
        #expect(message.from.email == "sender@example.com")
        #expect(message.to.map(\.email) == ["recipient@example.com"])
        #expect(message.subject == "Test subject")
        if case let .plainText(body) = message.body {
            #expect(body == "Test message")
        }
        else {
            Issue.record("Generic email body was not plain text")
        }
    }

    @Test
    func sendsContactFormEmailWithHeaders() async throws {
        let mailbox = EphemeralMailbox()
        let mailClient = MailClientEphemeral(mailbox: mailbox)

        try await SendMailJobHandler.handle(
            parameters: .init(
                from: "sender@example.com",
                to: ["recipient@example.com"],
                subject: "Contact subject",
                additionalHeaders: [
                    "CC: cc@example.com",
                    "BCC: bcc@example.com",
                    "Reply-To: reply@example.com",
                ],
                body: "<p>Contact message</p>",
                contentType: .html
            ),
            mailClient: mailClient
        )

        let messages = await mailbox.getMessages()
        #expect(messages.count == 1)
        guard let message = messages.first else {
            Issue.record("Contact-form email was not delivered")
            return
        }
        #expect(message.from.email == "sender@example.com")
        #expect(message.to.map(\.email) == ["recipient@example.com"])
        #expect(message.cc.map(\.email) == ["cc@example.com"])
        #expect(message.bcc.map(\.email) == ["bcc@example.com"])
        #expect(message.replyTo.map(\.email) == ["reply@example.com"])
        #expect(message.subject == "Contact subject")
        if case let .html(body) = message.body {
            #expect(body == "<p>Contact message</p>")
        }
        else {
            Issue.record("Contact-form email body was not HTML")
        }
    }
}
