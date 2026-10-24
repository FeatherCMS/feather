public import AuthModule
import FeatherApplication

extension Credential.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(query: Input.Query) async throws -> Output
            func list(userId: String, query: Input.Query) async throws -> Output
            func count(query: Input.Query) async throws -> Int
            func count(userId: String, query: Input.Query) async throws -> Int
        }
    }
}
