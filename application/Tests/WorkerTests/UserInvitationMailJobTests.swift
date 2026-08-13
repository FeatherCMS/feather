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
        let service = EmailService(
            client: MailClientEphemeral(mailbox: mailbox)
        )

        try await JobController.sendEmail(
            parameters: .init(
                to: ["invitee@example.com"],
                from: "info@binarybirds.com",
                subject: "Application - Invitation",
                message: "Use invitation token: invitation-token-123"
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
        }
        else {
            Issue.record("Invitation mail body was not plain text")
        }
    }

    @Test
    func rejectsInvalidRecipientWithoutSending() async throws {
        let mailbox = EphemeralMailbox()
        let service = EmailService(
            client: MailClientEphemeral(mailbox: mailbox)
        )

        await #expect(throws: MailError.self) {
            try await JobController.sendEmail(
                parameters: .init(
                    to: [""],
                    from: "info@binarybirds.com",
                    subject: "Application - Invitation",
                    message: "Use invitation token: invitation-token-123"
                ),
                emailService: service
            )
        }

        #expect(await mailbox.getMessages().isEmpty)
    }
}
