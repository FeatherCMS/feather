enum PermissionAction: Sendable {
    case create
    case read
    case update
    case list
    case delete
    case custom(String)
}
