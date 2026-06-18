//
//  File.swift
//  app-kernel
//
//  Created by Tibor Bödecs on 2026. 04. 18..
//

public struct PermissionKey: Sendable, Hashable, Equatable {
    public let rawValue: String

    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

public protocol Action: Sendable {

    func authorize(
        subject: Subject,
        permissions: Set<PermissionKey>
    ) async throws -> Bool
}

public protocol PermissionAction: Action {
    var key: PermissionKey { get }
}

public extension PermissionAction {

    func authorize(
        subject: Subject,
        permissions: Set<PermissionKey>
    ) async throws -> Bool {
        permissions.contains(key)
    }
}

public protocol PermissionProvider {
    static func allPermissions() -> Set<PermissionKey>
}

public struct Subject: Sendable {
    public let id: String

    public init(id: String) {
        self.id = id
    }
}

public protocol Authorizer: Sendable {

    func can(
        subject: Subject,
        perform action: any Action
    ) async throws -> Bool

    //    func require(
    //        subject: Subject,
    //        perform action: any Action
    //    ) async throws
}

//public extension Authorizer {
//
//    func require(
//        subject: Subject,
//        perform action: any Action
//    ) async throws {
//        guard
//            try await can(
//                subject: subject,
//                perform: action
//            )
//        else {
//            throw AuthError(
//                kind: .forbidden,
//                message: "\(action)"
//            )
//        }
//    }
//}

public enum CurrentSubject: Sendable {

    @TaskLocal
    private static var rawValue: Subject?

    public static func set<R>(
        subject: Subject?,
        _ block: (() async throws -> R)
    ) async throws -> R {
        try await $rawValue.withValue(subject) {
            try await block()
        }
    }

    public static func unset<R>(
        _ block: (() async throws -> R)
    ) async throws -> R {
        try await $rawValue.withValue(nil) {
            try await block()
        }
    }

    public static func get() async -> Subject? {
        rawValue
    }

    public static func require() async throws(AuthError) -> Subject {
        guard let value = rawValue else {
            throw .init(kind: .unauthorized, message: "Missing subject.")
        }
        return value
    }

    public static func exists() async -> Bool {
        await get() != nil
    }
}

public struct AuthError: Error {

    public enum Kind: Sendable {
        case unauthorized
        case forbidden
    }

    public let kind: Kind
    public let message: String

    public init(
        kind: Kind,
        message: String
    ) {
        self.kind = kind
        self.message = message
    }
}
