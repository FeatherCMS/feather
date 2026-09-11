import FeatherContracts

public struct ListActions: Sendable {

    public let granted: Set<PermissionKey>

    public init(_ granted: Set<PermissionKey>) {
        self.granted = granted
    }

    public func allows(_ permission: PermissionKey) -> Bool {
        granted.contains(permission)
    }
}
