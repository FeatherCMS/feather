public import AuthModule
import FeatherApplication

extension Credential.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Output
        }
    }
}
