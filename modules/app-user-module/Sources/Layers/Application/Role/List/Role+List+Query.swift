public import UserModule

extension Role.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(query: Input.Query) async throws -> Output
            func count(query: Input.Query) async throws -> Int
        }
    }
}
