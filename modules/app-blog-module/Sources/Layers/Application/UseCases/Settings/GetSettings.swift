//
//  GetSettings.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain

public struct GetSettings: UseCase {
    struct Action: PermissionAction {
        let key = BlogPermissions.Settings.read
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<WriteSettings>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<WriteSettings>
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

        let settings = try await query.run { scope in
            try await scope.settings.get()
        }
        return settings.asDetail
    }
}
