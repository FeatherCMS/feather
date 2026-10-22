public import AuthModule

extension AuthModule.Authorization.Query {
    public protocol Interface: Sendable {
        func getRolesBy(identityId: String) async throws -> [String]
        func getPermissionsBy(identityId: String) async throws -> [String]
    }
}
