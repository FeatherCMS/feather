import AccountContracts
import AccountDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
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
        case publicBaseURLNotConfigured

        var message: String {
            switch self {
            case .roleNotFound(let roleID):
                "Role not found: \(roleID)"
            case .publicBaseURLNotConfigured:
                "The public site URL is not configured."
            }
        }
    }

    struct Action: PermissionAction {
        let key = AccountPermissions.Invitations.create
    }

    let authorizer: any Authorizer
    let transaction:
        any ContextualTransactionExecutor<WriteInvitationWithVariable>
    let events: any EventPublisher
    let mailSender: any MailSender

    public init(
        authorizer: any Authorizer,
        transaction: any ContextualTransactionExecutor<
            WriteInvitationWithVariable
        >,
        events: any EventPublisher,
        mailSender: any MailSender
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.events = events
        self.mailSender = mailSender
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
            guard
                let publicBaseURL = try await scope.variable.get(
                    "web-settings-public-base-url"
                ),
                !publicBaseURL.isEmpty
            else {
                throw Error.publicBaseURLNotConfigured
            }
            return (invitation: invitation, publicBaseURL: publicBaseURL)
        }

        try await mailSender.send(
            .init(
                from: .init("info@binarybirds.com"),
                to: [.init(model.invitation.email)],
                subject: "Application - Invitation",
                body: #"""
                    Hello,

                    You have been invited to create your application identity.
                    Open this invitation link to complete registration:

                    \#(model.publicBaseURL)/account/invitation/accept/?token=\#(model.invitation.token)

                    Cheers,
                    Application Team.
                    """#
            )
        )
        return model.invitation.asDetail
    }
}
