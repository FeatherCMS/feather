//
//  GetSettings.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import AccountDomain
import FeatherApplication
import FeatherContracts

public struct GetSettings: UseCase {

    struct Action: PermissionAction {
        let key = SettingsPermissions.Settings.read
    }

    let authorizer: any Authorizer
    let query: any TransactionExecutor<WriteSettings>

    public init(
        authorizer: any Authorizer,
        query: any TransactionExecutor<WriteSettings>
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
    ) async throws -> SettingsDetail {
        let action = Action()
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { scope in
            try await scope.settings.getOrCreate(userId: subject.id).asDetail
        }
    }
}
