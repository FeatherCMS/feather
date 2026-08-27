import AccountContracts
import AccountDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import UserApplication
import UserDomain

import Foundation

//
//  AddInvitation.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct AddInvitation: UseCase {
    enum Error: UseCaseError {
        case roleNotFound(String)

        var message: String {
            switch self {
            case .roleNotFound(let roleID):
                "Role not found: \(roleID)"
            }
        }
    }

    struct Action: PermissionAction {
        let key = AccountPermissions.Invitations.create
    }

    let authorizer: any Authorizer
    let transaction: any ContextualTransactionExecutor<WriteInvitation>
    let events: any EventPublisher
    let mailSender: any MailSender
    let publicBaseURL: String

    public init(
        authorizer: any Authorizer,
        transaction: any ContextualTransactionExecutor<WriteInvitation>,
        events: any EventPublisher,
        mailSender: any MailSender,
        publicBaseURL: String
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.events = events
        self.mailSender = mailSender
        self.publicBaseURL = publicBaseURL
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
            return invitation
        }
        try await mailSender.send(
            .init(
                from: .init("info@binarybirds.com"),
                to: [.init(model.email)],
                subject: "Application - Invitation",
                body: #"""
                    Hello,

                    You have been invited to create your application identity.
                    Open this invitation link to complete registration:

                    \#(publicBaseURL)/account/invitation/accept/?token=\#(model.token)

                    Cheers,
                    Application Team.
                    """#
            )
        )
        return model.asDetail
    }
}
