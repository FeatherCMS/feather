import FeatherApplication
import FeatherContracts
import FeatherDomain
import RedirectContracts
import RedirectDomain

//
//  RemoveRule.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct RemoveRule: UseCase {
    struct Action: PermissionAction {
        let key = RedirectPermissions.Rules.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteRule>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteRule>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let ids: [String]

        public init(ids: [String]) {
            self.ids = ids
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> [String] {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await transaction.run { scope in
            try await scope.rule.delete(ids: input.ids)
        }
    }
}
