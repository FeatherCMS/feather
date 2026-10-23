public struct AccessControlProvider: Event<[PermissionKey]> {
    public let roleKey: String

    public init(roleKey: String) {
        self.roleKey = roleKey
    }
}
