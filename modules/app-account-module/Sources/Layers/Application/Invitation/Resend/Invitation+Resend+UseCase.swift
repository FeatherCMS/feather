import AccountDomain
public import AccountModule
public import FeatherApplication
import FeatherMail
public import FeatherModuleKit
import SystemApplication

import struct Foundation.Date

extension Invitation.Resend {
    public struct UseCase: FeatherApplication.UseCase {
        private struct MailContext: Sendable {
            let invitation: Invitation.Model
            let publicBaseURL: String
            let mailFromAddress: String
            let mailFromName: String?
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
        let transaction: any TransactionExecutor<Invitation.Resend.Scope>
        let jobs: any SendMailJobController

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Invitation.Resend.Scope>,
            jobs: any SendMailJobController
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
            self.jobs = jobs
        }

        public func execute(
            subject: Subject,
            input: Invitation.Resend.Input
        ) async throws -> Invitation.Detail.Output {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let result = try await transaction.run { scope in
                guard
                    var invitation = try await scope.invitation.findBy(
                        id: input.id
                    )
                else {
                    throw Error.invitationNotFound
                }
                guard
                    let mailFromAddress = try await scope.variable.get(
                        "system-settings-mail-from-address"
                    )?
                    .whitespaceTrimmed,
                    !mailFromAddress.isEmpty
                else {
                    throw Error.mailFromNotConfigured
                }
                let mailFromName = try await scope.variable.get(
                    "system-settings-mail-from-name"
                )?
                .whitespaceTrimmed.emptyToNil
                let configuredPublicBaseURL =
                    try await scope.variable.get(
                        "web-settings-public-base-url"
                    )?
                    .whitespaceTrimmed
                let publicBaseURL =
                    configuredPublicBaseURL?.isEmpty == false
                    ? configuredPublicBaseURL!
                    : "http://localhost:3456"
                try invitation.renew(
                    token: Invitation.Token.generate(),
                    expiresAt: Date()
                        .addingTimeInterval(Invitation.Model.lifetime)
                )
                return MailContext(
                    invitation: try await scope.invitation.update(invitation),
                    publicBaseURL: publicBaseURL,
                    mailFromAddress: mailFromAddress,
                    mailFromName: mailFromName
                )
            }

            try await jobs.enqueue(
                .init(
                    from: .init(
                        result.mailFromAddress,
                        name: result.mailFromName
                    ),
                    to: [.init(result.invitation.email)],
                    subject: "Application - Invitation",
                    body: .plainText(
                        """
                        Hello,

                        This is a reminder for your application identity invitation.
                        Open this invitation link to complete registration:

                        \(result.publicBaseURL)/account/invitation/accept/?token=\(result.invitation.token)

                        Cheers,
                        Application Team.
                        """
                    )
                )
            )
            return .init(
                id: result.invitation.id,
                userId: result.invitation.userId,
                email: result.invitation.email,
                token: result.invitation.token,
                roleIDs: result.invitation.roleIDs,
                expiresAt: result.invitation.expiresAt,
                createdAt: result.invitation.createdAt,
                updatedAt: result.invitation.updatedAt
            )
        }
    }
}
