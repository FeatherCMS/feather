public import FeatherApplication
public import FeatherModuleKit
public import UserDomain
public import UserModule

//
//  Identity.Edit.UseCase.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Identity.Edit {
    public struct UseCase: FeatherApplication.UseCase {

        struct Action: PermissionAction {
            let key: PermissionKey = Identity.Permissions.update
        }

        struct Error: UseCaseError {
            let message: String
        }

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Identity.Repository.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Identity.Repository.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Identity.Edit.Input
        ) async throws -> Identity.Detail.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
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

}
