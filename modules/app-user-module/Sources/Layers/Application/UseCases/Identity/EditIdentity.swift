import UserContracts
//
//  EditIdentity.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import UserDomain

public struct EditIdentity: UseCase {

    struct Action: PermissionAction {
        let key: PermissionKey = UserPermissions.Identities.update
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteIdentityRole>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteIdentityRole>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String
        public let roleIds: [String]?
        public let status: Identity.Status?

        public init(
            id: String,
            roleIds: [String]?,
            status: Identity.Status?
        ) {
            self.id = id
            self.roleIds = roleIds
            self.status = status
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> IdentityDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { scope in
            guard var model = try await scope.identity.findBy(id: input.id)
            else {
                throw Error(message: "Identity not found")
            }

            model.update(status: input.status)

            let updated = try await scope.identity.update(model)

            if let roleIds = input.roleIds {
                for roleId in roleIds {
                    guard try await scope.role.findBy(id: roleId) != nil
                    else {
                        throw Error(message: "Role not found: \(roleId)")
                    }
                }
                try await scope.identity.replaceRoleIds(
                    identityId: model.id,
                    roleIds: roleIds
                )
            }

            return updated
        }
        return model.asDetail
    }
}
