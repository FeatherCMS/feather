import Foundation

public struct PermissionScope: Sendable {
    public let module: String
    public let resource: String

    public init(module: String, resource: String) {
        self.module = module
        self.resource = resource
    }

    public var create: String { permission(for: .create) }
    public var read: String { permission(for: .read) }
    public var update: String { permission(for: .update) }
    public var list: String { permission(for: .list) }
    public var delete: String { permission(for: .delete) }

    public func permission(
        for action: PermissionAction
    ) -> String {
        switch action {
        case .create:
            "\(module):\(resource):create"
        case .read:
            "\(module):\(resource):read"
        case .update:
            "\(module):\(resource):update"
        case .list:
            "\(module):\(resource):list"
        case .delete:
            "\(module):\(resource):delete"
        case .custom(let value):
            "\(module):\(resource):\(value)"
        }
    }
}
