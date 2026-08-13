import FeatherContracts

public struct AdminEventContext: ExecutionContext {
    public let path: String
    public let permissions: Set<String>

    public init(
        path: String,
        permissions: Set<String>
    ) {
        self.path = path
        self.permissions = permissions
    }
}
