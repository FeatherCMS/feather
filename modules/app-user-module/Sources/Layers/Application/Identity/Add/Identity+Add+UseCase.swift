public import FeatherApplication
public import FeatherModuleKit
public import UserDomain
public import UserModule

//
//  Identity.Add.UseCase.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Identity.Add {
    public struct UseCase: FeatherApplication.UseCase {
        struct Error: UseCaseError {
            let message: String
        }

        struct Action: PermissionAction {
            let key = Identity.Permissions.create
        }

        let authorizer: any Authorizer
        let transaction:
            any ContextualTransactionExecutor<Identity.Repository.Scope>
        let events: any EventPublisher

        public init(
            authorizer: any Authorizer,
            transaction: any ContextualTransactionExecutor<
                Identity.Repository.Scope
            >,
            events: any EventPublisher
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
            self.events = events
        }

        public func execute(
            subject: Subject,
            input: Identity.Add.Input
        ) async throws -> Identity.Detail.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await transaction.run { scope, context in
                let model = try await scope.identity.insert(
                    Identity.Model.create(
                        name: input.name,
                        status: input.status
                    )
                )
                let roleIds = input.roleIds
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
                try await events.trigger(
                    event: Identity.Event.DidInsert(identityID: model.id),
                    using: context
                )
                let persistedRoleIds = try await scope.identity.findRoleIdsBy(
                    identityId: model.id
                )
                let detail = model.asDetail
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
