import FeatherModuleKit
public import UserModule

extension Role.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Output
        }
    }
}
