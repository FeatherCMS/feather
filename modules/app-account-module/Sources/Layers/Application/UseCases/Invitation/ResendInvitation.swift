import AccountContracts
import AccountDomain
import FeatherApplication
import FeatherContracts

import struct Foundation.Date

public struct ResendInvitation: UseCase {
    struct Action: PermissionAction {
        let key = AccountPermissions.Invitations.create
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteInvitationOnly>
    let mailSender: any MailSender
    let publicBaseURL: String

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteInvitationOnly>,
        mailSender: any MailSender,
        publicBaseURL: String
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.mailSender = mailSender
        self.publicBaseURL = publicBaseURL
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

        let invitation = try await transaction.run { scope in
            guard var invitation = try await scope.invitation.findBy(id: input.id)
            else {
                throw Error(message: "Invitation not found")
            }
            try invitation.renew(
                token: generateToken(),
                expiresAt: Date().addingTimeInterval(Invitation.lifetime)
            )
            return try await scope.invitation.update(invitation)
        }

        try await mailSender.send(
            .init(
                from: .init("info@binarybirds.com"),
                to: [.init(invitation.email)],
                subject: "Application - Invitation",
                body: "Open this invitation link to complete registration: \(publicBaseURL)/account/invitation/accept/?token=\(invitation.token)"
            )
        )
        return invitation.asDetail
    }
}
