import Environment

struct UserInvitationMailJob {

    static func send(
        parameters: UserInvitationMailJobPayload,
        emailService: EmailService
    ) async throws {
        try await emailService.sendEmail(
            to: [parameters.email],
            from: "info@binarybirds.com",
            subject: "Application - Invitation",
            message: #"""
                Hello,

                You have been invited to create your application account.
                Use this invitation token to complete registration:

                \#(parameters.token)

                Cheers,
                Application Team.
                """#
        )
    }
}
