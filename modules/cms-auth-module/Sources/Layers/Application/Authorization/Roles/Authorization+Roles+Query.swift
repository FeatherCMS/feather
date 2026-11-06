public import AuthModule

extension Authorization.Roles {
    public enum Query {
        public protocol Interface: Sendable {
            func getRolesBy(identityId: String) async throws -> [String]
        }
    }
}
