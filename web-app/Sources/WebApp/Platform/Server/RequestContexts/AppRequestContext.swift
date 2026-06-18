//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 01..
//

import Foundation
import Hummingbird
import OpenAPIRuntime

struct AppRequestContext: RequestContext {

    var coreContext: CoreRequestContextStorage

    init(
        source: ApplicationRequestContextSource,
    ) {
        self.coreContext = .init(source: source)
    }

    var sessionToken: String?
    var account: AccountModel?

    var currentUserPermissions: Set<String> {
        account?.permissionSet ?? []
    }

    var requestDecoder: URLFormRequestDecoder {
        .init()
    }

    func applicationAPI() -> ApplicationAPI {
        .init(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: sessionToken
        )
    }

    func managementAPI() -> AdminAPI {
        .init(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: sessionToken
        )
    }

    // MARK: -

    func requiredID() throws -> String {
        try requiredParameter("id")
    }

    func requiredParameter(
        _ name: String
    ) throws -> String {
        guard let value = parameters.get(name, as: String.self), !value.isEmpty
        else {
            throw HTTPError(.badRequest)
        }
        return value
    }

    func hasPermission(
        _ permission: String
    ) -> Bool {
        currentUserPermissions.contains(permission)
    }

    func isCurrentUserAllowed(
        to action: PermissionAction,
        scope: PermissionScope
    ) -> Bool {
        hasPermission(scope.permission(for: action))
    }

}
