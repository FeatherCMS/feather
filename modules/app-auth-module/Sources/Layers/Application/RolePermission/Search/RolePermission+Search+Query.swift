public import AuthModule

extension RolePermission.Search {
    public enum Query {
        public protocol Interface: Sendable {
            func search(query: Input.Query) async throws -> Output
            func count(query: Input.Query) async throws -> Int
        }
    }
}
