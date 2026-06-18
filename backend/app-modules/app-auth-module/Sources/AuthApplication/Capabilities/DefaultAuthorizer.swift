//
//  File.swift
//  app-auth-module
//
//  Created by Tibor Bödecs on 2026. 04. 18..
//

import Application
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
        try await query.run { context in
            // TODO: use set
            let roles = try await context.account.getRolesBy(
                accountId: subject.id
            )

            // Root is treated as a superuser and bypasses granular checks.
            if roles.contains("root") {
                return true
            }

            let permissions = try await context.rolePermissions.permissions(
                for: Set(roles)
            )

            let effectivePermissions = Self.effectivePermissions(
                from: permissions
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

        if result.contains("user:accounts:me") {
            result.insert("auth:profile:read")
            result.insert("auth:profile:update")
            result.insert("auth:settings:read")
            result.insert("auth:settings:update")
        }

        if result.contains("auth:profile:update") {
            result.insert("auth:profile:read")
        }

        if result.contains("auth:settings:update") {
            result.insert("auth:settings:read")
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
