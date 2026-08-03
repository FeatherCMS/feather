import Environment
import FeatherMail
import FeatherMailEphemeral
import Testing

@testable import Worker

@Suite
struct UserInvitationMailJobTests {

    @Test
    func sendsInvitationMailToPayloadEmail() async throws {
        let mailbox = EphemeralMailbox()
        let client = MailClientEphemeral(mailbox: mailbox)
        let service = EmailService(client: client)

        try await UserInvitationMailJob.send(
            parameters: .init(
                email: "invitee@example.com",
                token: "invitation-token-123"
            ),
            emailService: service
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
        } else {
            Issue.record("Invitation mail body was not plain text")
        }
    }

    @Test
    func rejectsInvalidRecipientWithoutSending() async throws {
        let mailbox = EphemeralMailbox()
        let client = MailClientEphemeral(mailbox: mailbox)
        let service = EmailService(client: client)

        await #expect(throws: MailError.self) {
            try await UserInvitationMailJob.send(
                parameters: .init(
                    email: "",
                    token: "invitation-token-123"
                ),
                emailService: service
            )
        }

        #expect(await mailbox.getMessages().isEmpty)
    }
}
