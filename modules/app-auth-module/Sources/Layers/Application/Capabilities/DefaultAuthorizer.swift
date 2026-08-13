//
//  DefaultAuthorizer.swift
//  app-auth-module
//
//  Created by Tibor Bödecs on 2026. 04. 18.
//

import FeatherApplication
import FeatherContracts
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
            // TODO: use set
            let permissions = try await scope.identity.getPermissionsBy(
                identityId: subject.id
            )

            let effectivePermissions = Self.effectivePermissions(
                from: Set(permissions)
            )

            return try await action.authorize(
                subject: subject,
                permissions: Set(
                    effectivePermissions.map { .init($0) }
                )
            )
        }
    }

    private static func effectivePermissions(
        from permissions: Set<String>
    ) -> [String] {
        var result = permissions

        if result.contains("user:identities:me") {
            result.insert("auth:profile:read")
            result.insert("auth:profile:update")
            result.insert("identity:settings:read")
            result.insert("identity:settings:update")
        }

        if result.contains("auth:profile:update") {
            result.insert("auth:profile:read")
        }

        if result.contains("identity:settings:update") {
            result.insert("identity:settings:read")
        }
        if result.contains("web:settings:update") {
            result.insert("web:settings:read")
        }
        if result.contains("blog:settings:update") {
            result.insert("blog:settings:read")
        }

        return Array(result)
    }
}
