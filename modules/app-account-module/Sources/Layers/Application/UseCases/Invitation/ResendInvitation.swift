import AccountContracts
import AccountDomain
import FeatherApplication
import FeatherContracts
import SystemApplication

import struct Foundation.Date

public struct ResendInvitation: UseCase {
    struct Action: PermissionAction {
        let key = AccountPermissions.Invitations.create
    }

    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteInvitationOnlyWithVariable>
    let mailSender: any MailSender

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteInvitationOnlyWithVariable>,
        mailSender: any MailSender
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.mailSender = mailSender
    }

    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> InvitationDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let result = try await transaction.run { scope in
            guard
                var invitation = try await scope.invitation.findBy(id: input.id)
            else {
                throw Error(message: "Invitation not found")
            }
            try invitation.renew(
                token: generateToken(),
                expiresAt: Date().addingTimeInterval(Invitation.lifetime)
            )
            guard
                let publicBaseURL = try await scope.variable.get(
                    "web-settings-public-base-url"
                ),
                !publicBaseURL.isEmpty
            else {
                throw Error(message: "The public site URL is not configured.")
            }
            return (
                invitation: try await scope.invitation.update(invitation),
                publicBaseURL: publicBaseURL
            )
        }

        try await mailSender.send(
            .init(
                from: .init("info@binarybirds.com"),
                to: [.init(result.invitation.email)],
                subject: "Application - Invitation",
                body: """
                    Hello,

                    This is a reminder for your application identity invitation.
                    Open this invitation link to complete registration:

                    \(result.publicBaseURL)/account/invitation/accept/?token=\(result.invitation.token)

                    Cheers,
                    Application Team.
                    """
            )
        )
        return result.invitation.asDetail
    }
}
