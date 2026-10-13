//
//  DefaultAuthorizer.swift
//  app-auth-module
//
//  Created by Tibor Bödecs on 2026. 04. 18.
//

public import FeatherContracts
import UserApplication

public struct DefaultAuthorizer: Authorizer {

    let query: any QueryExecutor<AuthScope>

    public init(
        query: any QueryExecutor<AuthScope>
    ) {
        self.query = query
    }

    public func can(
        subject: Subject,
        perform action: any Action
    ) async throws -> Bool {
        try await query.run { scope in
            // TODO: use set in call result already.
            let permissions = try await scope.identity.getPermissionsBy(
                identityId: subject.id
            )

            return try await action.authorize(
                subject: subject,
                permissions: Set(permissions.map { .init($0) })
            )
        }
    }
}
