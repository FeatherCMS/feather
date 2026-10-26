import FeatherModuleKit
public import UserModule

extension Identity.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Output
        }
    }
}
