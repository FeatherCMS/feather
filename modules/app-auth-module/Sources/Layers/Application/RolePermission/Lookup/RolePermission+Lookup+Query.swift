public import AuthModule

extension RolePermission.Lookup {
    public enum Query {}
}

extension RolePermission.Lookup.Query {
    public protocol Interface: Sendable {
        func permissions(for roleIds: Set<String>) async throws -> Set<String>
    }
}
