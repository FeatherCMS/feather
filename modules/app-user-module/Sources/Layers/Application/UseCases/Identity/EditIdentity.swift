public import FeatherApplication
public import FeatherContracts
import UserContracts
public import UserDomain

//
//  EditIdentity.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

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
        public let name: String?
        public let roleIds: [String]?
        public let status: Identity.Status?

        public init(
            id: String,
            name: String? = nil,
            roleIds: [String]?,
            status: Identity.Status?
        ) {
            self.id = id
            self.name = name
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

        return try await transaction.run { scope in
            guard var model = try await scope.identity.findBy(id: input.id)
            else {
                throw Error(message: "Identity not found")
            }

            model.update(name: input.name, status: input.status)

            let updated = try await scope.identity.update(model)

            let roleIds = input.roleIds ?? []
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

            let persistedRoleIds = try await scope.identity.findRoleIdsBy(
                identityId: updated.id
            )
            let detail = updated.asDetail
            return .init(
                id: detail.id,
                name: detail.name,
                roleIds: persistedRoleIds,
                status: detail.status,
                createdAt: detail.createdAt,
                updatedAt: detail.updatedAt
            )
        }
    }
}
