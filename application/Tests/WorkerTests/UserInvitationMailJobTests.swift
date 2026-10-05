import Environment
import FeatherInfrastructure
import FeatherMail
import FeatherMailEphemeral
import Testing

@testable import Worker

@Suite
struct UserInvitationMailJobTests {

    @Test
    func sendsInvitationMailToPayloadEmail() async throws {
        let mailbox = EphemeralMailbox()
        let mailClient = MailClientEphemeral(mailbox: mailbox)

        try await SendMailJobHandler.handle(
            parameters: .init(
                from: "info@binarybirds.com",
                to: ["invitee@example.com"],
                subject: "Application - Invitation",
                additionalHeaders: [],
                body: "Use invitation token: invitation-token-123",
                contentType: .plainText
            ),
            mailClient: mailClient
        )

        let messages = await mailbox.getMessages()
        #expect(messages.count == 1)
        guard let message = messages.first else {
            Issue.record("Invitation mail was not delivered")
            return
        }
        #expect(message.to.first?.email == "invitee@example.com")
        #expect(message.subject == "Application - Invitation")
        if case let .plainText(body) = message.body {
            #expect(body.contains("invitation-token-123"))
        }
        else {
            Issue.record("Invitation mail body was not plain text")
        }
    }

    @Test
    func rejectsInvalidRecipientWithoutSending() async throws {
        let mailbox = EphemeralMailbox()
        let mailClient = MailClientEphemeral(mailbox: mailbox)

        await #expect(throws: MailError.self) {
            try await SendMailJobHandler.handle(
                parameters: .init(
                    from: "info@binarybirds.com",
                    to: [""],
                    subject: "Application - Invitation",
                    additionalHeaders: [],
                    body: "Use invitation token: invitation-token-123",
                    contentType: .plainText
                ),
                mailClient: mailClient
            )
        }

        #expect(await mailbox.getMessages().isEmpty)
    }
}
