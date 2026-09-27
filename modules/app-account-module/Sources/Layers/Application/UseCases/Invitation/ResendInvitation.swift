import AccountContracts
import AccountDomain
public import FeatherApplication
public import FeatherContracts
import SystemApplication

import struct Foundation.Date

public struct ResendInvitation: UseCase {
    private struct MailContext: Sendable {
        let invitation: Invitation
        let publicBaseURL: String
        let mailFromAddress: String
        let mailFromName: String?
    }

    struct Action: PermissionAction {
        let key = AccountPermissions.Invitations.create
    }

    public enum Error: UseCaseError {
        case invitationNotFound
        case mailFromNotConfigured

        public var message: String {
            switch self {
            case .invitationNotFound:
                "Invitation not found."
            case .mailFromNotConfigured:
                "System mail from address is not configured. Configure the system-settings-mail-from-address variable in System → Variables."
            }
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
                throw Error.invitationNotFound
            }
            guard
                let mailFromAddress = try await scope.variable.get(
                    "system-settings-mail-from-address"
                )?.whitespaceTrimmed,
                !mailFromAddress.isEmpty
            else {
                throw Error.mailFromNotConfigured
            }
            let mailFromName = try await scope.variable.get(
                "system-settings-mail-from-name"
            )?.whitespaceTrimmed.emptyToNil
            let configuredPublicBaseURL =
                try await scope.variable.get("web-settings-public-base-url")?
                .whitespaceTrimmed
            let publicBaseURL =
                configuredPublicBaseURL?.isEmpty == false
                ? configuredPublicBaseURL!
                : "http://localhost:3456"
            try invitation.renew(
                token: generateToken(),
                expiresAt: Date().addingTimeInterval(Invitation.lifetime)
            )
            return MailContext(
                invitation: try await scope.invitation.update(invitation),
                publicBaseURL: publicBaseURL,
                mailFromAddress: mailFromAddress,
                mailFromName: mailFromName
            )
        }

        try await mailSender.send(
            .init(
                from: .init(result.mailFromAddress, name: result.mailFromName),
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
