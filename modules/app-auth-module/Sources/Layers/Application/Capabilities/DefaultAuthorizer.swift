//
//  DefaultAuthorizer.swift
//  app-auth-module
//
//  Created by Tibor Bödecs on 2026. 04. 18.
//

public import AuthModule
public import FeatherModuleKit
import UserApplication

public struct DefaultAuthorizer: Authorizer {

    let query: any QueryExecutor<AuthModule.Auth.Authorization.Scope>

    public init(
        query: any QueryExecutor<AuthModule.Auth.Authorization.Scope>
    ) {
        self.query = query
    }

    public func can(
        subject: Subject,
        perform action: any Action
    ) async throws -> Bool {
        try await query.run { scope in
            // TODO: use set in call result already.
            let permissions = try await scope.authorization.getPermissionsBy(
                identityId: subject.id
            )

            return try await action.authorize(
                subject: subject,
                permissions: Set(permissions.map { .init($0) })
            )
        }
    }
}
