import Application

public struct ContactPermissionAction: PermissionAction {
    public let key: PermissionKey
    public init(key: PermissionKey) { self.key = key }
}
