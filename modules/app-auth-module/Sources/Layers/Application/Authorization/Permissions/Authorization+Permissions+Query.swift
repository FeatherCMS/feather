public import AuthModule

extension Authorization.Permissions {
    public enum Query {
        public protocol Interface: Sendable {
            func getPermissionsBy(identityId: String) async throws -> [String]
        }
    }
}
