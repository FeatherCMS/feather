//
//  EditAccountSettings.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AccountDomain
import Application

public struct EditAccountSettings: UseCase {

    struct Action: PermissionAction {
        let key = AccountSettingsPermissions.Settings.update
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteAccountSettings>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteAccountSettings>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let language: String
        public let timezone: String
        public let pageSize: Int

        public init(
            language: String,
            timezone: String,
            pageSize: Int
        ) {
            self.language = language
            self.timezone = timezone
            self.pageSize = pageSize
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> AccountSettingsDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { context in
            var model = try await context.queries.get(accountID: subject.id)
            try model.update(
                language: input.language,
                timezone: input.timezone,
                pageSize: input.pageSize
            )
            return try await context.settings.update(model)
        }
        return model.asDetail
    }
}
