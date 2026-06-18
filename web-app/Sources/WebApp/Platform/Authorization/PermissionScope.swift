import Foundation

struct PermissionScope: Sendable {
    let module: String
    let resource: String

    var create: String { permission(for: .create) }
    var read: String { permission(for: .read) }
    var update: String { permission(for: .update) }
    var list: String { permission(for: .list) }
    var delete: String { permission(for: .delete) }

    func permission(
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
