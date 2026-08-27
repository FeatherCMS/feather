import AccountContracts
import AccountDomain
import FeatherApplication
import FeatherContracts

//
//  GetSettings.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

public struct GetSettings: UseCase {

    struct Action: PermissionAction {
        let key: PermissionKey
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadSettings>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadSettings>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let userId: String?

        public init(userId: String? = nil) {
            self.userId = userId
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> SettingsDetail {
        let userId = input.userId ?? subject.id
        let action = Action(
            key: userId == subject.id
                ? AccountPermissions.Settings.read
                : AccountPermissions.Settings.manage
        )
        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { scope in
            try await scope.settings.get(userId: userId).asDetail
        }
    }
}
