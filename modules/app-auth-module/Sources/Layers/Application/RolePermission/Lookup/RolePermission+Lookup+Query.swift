public import AuthModule

extension RolePermission.Lookup {
    public enum Query {
        public protocol Interface: Sendable {
            func permissions(for roleIds: Set<String>) async throws -> Set<
                String
            >
        }
    }
}
