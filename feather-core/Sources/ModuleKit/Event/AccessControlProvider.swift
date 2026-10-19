public struct AccessControlProvider: Event {
    public typealias Output = [PermissionKey]

    public let roleKey: String

    public init(roleKey: String) {
        self.roleKey = roleKey
    }
}
