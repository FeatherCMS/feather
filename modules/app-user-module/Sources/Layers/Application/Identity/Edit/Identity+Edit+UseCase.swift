public import FeatherApplication
import FeatherDomain
public import FeatherModuleKit
import UserDomain
public import UserModule

//
//  Identity.Edit.UseCase.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Identity.Edit {
    public struct UseCase: FeatherApplication.UseCase {

        struct Error: UseCaseError {
            let message: String
        }

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Output {
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

                let currentRoleIds = try await scope.identity.findRoleIdsBy(
                    identityId: model.id
                )
                let roleIds = input.roleIds.apply(to: currentRoleIds)
                for roleId in roleIds {
                    guard try await scope.role.findBy(id: roleId) != nil
                    else {
                        throw Error(message: "Role not found: \(roleId)")
                    }
                }
                let persistedRoleIds: [String]
                if roleIds != currentRoleIds {
                    try await scope.identity.replaceRoleIds(
                        identityId: model.id,
                        roleIds: roleIds
                    )
                    persistedRoleIds = try await scope.identity.findRoleIdsBy(
                        identityId: updated.id
                    )
                }
                else {
                    persistedRoleIds = currentRoleIds
                }

                return .init(
                    id: updated.id,
                    name: updated.name,
                    roleIds: persistedRoleIds,
                    status: updated.status,
                    createdAt: updated.createdAt,
                    updatedAt: updated.updatedAt
                )
            }
        }
    }

}
