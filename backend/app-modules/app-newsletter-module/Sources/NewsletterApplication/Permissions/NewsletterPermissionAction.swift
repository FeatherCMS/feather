import Application

public struct NewsletterPermissionAction: PermissionAction {
    public let key: PermissionKey
    public init(key: PermissionKey) { self.key = key }
}
