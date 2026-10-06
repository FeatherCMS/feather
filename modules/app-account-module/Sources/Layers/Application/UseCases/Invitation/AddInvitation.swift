import AccountContracts
import AccountDomain
public import FeatherApplication
public import FeatherContracts
import FeatherMail
import SystemApplication
import UserApplication
import UserDomain

//
//  AddInvitation.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct AddInvitation: UseCase {
    enum Error: UseCaseError {
        case roleNotFound(String)
        case mailFromNotConfigured

        var message: String {
            switch self {
            case .roleNotFound(let roleID):
                "Role not found: \(roleID)"
            case .mailFromNotConfigured:
                "System mail from address is not configured. Configure the system-settings-mail-from-address variable in System → Variables."
            }
        }
    }

    private struct MailContext: Sendable {
        let invitation: Invitation
        let publicBaseURL: String
        let mailFromAddress: String
        let mailFromName: String?
    }

    struct Action: PermissionAction {
        let key = AccountPermissions.Invitations.create
    }

    let authorizer: any Authorizer
    let transaction:
        any ContextualTransactionExecutor<WriteInvitationWithVariable>
    let events: any EventPublisher
    let jobs: any SendMailJobController

    public init(
        authorizer: any Authorizer,
        transaction: any ContextualTransactionExecutor<
            WriteInvitationWithVariable
        >,
        events: any EventPublisher,
        jobs: any SendMailJobController
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.events = events
        self.jobs = jobs
    }

    public struct Input: DTO {
        public let email: String
        public let roleIDs: [String]

        public init(email: String, roleIDs: [String] = []) {
            self.email = email
            self.roleIDs = roleIDs
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

        let model = try await transaction.run { scope, context in
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
            let identityRepository = scope.identity
            let roleRepository = scope.role
            let token = generateToken()
            let identity = try await identityRepository.insert(
                Identity.create(status: .invited)
            )
            for roleID in input.roleIDs {
                guard try await roleRepository.findBy(id: roleID) != nil else {
                    throw Error.roleNotFound(roleID)
                }
            }
            try await identityRepository.replaceRoleIds(
                identityId: identity.id,
                roleIds: input.roleIDs
            )
            let invitation = try await scope.invitation.insert(
                Invitation.create(
                    userId: identity.id,
                    email: input.email,
                    token: token,
                    roleIDs: input.roleIDs
                )
            )
            try await events.trigger(
                event: UserIdentityDidInsert(identityID: identity.id),
                using: context
            )
            let configuredPublicBaseURL =
                try await scope.variable.get("web-settings-public-base-url")?
                .whitespaceTrimmed
            let publicBaseURL =
                configuredPublicBaseURL?.isEmpty == false
                ? configuredPublicBaseURL!
                : "http://localhost:3456"
            return MailContext(
                invitation: invitation,
                publicBaseURL: publicBaseURL,
                mailFromAddress: mailFromAddress,
                mailFromName: mailFromName
            )
        }

        try await jobs.enqueue(
            .init(
                from: .init(model.mailFromAddress, name: model.mailFromName),
                to: [.init(model.invitation.email)],
                subject: "Application - Invitation",
                body: .plainText(
                    #"""
                    Hello,

                    You have been invited to create your application identity.
                    Open this invitation link to complete registration:

                    \#(model.publicBaseURL)/account/invitation/accept/?token=\#(model.invitation.token)

                    Cheers,
                    Application Team.
                    """#
                )
            )
        )
        return model.invitation.asDetail
    }
}
