public import FeatherApplication
public import FeatherModuleKit
import UserDomain
public import UserModule

//
//  Identity.Add.UseCase.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Identity.Add {
    public struct UseCase: FeatherApplication.UseCase {
        public enum Error: UseCaseError {
            case roleNotFound
        }

        let authorizer: any Authorizer
        let transaction: any ContextualTransactionExecutor<Scope>
        let events: any EventPublisher

        public init(
            authorizer: any Authorizer,
            transaction: any ContextualTransactionExecutor<
                Scope
            >,
            events: any EventPublisher
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
            self.events = events
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
                        throw Error.roleNotFound
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
                return .init(
                    id: model.id,
                    name: model.name,
                    roleIds: persistedRoleIds,
                    status: model.status,
                    createdAt: model.createdAt,
                    updatedAt: model.updatedAt
                )
            }
        }
    }

}
