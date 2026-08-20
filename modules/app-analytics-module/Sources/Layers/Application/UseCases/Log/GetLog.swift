import AnalyticsContracts
//
//  GetLog.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain

public struct GetLog: UseCase {
    struct Action: PermissionAction {
        let key = AnalyticsPermissions.Logs.list
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadLog>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadLog>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let id: String

        public init(id: String) {
            self.id = id
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> LogDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await query.run { scope in
            try await scope.log.find(id: input.id)
        }
    }
}
