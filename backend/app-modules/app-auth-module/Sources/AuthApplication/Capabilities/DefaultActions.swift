//
//  File.swift
//  app-auth-module
//
//  Created by Tibor Bödecs on 2026. 05. 08..
//

import Application

public struct IsAuthenticated: Action {

    public init() {}

    public func authorize(
        subject: Subject,
        permissions: Set<PermissionKey>
    ) async throws -> Bool {
        return !subject.id.isEmpty
    }
}

public struct AndAction: Action {

    private let actions: [any Action]

    public init(
        _ actions: [any Action]
    ) {
        self.actions = actions
    }

    public func authorize(
        subject: Subject,
        permissions: Set<PermissionKey>
    ) async throws -> Bool {
        for action in actions {
            let allowed = try await action.authorize(
                subject: subject,
                permissions: permissions
            )
            if !allowed {
                return false
            }
        }
        return true
    }
}

//struct IsOwner<Resource>: Action where Resource: Ownable {
//
//    let resource: Resource
//
//    func authorize(subject: Subject, ...) -> Bool {
//
//        resource.ownerId == subject.id
//
//    }
//
//}

//AndAction(
//
//    RequirePermission(.editOwnPost),
//
//    IsOwner(post)
//
//)
