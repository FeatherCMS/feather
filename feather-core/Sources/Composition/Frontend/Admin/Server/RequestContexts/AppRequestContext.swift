//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 01..
//

import FeatherContracts
import Foundation
import Hummingbird
import OpenAPIRuntime

public struct AppRequestContext: RequestContext {

    public var coreContext: CoreRequestContextStorage

    public var sessionToken: String?
    public var account: AccountModel?

    public init(
        source: ApplicationRequestContextSource,
    ) {
        self.coreContext = .init(source: source)
    }

    public var requestDecoder: URLFormRequestDecoder {
        .init()
    }

    // MARK: -

    public func requiredID() throws -> String {
        try requiredParameter("id")
    }

    public func requiredParameter(
        _ name: String
    ) throws -> String {
        guard let value = parameters.get(name, as: String.self), !value.isEmpty
        else {
            throw HTTPError(.badRequest)
        }
        return value
    }

    public var currentUserPermissions: Set<String> {
        account?.permissionSet ?? []
    }

    public func isCurrentUserAllowed(
        to permission: PermissionKey
    ) -> Bool {
        currentUserPermissions.contains(permission.rawValue)
    }

}
