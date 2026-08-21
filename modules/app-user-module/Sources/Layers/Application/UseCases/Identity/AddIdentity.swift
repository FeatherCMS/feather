import FeatherApplication
import FeatherContracts
import UserContracts
import UserDomain

//
//  AddIdentity.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct AddIdentity: UseCase {
    struct Action: PermissionAction {
        let key = UserPermissions.Identities.create
    }

    let authorizer: any Authorizer
    let transaction: any ContextualTransactionExecutor<WriteIdentity>
    let events: any EventPublisher

    public init(
        authorizer: any Authorizer,
        transaction: any ContextualTransactionExecutor<WriteIdentity>,
        events: any EventPublisher
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
        self.events = events
    }

    public struct Input: DTO {
        public let status: Identity.Status

        public init(
            status: Identity.Status
        ) {
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

        return try await transaction.run { scope, context in
            let model = try await scope.identity.insert(
                Identity.create(status: input.status)
            )
            try await events.trigger(
                event: UserIdentityDidInsert(identityID: model.id),
                using: context
            )
            return model.asDetail
        }
    }
}
