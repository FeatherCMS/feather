//
//  GetAccountSettings.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AccountDomain
import Application

public struct GetAccountSettings: UseCase {

    struct Action: PermissionAction {
        let key = AccountSettingsPermissions.Settings.read
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadAccountSettings>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadAccountSettings>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public init() {}
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> AccountSettingsDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { context in
            try await context.settings.get(accountID: subject.id).asDetail
        }
    }
}
