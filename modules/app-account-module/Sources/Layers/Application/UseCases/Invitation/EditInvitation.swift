import AccountContracts
import AccountDomain
import AuthDomain
public import FeatherApplication
public import FeatherContracts
import UserDomain

//
//  EditInvitation.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct EditInvitation: UseCase {
    struct Action: PermissionAction {
        let key = AccountPermissions.Invitations.update
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteInvitationOnly>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteInvitationOnly>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let email: String?
        public let roleIDs: [String]?

        public init(
            id: String,
            email: String?,
            roleIDs: [String]? = nil
        ) {
            self.id = id
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

        let model = try await transaction.run { scope in
            guard var model = try await scope.invitation.findBy(id: input.id)
            else {
                throw Error(message: "Invitation not found")
            }

            for roleID in input.roleIDs ?? [] {
                guard try await scope.role.findBy(id: roleID) != nil else {
                    throw Error(message: "Role not found: \(roleID)")
                }
            }

            let previousEmail = model.email
            try model.update(email: input.email, roleIDs: input.roleIDs)
            if previousEmail != model.email,
                let identity = try await scope.identity.findBy(
                    id: model.userId
                ),
                identity.status == .invited
            {
                if var authEmail = try await scope.authEmail.findBy(
                    email: previousEmail
                ), authEmail.identityId == identity.id {
                    authEmail.email = model.email
                    _ = try await scope.authEmail.update(authEmail)
                }
                else {
                    _ = try await scope.authEmail.insert(
                        identityId: identity.id,
                        email: model.email
                    )
                }
            }
            return try await scope.invitation.update(model)
        }

        return model.asDetail
    }
}
